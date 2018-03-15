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
#import "HealthViewController.h"
#import "VideoViewController.h"
#import "HYCodeViewController.h"

#import "SingleView.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    CGFloat topMargin = 10; //行距
    CGFloat leftMargin = 10; //左右两边
    CGFloat centerMargin = 0; //列距
    NSInteger count = 4;
    CGFloat buttonWidth = (Main_Screen_Width-2*leftMargin-2*centerMargin)/count;
    CGFloat buttonHeight = buttonWidth;
    NSArray *titleArray = @[@"新闻",@"医院",@"景点",@"健康知识",@"小视频"];
    NSArray *imgArray = @[@"home_news",@"home_hospital",@"home_scenery",@"home_health",@"home_video"];
    
    for (int i = 0; i<titleArray.count; i++) {
        SingleView *singleView = [[NSBundle mainBundle] loadNibNamed:@"SingleView" owner:self options:nil].firstObject;
        singleView.topImageView.image = [UIImage imageNamed:imgArray[i]];
        singleView.bottomLabel.text = titleArray[i];
        [self.view addSubview:singleView];
        singleView.tag = 100+i;
        
        singleView.sd_layout
        .leftSpaceToView(self.view, leftMargin+(buttonWidth+centerMargin)*(i%count))
        .topSpaceToView(self.view, 50+(topMargin+buttonHeight+centerMargin)*(i/count))
        .widthIs(buttonWidth)
        .heightIs(buttonHeight);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [singleView addGestureRecognizer:tap];
    }
}

-(void)tapAction:(UIGestureRecognizer *)tap{
    switch (tap.view.tag-100) {
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
            SceneryViewController *sceneryVC = [[SceneryViewController alloc] init];
            [self.navigationController pushViewController:sceneryVC animated:YES];
            break;
        }
        case 3:{
            HealthViewController *healthVC = [[HealthViewController alloc] init];
            [self.navigationController pushViewController:healthVC animated:YES];
            break;
        }
        case 4:{
            VideoViewController *videoVC = [[VideoViewController alloc] init];
            [self.navigationController pushViewController:videoVC animated:YES];
            break;
        }
        case 5:{
            //            HYCodeViewController *codeVC = [[HYCodeViewController alloc] init];
            //            [self.navigationController pushViewController:codeVC animated:YES];
        }
            break;
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
