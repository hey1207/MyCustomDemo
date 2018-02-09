//
//  MainViewController.m
//  HYCustomDemo
//
//  Created by HY on 2017/10/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "NewsViewController.h"
#import "HospitalViewController.h"
#import "SceneryViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topMargin = 60;
    CGFloat leftMargin = 30;
    CGFloat centerMargin = 10;
    CGFloat buttonWidth = (Main_Screen_Width-2*leftMargin-2*centerMargin)/3;
    CGFloat buttonHeight = buttonWidth*0.5;
    NSArray *titleArray = @[@"新闻",@"医院",@"景点"];
    
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor lightGrayColor];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 5;
        [self.view addSubview:button];
        
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.sd_layout
        .leftSpaceToView(self.view, leftMargin+(buttonWidth+centerMargin)*(i%3))
        .topSpaceToView(self.view, topMargin+(buttonHeight+centerMargin)*(i/3))
        .widthIs(buttonWidth)
        .heightIs(buttonHeight);
    }
}

-(void)buttonAction:(UIButton *)button{
    switch (button.tag-100) {
        case 0:{
            NewsViewController *baseVC = [[NewsViewController alloc] init];
            [self.navigationController pushViewController:baseVC animated:YES];
            break;
        }
        case 1:{
            HospitalViewController *hospitalVC = [[HospitalViewController alloc] init];
            [self.navigationController pushViewController:hospitalVC animated:YES];
            break;
        }
        case 2:{
            SceneryViewController *scenerylVC = [[SceneryViewController alloc] init];
            [self.navigationController pushViewController:scenerylVC animated:YES];
            break;
        }
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
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
