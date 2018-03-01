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

@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource,WMPlayerDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *modelArray;
@end

@implementation VideoViewController{
    VideoCell *_curVideoCell;
    WMPlayer *wmPlayer;
    NSIndexPath *_curIndexPath;
    BOOL _isSmallScreen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
}
-(void)loadData{
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"41" forKey:@"type"];
    [LCProgressHUD showLoading:@""];
    [[HYDataService sharedClient] requestWithUrlString:Video_List_Url parameters:param method:REQUEST_METHOD_POST success:^(id response, NSError *error) {
        [LCProgressHUD hide];
        VideoModel *model = [VideoModel mj_objectWithKeyValues:response[@"pagebean"]];
        [self.modelArray addObjectsFromArray:model.contentlist];
        [self.mainTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"请求视频列表失败");
        [LCProgressHUD hide];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    self.navigationController.navigationBarHidden = NO;
    //旋转屏幕通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil ];
}
//旋转屏幕通知
- (void)onDeviceOrientationChange{
    if (wmPlayer==nil||wmPlayer.superview==nil){
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortraitUpsideDown:{
            NSLog(@"第3个旋转方向---电池栏在下");
        }
            break;
        case UIInterfaceOrientationPortrait:{
            NSLog(@"第0个旋转方向---电池栏在上");
            if (wmPlayer.isFullscreen) {
                if (_isSmallScreen) {
                    //放widow上,小屏显示
//                    [self toSmallScreen];
                }else{
//                    [self toCell];
                }
            }
        }
            break;
        case UIInterfaceOrientationLandscapeLeft:{
            NSLog(@"第2个旋转方向---电池栏在左");
            wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
        }
            break;
        case UIInterfaceOrientationLandscapeRight:{
            NSLog(@"第1个旋转方向---电池栏在右");
            wmPlayer.isFullscreen = YES;
            [self setNeedsStatusBarAppearanceUpdate];
            [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
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
    V_Contentlist *list = self.modelArray[indexPath.row];
    cell.list = list;
    cell.clickPlayButtonBlock = ^{
        _curIndexPath = indexPath;
        _curVideoCell = cell;
        if (_isSmallScreen) {
            [self releaseWMPlayer];
            _isSmallScreen = NO;
        }
        if (wmPlayer) {
            [self releaseWMPlayer];
            wmPlayer = [[WMPlayer alloc] init];
            wmPlayer.delegate = self;
            wmPlayer.closeBtnStyle = CloseBtnStyleClose;
            //            wmPlayer.URLString = list.video_uri;
            wmPlayer.URLString = @"http://flv3.bn.netease.com/videolib3/1802/26/aBTAg8873/SD/aBTAg8873-mobile.mp4";
            wmPlayer.titleLabel.text = list.text;
            
            wmPlayer.hidden = NO;
            wmPlayer.frame = cell.bgImageView.bounds;
            
            [cell.bgImageView addSubview:wmPlayer];
            [cell.bgImageView bringSubviewToFront:wmPlayer];
            [cell.playButton.superview sendSubviewToBack:cell.playButton];
            
            [wmPlayer play];
        }else{
            wmPlayer = [[WMPlayer alloc] init];
            wmPlayer.delegate = self;
            wmPlayer.closeBtnStyle = CloseBtnStyleClose;
            wmPlayer.URLString = @"http://flv3.bn.netease.com/videolib3/1802/26/aBTAg8873/SD/aBTAg8873-mobile.mp4";
            wmPlayer.titleLabel.text = list.text;
            
            wmPlayer.hidden = NO;
            wmPlayer.frame = cell.bgImageView.bounds;
            [cell.bgImageView addSubview:wmPlayer];
            [cell.bgImageView bringSubviewToFront:wmPlayer];
            [cell.playButton.superview sendSubviewToBack:cell.playButton];
            
            [wmPlayer play];
        }
    };
    
    return cell;
}

//全屏
-(void)toFullScreenWithInterfaceOrientation:(UIInterfaceOrientation )interfaceOrientation{
    [wmPlayer removeFromSuperview];
    wmPlayer.transform = CGAffineTransformIdentity;
    if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft) {
        wmPlayer.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }else if(interfaceOrientation==UIInterfaceOrientationLandscapeRight){
        wmPlayer.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    wmPlayer.frame = CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height);
    wmPlayer.playerLayer.frame = CGRectMake(0,0, Main_Screen_Height,Main_Screen_Width);

    //wmPlayer内部一个UIView，所有的控件统一管理在此view中
    wmPlayer.contentView.sd_layout.leftSpaceToView(wmPlayer, 0).topSpaceToView(wmPlayer, 0).widthIs([UIScreen mainScreen].bounds.size.height).heightIs([UIScreen mainScreen].bounds.size.width);
    //滑动时的亮度View
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        wmPlayer.effectView.frame = CGRectMake(Main_Screen_Height/2-155/2, Main_Screen_Width/2-155/2, 155, 155);
    }
    //滑动时的时间View
    wmPlayer.FF_View.sd_layout.centerXEqualToView(wmPlayer.contentView).centerYEqualToView(wmPlayer.contentView).widthIs(120).heightIs(60);
    //顶部操作工具栏
    wmPlayer.topView.sd_layout.leftSpaceToView(wmPlayer.contentView, 0).topSpaceToView(wmPlayer.contentView, 0).widthIs(Main_Screen_Height).heightIs(70);
    //底部操作工具栏
    wmPlayer.bottomView.sd_layout.leftSpaceToView(wmPlayer.contentView, 0).bottomSpaceToView(wmPlayer.contentView, 0).widthIs(Main_Screen_Height).heightIs(50);
    //加载失败的label
 wmPlayer.loadFailedLabel.sd_layout.centerXEqualToView(wmPlayer.contentView).centerYEqualToView(wmPlayer.contentView).heightIs(30).widthIs(Main_Screen_Height);
    
    //菊花（加载框）
    wmPlayer.loadingView.sd_layout.centerXEqualToView(wmPlayer.contentView).centerYEqualToView(wmPlayer.contentView).widthIs(22).heightIs(22);
    
    [[UIApplication sharedApplication].keyWindow addSubview:wmPlayer];
    
    wmPlayer.fullScreenBtn.selected = YES;
    wmPlayer.isFullscreen = YES;
    wmPlayer.FF_View.hidden = YES;
}

///播放器事件
-(void)wmplayer:(WMPlayer *)wmplayer clickedCloseButton:(UIButton *)closeBtn{
    VideoCell *currentCell = (VideoCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_curIndexPath.row inSection:0]];
    [currentCell.playButton.superview bringSubviewToFront:currentCell.playButton];
    [self releaseWMPlayer];
    [self setNeedsStatusBarAppearanceUpdate];
}
-(void)wmplayer:(WMPlayer *)wmplayer clickedFullScreenButton:(UIButton *)fullScreenBtn{
    if (fullScreenBtn.isSelected) {//全屏显示
        wmPlayer.isFullscreen = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        [self toFullScreenWithInterfaceOrientation:UIInterfaceOrientationLandscapeLeft];
    }else{
        if (_isSmallScreen) {
            //放widow上,小屏显示
//            [self toSmallScreen];
        }else{
//            [self toCell];
        }
    }
}
-(void)wmplayer:(WMPlayer *)wmplayer singleTaped:(UITapGestureRecognizer *)singleTap{
    NSLog(@"didSingleTaped");
}
-(void)wmplayer:(WMPlayer *)wmplayer doubleTaped:(UITapGestureRecognizer *)doubleTap{
    NSLog(@"didDoubleTaped");
}
///播放状态
-(void)wmplayerFailedPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidFailedPlay");
}
-(void)wmplayerReadyToPlay:(WMPlayer *)wmplayer WMPlayerStatus:(WMPlayerState)state{
    NSLog(@"wmplayerDidReadyToPlay");
}
-(void)wmplayerFinishedPlay:(WMPlayer *)wmplayer{
    NSLog(@"wmplayerDidFinishedPlay");
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

//释放WMPlayer
-(void)releaseWMPlayer{
    [wmPlayer pause];
    
    [wmPlayer removeFromSuperview];
    [wmPlayer.playerLayer removeFromSuperlayer];
    [wmPlayer.player replaceCurrentItemWithPlayerItem:nil];
    wmPlayer.player = nil;
    wmPlayer.currentItem = nil;
    //释放定时器，否侧不会调用WMPlayer中的dealloc方法
    [wmPlayer.autoDismissTimer invalidate];
    wmPlayer.autoDismissTimer = nil;
    
    wmPlayer.playOrPauseBtn = nil;
    wmPlayer.playerLayer = nil;
    wmPlayer = nil;
}
-(void)dealloc{
    [self releaseWMPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
