//
//  HYCodeViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HYCodeViewController.h"
#import "WSLScanView.h"
#import "WSLNativeScanTool.h"

@interface HYCodeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) WSLScanView *scanView;
@property (nonatomic,strong) WSLNativeScanTool *scanTool;
@property (nonatomic,strong) UILabel *resultLabel;
@end

@implementation HYCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NavTitleH(@"二维码/条码");
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:0 target:self action:@selector(rightBarAction)];
    
    [self createView];
}
-(void)rightBarAction{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //相册
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else{
        NSLog(@"不支持访问相册");
    }
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    //    NSLog(@"选择完毕----image:%@-----info:%@",image,editingInfo);
    [self dismissViewControllerAnimated:YES completion:nil];
    [_scanTool scanImageQRCode:image];
}

-(void)createView{
    //输出流视图
    UIView *preview  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, Main_Screen_Height)];
    [self.view addSubview:preview];
    
    __weak typeof(self) weakSelf = self;
    
    //构建扫描样式视图
    _scanView = [[WSLScanView alloc] initWithFrame:CGRectMake(0, 64, Main_Screen_Width, Main_Screen_Height - 64)];
    _scanView.scanRetangleRect = CGRectMake(Main_Screen_Width/2-90, Main_Screen_Height/2-90-64, 180, 180);
    _scanView.colorAngle = [UIColor greenColor];
    _scanView.photoframeAngleW = 20;
    _scanView.photoframeAngleH = 20;
    _scanView.photoframeLineW = 2;
    _scanView.isNeedShowRetangle = YES;
    _scanView.colorRetangleLine = [UIColor whiteColor];
    _scanView.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _scanView.animationImage = [UIImage imageNamed:@"scanLine"];
    _scanView.myQRCodeBlock = ^{
        weakSelf.resultLabel.text = @"";
        [weakSelf.scanView startScanAnimation];
        [weakSelf.scanTool sessionStartRunning];
    };
    _scanView.flashSwitchBlock = ^(BOOL open) {
        [weakSelf.scanTool openFlashSwitch:open];
    };
    [self.view addSubview:_scanView];
    
    //搜索结果框
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, _scanView.scanRetangleRect.origin.y+ 180+ 10 + 20 + 10+40, Main_Screen_Width-60, 30)];
    self.resultLabel.textColor = [UIColor greenColor];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [_scanView addSubview:self.resultLabel];
    
    //初始化扫描工具
    _scanTool = [[WSLNativeScanTool alloc] initWithPreview:preview andScanFrame:_scanView.scanRetangleRect];
    _scanTool.scanFinishedBlock = ^(NSString *scanString) {
        NSLog(@"扫描结果 %@",scanString);
        weakSelf.resultLabel.text = [NSString stringWithFormat:@"扫描结果：%@",scanString];
        [weakSelf.scanView.myCode setTitle:@"重新扫描" forState:UIControlStateNormal];
        [weakSelf.scanTool sessionStopRunning];
        [weakSelf.scanView stopScanAnimation];
        [weakSelf.scanTool openFlashSwitch:NO];
    };
    _scanTool.monitorLightBlock = ^(float brightness) {
        NSLog(@"环境光感 ： %f",brightness);
        if (brightness < 0) {
            // 环境太暗，显示闪光灯开关按钮
            [weakSelf.scanView showFlashSwitch:YES];
        }else if(brightness > 0){
            // 环境亮度可以,且闪光灯处于关闭状态时，隐藏闪光灯开关
            if(!weakSelf.scanTool.flashOpen){
                [weakSelf.scanView showFlashSwitch:NO];
            }
        }
    };
    [_scanTool sessionStartRunning];
    [_scanView startScanAnimation];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_scanView startScanAnimation];
    [_scanTool sessionStartRunning];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_scanView stopScanAnimation];
    [_scanView finishedHandle];
    [_scanView showFlashSwitch:NO];
    [_scanTool sessionStopRunning];
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
