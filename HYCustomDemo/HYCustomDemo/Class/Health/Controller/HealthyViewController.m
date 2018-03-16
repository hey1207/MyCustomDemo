//
//  HealthyViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HealthyViewController.h"
#import "HealthCell.h"
#import "HealthModel.h"

@interface HealthyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation HealthyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.currentPage = 1;
    [self loadDataWithPage:self.currentPage];
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    //空白页
    [self.mainTableView setupEmptyDataText:@"木有更多数据" verticalOffset:30 emptyImage:[UIImage imageNamed:@"none"] tapBlock:^{
        [self loadDataWithPage:1];
    }];
    //刷新
    __weak typeof(self) weakself = self;
    [self.mainTableView setRefreshWithHeaderBlock:^{
        weakself.currentPage = 1;
        [weakself.modelArray removeAllObjects];
        [weakself loadDataWithPage:weakself.currentPage];
    } footerBlock:^{
        weakself.currentPage ++;
        [weakself loadDataWithPage:weakself.currentPage];
    }];
}
-(void)loadDataWithPage:(NSInteger)page{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:self.titleStr forKey:@"tid"];
    [parameter setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"page"];
    
    [LCProgressHUD showLoading:@""];
    [[HYDataService sharedClient] requestWithUrlString:Health_Search_Url parameters:parameter method:REQUEST_METHOD_POST success:^(id response, NSError *error) {
        [LCProgressHUD hide];
        [self.mainTableView footerEndRefreshing];
        [self.mainTableView headerEndRefreshing];
        
        HealthModel *healthModel = [HealthModel mj_objectWithKeyValues:response[@"pagebean"]];
        [self.modelArray addObjectsFromArray:healthModel.contentlist];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        [LCProgressHUD hide];
        [self.mainTableView footerEndRefreshing];
        [self.mainTableView headerEndRefreshing];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthCell *cell = (HealthCell *)[[[NSBundle mainBundle] loadNibNamed:@"HealthCell" owner:self options:nil] lastObject];
    cell.list = self.modelArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    H_contentlist *list = self.modelArray[indexPath.row];
    
//    HYWKViewController *myWKWebView = [[HYWKViewController alloc] init];
//    [self.navigationController pushViewController:myWKWebView animated:YES];
//    [myWKWebView loadRequestWithUrlString:list.wapurl methodStyle:METHOD_STYLE_WKWebView];
    
    WHWebViewController *whWebView = [[WHWebViewController alloc] init];
    whWebView.urlString = list.wapurl;
    [self.navigationController pushViewController:whWebView animated:YES];
    
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.rowHeight = 90; 
    }
    return _mainTableView;
}
-(NSMutableArray *)modelArray{
    if(!_modelArray){
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
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
