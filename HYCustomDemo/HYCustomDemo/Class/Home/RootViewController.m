//
//  RootViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航条的返回按钮 http://blog.csdn.net/wyz670083956/article/details/52252023
    UIBarButtonItem * bar = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = bar;
    //导航栏字体颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @""
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(home)];
    self.navigationItem.backBarButtonItem = backButton;
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
