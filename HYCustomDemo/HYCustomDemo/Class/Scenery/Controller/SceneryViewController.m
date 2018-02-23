//
//  SceneryViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SceneryViewController.h"
#import "SceneryModel.h"
#import "SceneryCell.h"
#import "ProvinceCell.h"
#import "HYPictureViewController.h"
#import "SceneryDetailVC.h"

@interface SceneryViewController ()<PYSearchViewControllerDataSource,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *leftTableView; //省列表
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) NSMutableArray *leftArray;
@property (nonatomic,strong) NSMutableArray *rightArray;
@property (nonatomic,strong) NSMutableArray *cityArray;

@property (nonatomic,copy) NSString *proID; //省
@property (nonatomic,copy) NSString *keyword; //搜索关键字
@property (nonatomic,assign) NSInteger curPage; //当前页
@property (nonatomic,assign) NSIndexPath *curIndexPath; //当前选中行
@end

@implementation SceneryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavTitleH(@"景点大全");
    
    self.curPage = 1;
    
    //加载省数据
    [self loadProvinceData];
    //创建顶部搜索
    [self createSearchButton];
    //左侧tableView
    [self.view addSubview:self.leftTableView];
    self.leftTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0).widthIs(60);
    //右侧tableView
    [self.view addSubview:self.rightTableView];
    self.rightTableView.sd_layout.leftSpaceToView(self.leftTableView, 0).topEqualToView(self.leftTableView).rightSpaceToView(self.view, 0).bottomEqualToView(self.leftTableView);
    //下拉刷新
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadSceneryData:self.proID page:1 keyword:self.keyword];
    }];
    //下拉加载
    self.rightTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.curPage ++ ;
        [self loadSceneryData:self.proID page:self.curPage keyword:self.keyword];
    }];
}
-(void)loadProvinceData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *hospitalPath = [[NSBundle mainBundle] pathForResource:@"scenery_city" ofType:@"plist"];
        [self.leftArray addObjectsFromArray:[[NSArray alloc] initWithContentsOfFile:hospitalPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftTableView reloadData];
            //默认第一行选中（上海）
            self.curIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.leftTableView selectRowAtIndexPath:self.curIndexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
            //实现点击第一行所调用的方法
            [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        });
    });
    //网络加载province
//    [[HYDataService sharedClient] requestWithUrlString:Scenery_Province_Url parameters:nil method:REQUEST_METHOD_POST success:^(id response, NSError *error) {
//        [self.leftArray addObjectsFromArray:response[@"list"]];
//        [self.leftTableView reloadData];
//    } failure:^(NSError *error) {
//    }];
}

-(void)loadSceneryData:(NSString *)proID page:(NSInteger)page keyword:(NSString *)keyword{
    if (page == 1) {
        [self.rightArray removeAllObjects];
    }
    [LCProgressHUD showLoading:@""];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:proID forKey:@"proId"];
    [parameter setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    [parameter setObject:keyword forKey:@"keyword"];
    
    [[HYDataService sharedClient] requestWithUrlString:Scenery_Search_Url parameters:parameter method:REQUEST_METHOD_POST success:^(id response, NSError *error) {
        [LCProgressHUD hide];
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
        
        //搜索
        if (self.keyword.length>0) {
            [self.leftTableView deselectRowAtIndexPath:self.curIndexPath animated:YES];
            [self.rightArray removeAllObjects];
            [self.rightTableView reloadData];
        }
        
        SceneryModel *sceneryModel = [SceneryModel mj_objectWithKeyValues:response[@"pagebean"]];
        [self.rightArray addObjectsFromArray:sceneryModel.contentlist];
        [self.rightTableView reloadData];
    } failure:^(NSError *error) {
        [LCProgressHUD hide];
        [self.rightTableView.mj_header endRefreshing];
        [self.rightTableView.mj_footer endRefreshing];
    }];
}
#pragma mark ---------UITableViewDelegate---------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.leftArray.count;
    }else if(tableView == self.rightTableView){
        return self.rightArray.count;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        ProvinceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell" forIndexPath:indexPath];
        cell.dic = self.leftArray[indexPath.row];
        return cell;
    }else if(tableView == self.rightTableView){
        SceneryCell *cell = (SceneryCell *)[[[NSBundle mainBundle] loadNibNamed:@"SceneryCell" owner:self options:nil] lastObject];
        S_Contentlist *contentlist = self.rightArray[indexPath.row];
        cell.s_contentlist = contentlist;
        cell.tapImageViewBlock = ^{
            HYPictureViewController *hyPictureVC = [[HYPictureViewController alloc] init];
            hyPictureVC.picArray = contentlist.picList;
            [self.navigationController pushViewController:hyPictureVC animated:YES];
        };
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        self.curIndexPath = indexPath;
        self.proID = [self.leftArray[indexPath.row] objectForKey:@"id"];
        self.curPage = 1;
        self.keyword = @"";
        [self loadSceneryData:self.proID page:self.curPage keyword:self.keyword];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        SceneryDetailVC *sceneryDetailVC = [[SceneryDetailVC alloc] init];
        sceneryDetailVC.contentlist = self.rightArray[indexPath.row];
        [self.navigationController pushViewController:sceneryDetailVC animated:YES];
    }
}

-(void)createSearchButton{
    UIButton *searchButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightitem=[[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem=rightitem;
}
#pragma mark ---------PYSearch--------
-(void)searchButtonAction:(UIButton *)button{
    NSArray *hotSeaches = @[@"故宫", @"圆明园",@"颐和园",@"北海", @"天坛", @"长城",@"南锣鼓巷"];
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索景点" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        [self dismissViewControllerAnimated:YES completion:^{
            self.proID = @"";
            self.curPage = 1;
            self.keyword = searchText;
            [self loadSceneryData:self.proID page:self.curPage keyword:searchText];
        }];
    }];
    searchViewController.hotSearchStyle = PYHotSearchStyleDefault;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleNormalTag;
    searchViewController.dataSource = self;

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
}
#pragma mark ---------懒加载---------
-(UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] init];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[ProvinceCell class] forCellReuseIdentifier:@"leftCell"];
        _leftTableView.rowHeight = 40;
    }
    return _leftTableView;
}
-(UITableView *)rightTableView{
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] init];
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.tableFooterView = [UIView new];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [_rightTableView registerClass:[SceneryCell class] forCellReuseIdentifier:@"rightCell"];
        _rightTableView.rowHeight = UITableViewAutomaticDimension;
        _rightTableView.estimatedRowHeight = 210; //先估计一个高度
    }
    return _rightTableView;
}

-(NSMutableArray *)leftArray{
    if (!_leftArray) {
        _leftArray = [NSMutableArray array];
    }
    return _leftArray;
}
-(NSMutableArray *)rightArray{
    if (!_rightArray) {
        _rightArray = [NSMutableArray array];
    }
    return _rightArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
