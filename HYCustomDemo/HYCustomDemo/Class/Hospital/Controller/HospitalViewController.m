//
//  HomeViewController.m
//  MyHospitalDemo
//
//  Created by HY on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HospitalViewController.h"
#import "HospitalCell.h"
#import "HosDetailViewController.h"
#import "LZCityPickerView.h"
#import "LZCityPickerController.h"

@interface HospitalViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,assign) NSInteger curPage;
@property (nonatomic,copy) NSString *hostName; //医院名
@property (nonatomic,copy) NSString *province; //省
@property (nonatomic,copy) NSString *city; //市
@property (nonatomic,assign) BOOL isSearch;
@end

@implementation HospitalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //第一次从本地加载数据，以后会做成缓存
    [self loadDataFromPlist];

    [self.view addSubview:self.mainTableView];

    //设置导航栏 titleView
    [self setBarButtonItem];
    
    self.curPage = 1;
    
    __weak typeof(self) weakSelf = self;
    //下拉刷新
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithPage:1 hosName:self.hostName province:self.province city:self.city];
    }];
    //下拉加载更多
    self.mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.curPage ++;
        [self loadDataWithPage:self.curPage hosName:self.hostName province:self.province city:self.city];
    }];
}
//第一次从本地读取
-(void)loadDataFromPlist{
    [LCProgressHUD showLoading:@""];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *hospitalPath = [[NSBundle mainBundle] pathForResource:@"hospital" ofType:@"plist"];
        [self.modelArray addObjectsFromArray:[[NSArray alloc] initWithContentsOfFile:hospitalPath]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD hide];
            [self.mainTableView reloadData];
        });
    });
}
//请求数据
-(void)loadDataWithPage:(NSInteger)page hosName:(NSString *)hostName province:(NSString *)province city:(NSString *)city{
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setObject:@"43039" forKey:@"showapi_appid"];
    [paramer setObject:@"587ee3b043534ddf973ccd5bd5964ced" forKey:@"showapi_sign"];
    [paramer setObject:@"10" forKey:@"limit"];
    [paramer setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    [paramer setObject:hostName?hostName:@"" forKey:@"hosName"];
    [paramer setObject:province?province:@"北京" forKey:@"provinceName"];
    [paramer setObject:city?city:@"朝阳" forKey:@"cityName"];

    [LCProgressHUD showLoading:@""];
    [HYNetWorking PostWithURL:Search_Url Params:paramer success:^(id responseObject) {
        NSArray *tempArray = [[responseObject objectForKey:@"showapi_res_body"] objectForKey:@"hospitalList"];
        if (tempArray.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *remark = [[responseObject objectForKey:@"showapi_res_body"] objectForKey:@"remark"];
                [LCProgressHUD showMessage:remark];
            });
        }else{
            if (self.isSearch) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.searchBar resignFirstResponder];
                });
                [self.modelArray removeAllObjects];
                self.mainTableView.contentOffset = CGPointMake(0, 0);
            }
        }

        [self.modelArray addObjectsFromArray:tempArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD hide];
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            [self.mainTableView reloadData];
        });
    } failure:^(NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD hide];
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
        });
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"identifier";
    HospitalCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HospitalCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell= (HospitalCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"HospitalCell" owner:self options:nil] lastObject];
    }
    cell.infoDic = self.modelArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HosDetailViewController *hosDetailVC = [[HosDetailViewController alloc] init];
    hosDetailVC.hosID = [self.modelArray[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:hosDetailVC animated:YES];
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height-64) style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
        _mainTableView.estimatedRowHeight = 210; //先估计一个高度
    }
    return _mainTableView;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)setBarButtonItem{
    //隐藏导航栏上的返回按钮
    [self.navigationItem setHidesBackButton:NO];
    //用来放searchBar的View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width, 30)];
    //创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 130, 30)];
    //默认提示文字
    searchBar.placeholder = @"搜索医院";
    //背景图片
    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    //代理
    searchBar.delegate = self;
    //显示右侧取消按钮
    searchBar.showsCancelButton = YES;
    //光标颜色
//    searchBar.tintColor = UIColorFromRGB(0x595959);
    //拿到searchBar的输入框
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    //字体大小
    searchTextField.font = [UIFont systemFontOfSize:15];
    //输入框背景颜色
    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    //拿到取消按钮
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //设置按钮上的文字
    [cancleBtn setTitle:@"" forState:UIControlStateNormal];
    //设置按钮上文字的颜色
//    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    
    titleView.userInteractionEnabled = YES;
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(searchBar.frame)-20, 0, 120, 30)];
    cityLabel.text = @"请选择地区";
    cityLabel.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    cityLabel.adjustsFontSizeToFitWidth = YES;
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.font = [UIFont systemFontOfSize:14];
    cityLabel.layer.masksToBounds = YES;
    cityLabel.layer.cornerRadius = 5;
    [titleView addSubview:cityLabel];
    self.cityLabel = cityLabel;
    cityLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCityLabel)];
    [self.cityLabel addGestureRecognizer:tap];
    
    self.navigationItem.titleView = titleView;
}
-(void)clickCityLabel{
    __weak typeof(self) weakSelf = self;
    [LZCityPickerController showPickerInViewController:self selectBlock:^(NSString *address, NSString *province, NSString *city, NSString *area) {
        // 选择结果回调
        self.isSearch = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.cityLabel.text = [NSString stringWithFormat:@"%@%@",city,area];
        });
        weakSelf.hostName = @"";
        weakSelf.province = city;
        weakSelf.city = area;
        [weakSelf loadDataWithPage:weakSelf.curPage hosName:weakSelf.hostName province:weakSelf.province city:weakSelf.city];
    }];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"SearchButton");
    self.isSearch = YES;
    self.hostName = searchBar.text;
    self.province = @"";
    self.city = @"";
    [self loadDataWithPage:self.curPage hosName:self.hostName province:self.province city:self.city];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
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
