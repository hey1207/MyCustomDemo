//
//  MainViewController.m
//  HYCustomDemo
//
//  Created by HY on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "BaseViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *newsButton = [self createButton:@"新闻"];
    newsButton.sd_layout.topSpaceToView(self.view, 100).centerXEqualToView(self.view).widthIs(100).heightIs(40);
    [newsButton addTarget:self action:@selector(newsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chartButton = [self createButton:@"聊天"];
    chartButton.sd_layout.topSpaceToView(newsButton, 20).centerXEqualToView(self.view).widthIs(100).heightIs(40);
    [chartButton addTarget:self action:@selector(chartButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)newsButtonAction:(UIButton *)button{
    BaseViewController *baseVC = [[BaseViewController alloc] init];
    [self.navigationController pushViewController:baseVC animated:YES];
}

-(void)chartButtonAction:(UIButton *)button{
    //是否安装QQ
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        //用来接收临时消息的客服QQ号码(注意此QQ号需开通QQ推广功能,否则陌生人向他发送消息会失败)
        NSString *QQ = @"791590798";
        //调用QQ客户端,发起QQ临时会话
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",QQ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        [LCProgressHUD showInfoMsg:@"未安装QQ"];
    }
}

-(UIButton *)createButton:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor lightGrayColor];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5;
    return button;
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
