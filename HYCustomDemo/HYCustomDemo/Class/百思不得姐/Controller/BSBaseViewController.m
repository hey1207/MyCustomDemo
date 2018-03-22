//
//  BSBaseViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSBaseViewController.h"
#import "VideoModel.h"
#import "BSTotalModel.h"

#import "BSTextCell.h"
#import "VideoCell.h"
#import "BSImageCell.h"
#import "BSGifCell.h"

#import <ZFPlayer.h>
#import <ZFPlayerView.h>

@interface BSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,ZFPlayerDelegate,ZFPlayerControlViewDelagate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *modelArray;
@property (nonatomic,copy) NSString *np; //替代页数

@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@end

@implementation BSBaseViewController{
    UIScrollView *_bigScrollView;
    CGFloat _bigImageHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.np = @"0"; //默认
    
    [self.modelArray removeAllObjects];
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
-(NSString *)requestUrl:(NSString *)nextPage{
    return [NSString stringWithFormat:@"http://s.budejie.com/topic/tag-topic/64/hot/bs0315-iphone-4.5.6/%@-20.json",self.np];
}
-(void)loadDataWithPage:(NSString *)np{
    [LCProgressHUD showLoading:@""];
    [[HYDataService sharedClient] requestWithUrlString:[self requestUrl:np] parameters:nil method:REQUEST_METHOD_GET success:^(id response, NSError *error) {
        [LCProgressHUD hide];
        [self.mainTableView headerEndRefreshing];
        [self.mainTableView footerEndRefreshing];
        
        BSTotalModel *model = [BSTotalModel mj_objectWithKeyValues:response];
        _np = model.info[@"np"];
        [self.modelArray addObjectsFromArray:model.list];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
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
    BS_List *list = self.modelArray[indexPath.row];
    NSLog(@"-------------------- %ld 行",indexPath.row);
    if ([list.type isEqualToString:@"text"]) {
        BSTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
        cell.list = list;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([list.type isEqualToString:@"image"]){
        BSImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSImageCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.list = list;
        BS_Image *image = list.image;
        cell.downloadImageBlock = ^(UIImage *bigImage) {
            _bigImageHeight = (CGFloat)image.height/image.width*Main_Screen_Width;
            _bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
            [[UIApplication sharedApplication].keyWindow addSubview:_bigScrollView];
            _bigScrollView.delegate = self;
            _bigScrollView.alpha = 1;
            _bigScrollView.contentSize = CGSizeMake(Main_Screen_Width, _bigImageHeight);
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBigViewAction)];
            [_bigScrollView addGestureRecognizer:tap];
            
            UIImageView *bigImageView = [[UIImageView alloc] initWithImage:bigImage];
            [_bigScrollView addSubview:bigImageView];
            bigImageView.sd_layout.leftSpaceToView(_bigScrollView, 0).rightSpaceToView(_bigScrollView, 0).topSpaceToView(_bigScrollView, 0).heightIs((CGFloat)image.height/image.width*Main_Screen_Width);
            [self.view layoutIfNeeded];
        };
        return cell;
    }else if ([list.type isEqualToString:@"gif"]){
        BSGifCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BSGifCell" forIndexPath:indexPath];
        cell.list = list;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if ([list.type isEqualToString:@"video"]){
        __weak VideoCell *cell = (VideoCell *)[[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.list = list;
        cell.clickPlayButtonBlock = ^{
            [cell.playButton removeFromSuperview];
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
            playerModel.title            = list.text;
            
            BS_Video *video = list.video;
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        BSTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"identifier" forIndexPath:indexPath];
        cell.list = self.modelArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
#pragma mark ----------------------------------- 长图处理 ---------------------------------------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < -80 || scrollView.contentOffset.y > _bigImageHeight-Main_Screen_Height+80) {
        [self tapBigViewAction];
    }
}
-(void)tapBigViewAction{
    [UIView animateWithDuration:0.2f animations:^{
        _bigScrollView.alpha = 0;
    }];
    [self performSelector:@selector(removeBigScrollView) withObject:nil afterDelay:0.2f];
}
-(void)removeBigScrollView{
    [_bigScrollView removeFromSuperview];
}

-(UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.rowHeight = UITableViewAutomaticDimension; // 自适
        _mainTableView.estimatedRowHeight = 50; //先估计一个高度
        [_mainTableView registerNib:[UINib nibWithNibName:@"BSTextCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"identifier"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"VideoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VideoCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"BSImageCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BSImageCell"];
        [_mainTableView registerNib:[UINib nibWithNibName:@"BSGifCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BSGifCell"];
    }
    return _mainTableView;
}
-(NSMutableArray *)modelArray{
    if(!_modelArray){
        _modelArray = [NSMutableArray array];
    }
    return _modelArray;
}

#pragma mark ----------------------------------- 视频相关 ---------------------------------------
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
