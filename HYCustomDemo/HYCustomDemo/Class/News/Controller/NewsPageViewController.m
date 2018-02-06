//
//  NewsViewController.m
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NewsPageViewController.h"

@interface NewsPageViewController ()
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger currentPage;
@end

@implementation NewsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    NavTitleH(@"新闻");
    
    _currentPage = 1;
    
    //查询数据
    [self queryDataWithTitle:self.title];
    
    [self newsTableView];
}
-(NewsTableView *)newsTableView{
    if (!_newsTableView) {
        _newsTableView = [[NewsTableView alloc] init];
        [self.view addSubview:_newsTableView];
        _newsTableView.dataArray = self.dataArray;
        
        __weak typeof(self) weakSelf = self;

        //下拉刷新
        _newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataWithPage:1];
        }];
        //上拉加载
        _newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _currentPage++;
            [weakSelf loadDataWithPage:_currentPage];
        }];
        
        _newsTableView.selectCell = ^(NSString *urlStr) {
            HYWKViewController *myWKWebView = [[HYWKViewController alloc] init];
            [weakSelf.navigationController pushViewController:myWKWebView animated:YES];
            [myWKWebView loadRequestWithUrlString:urlStr methodStyle:METHOD_STYLE_WKWebView];
        };
        
        self.newsTableView.sd_layout
        .leftSpaceToView(self.view, 0)
        .topSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .bottomSpaceToView(self.view, 0);
    }
    return _newsTableView;
}
-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
}
//查询数据
-(void)queryDataWithTitle:(NSString *)title{
    NSArray *localDataArray = [[HYDataBase sharedHYDataBase] getAllContentlistWithChannelTitle:self.titleStr];
    if (localDataArray.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:localDataArray];
        [self.newsTableView reloadData];
    }else{
        [self loadDataWithPage:self.currentPage];
    }
}
//请求数据
-(void)loadDataWithPage:(NSInteger)page{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setObject:self.titleStr forKey:@"title"];
    [parameter setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
        
    [LCProgressHUD showLoading:@""];

    [[HYDataService sharedClient] requestWithUrlString:News_Base_Url parameters:parameter method:REQUEST_METHOD_POST success:^(id response, NSError *error, NSDictionary *dict) {
        [LCProgressHUD hide];
        
        NSDictionary *dic = [response[@"showapi_res_body"] objectForKey:@"pagebean"];
        NewsModel *newsModel = [NewsModel mj_objectWithKeyValues:dic];
        
        //存入数据库
        for (Contentlist *contentList in newsModel.contentlist) {
            contentList.channelTitle = self.titleStr;
            [[HYDataBase sharedHYDataBase] addContentlist:contentList];
        }
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:newsModel.contentlist];
        [self.newsTableView reloadData];
        
        [self.newsTableView.mj_header endRefreshing];
    } failure:^(id response, NSError *error) {
        [LCProgressHUD hide];
        [self.newsTableView.mj_header endRefreshing];
    }];
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
