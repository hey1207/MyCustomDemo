//
//  VideoViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoModel.h"
#import "VideoCell.h"

#import <ZFPlayer.h>
#import <ZFPlayerView.h>
#import <ZFDownloadManager.h>

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate,ZFPlayerControlViewDelagate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic,copy) NSString *np; //替代页数
@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavTitleH(@"小视频");
    
    self.np = @"0"; //默认
    [self loadDataWithPage:self.np];
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    //空白页
    [self.mainTableView setupEmptyDataText:@"木有更多数据" verticalOffset:30 emptyImage:[UIImage imageNamed:@"none"] tapBlock:^{
        [self loadDataWithPage:@"0"];
    }];
    //刷新
    __weak typeof(self) weakself = self;
    [self.mainTableView setRefreshWithHeaderBlock:^{
        weakself.np = @"0";
        [weakself.modelArray removeAllObjects];
        [weakself loadDataWithPage:weakself.np];
    } footerBlock:^{
        [weakself loadDataWithPage:weakself.np];
    }];
}
-(void)loadDataWithPage:(NSString *)np{
    [LCProgressHUD showLoading:@""];
    [[HYDataService sharedClient] requestWithUrlString:[NSString stringWithFormat:@"http://s.budejie.com/topic/list/jingxuan/41/bs0315-iphone-4.5.6/%@-20.json",np] parameters:nil method:REQUEST_METHOD_GET success:^(id response, NSError *error) {
        [LCProgressHUD hide];
        [self.mainTableView headerEndRefreshing];
        [self.mainTableView footerEndRefreshing];

        VideoModel *model = [VideoModel mj_objectWithKeyValues:response];
        _np = model.info[@"np"];
        [self.modelArray addObjectsFromArray:model.list];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"请求视频列表失败");
        [LCProgressHUD hide];
        [self.mainTableView headerEndRefreshing];
        [self.mainTableView footerEndRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak VideoCell *cell = (VideoCell *)[[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    V_List *list = self.modelArray[indexPath.row];
//    cell.list = list;
    cell.clickPlayButtonBlock = ^{
        [cell.playButton removeFromSuperview];
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        playerModel.title            = list.text;
        
        V_Video *video = list.video;
        playerModel.videoURL         = [NSURL URLWithString:[video.video firstObject]];
        playerModel.placeholderImageURLString = [video.thumbnail firstObject];
        playerModel.scrollView       = tableView;
        playerModel.indexPath        = indexPath;
        
        // player的父视图tag
        playerModel.fatherViewTag    = cell.bgImageView.tag;
        
        // 设置播放控制层和model
        [self.playerView playerControlView:self.controlView playerModel:playerModel];
        // 下载功能
        self.playerView.hasDownload = NO;
        // 自动播放
        [self.playerView autoPlayTheVideo];
    };
    
    return cell;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        // _playerView.stopPlayWhileCellNotVisable = YES;
        
        ZFPlayerShared.isLockScreen = NO;
        ZFPlayerShared.isStatusBarHidden = NO;
        
//        _playerView.hasDownload = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}
#pragma mark - ZFPlayerControlViewDelagate
-(void)zf_controlView:(UIView *)controlView closeAction:(UIButton *)sender{
    NSLog(@"123");
}
#pragma mark - ZFPlayerDelegate
- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = [url lastPathComponent];
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
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

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.playerView resetPlayer];
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
