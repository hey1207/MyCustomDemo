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
@end

@implementation HealthyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self loadData];
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
}
-(void)loadData{
    NSDictionary *param = [NSDictionary dictionaryWithObject:self.titleStr forKey:@"tid"];
    [LCProgressHUD showLoading:@""];
    [[HYDataService sharedClient] requestWithUrlString:Health_Search_Url parameters:param method:REQUEST_METHOD_POST success:^(id response, NSError *error) {
        HealthModel *healthModel = [HealthModel mj_objectWithKeyValues:response[@"pagebean"]];
        [self.modelArray addObjectsFromArray:healthModel.contentlist];
        [LCProgressHUD hide];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        
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
    
    HYWKViewController *myWKWebView = [[HYWKViewController alloc] init];
    [self.navigationController pushViewController:myWKWebView animated:YES];
    [myWKWebView loadRequestWithUrlString:list.wapurl methodStyle:METHOD_STYLE_WKWebView];
}
-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
        _mainTableView.estimatedRowHeight = 50; //先估计一个高度
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
