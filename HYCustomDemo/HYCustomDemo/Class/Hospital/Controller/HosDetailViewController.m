//
//  HosDetailViewController.m
//  MyHospitalDemo
//
//  Created by HY on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HosDetailViewController.h"
#import "HosDetailCell.h"

@interface HosDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSDictionary *infoDic;
@end

@implementation HosDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NavTitleH(@"医院信息");
    
    [self loadData];
    [self.view addSubview:self.mainTableView];
}

-(void)loadData{
    NSMutableDictionary *paramer = [NSMutableDictionary dictionary];
    [paramer setObject:@"43039" forKey:@"showapi_appid"];
    [paramer setObject:@"587ee3b043534ddf973ccd5bd5964ced" forKey:@"showapi_sign"];
    [paramer setObject:self.hosID forKey:@"id"];
    [LCProgressHUD showLoading:@""];
    [HYNetWorking PostWithURL:Hospital_Detail_Url Params:paramer success:^(id responseObject) {
        self.infoDic = [NSDictionary dictionaryWithDictionary:responseObject[@"showapi_res_body"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
            [LCProgressHUD hide];
        });
    } failure:^(NSString *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [LCProgressHUD hide];
        });
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"identifier";
    HosDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[HosDetailCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell= (HosDetailCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"HosDetailCell" owner:self options:nil] lastObject];
    }
    cell.infoDic = self.infoDic;
    __weak typeof(self) weakSelf = self;
    cell.clickWebsiteBlock = ^(NSString *urlStr) {
        HYWKViewController *myWKWebView = [[HYWKViewController alloc] init];
        [weakSelf.navigationController pushViewController:myWKWebView animated:YES];
        [myWKWebView loadRequestWithUrlString:urlStr methodStyle:METHOD_STYLE_UIWebView];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorColor = [UIColor clearColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.rowHeight = UITableViewAutomaticDimension; // 自适应单元格高度
        _mainTableView.estimatedRowHeight = 400; //先估计一个高度
    }
    return _mainTableView;
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
