//
//  BSHomeViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSHomeViewController.h"
#import "BSRecViewController.h"
#import "BSSortViewController.h"
#import "BSPicViewController.h"
#import "BSTextViewController.h"
#import "BSVideoViewController.h"
#import "BSGirlViewController.h"

@interface BSHomeViewController ()<MJCSegmentDelegate>
@end

@implementation BSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NavTitleH(@"百思不得姐");
    
    [self createTitleView];
}
-(void)createTitleView{
    NSMutableArray *vcArray = [NSMutableArray array];
    NSArray *titleArray = @[@"推荐",@"排行",@"段子",@"图片",@"视频",@"美女"];
    
    BSRecViewController *recVC = [BSRecViewController new];
    [vcArray addObject:recVC];
    
    BSSortViewController *sortVC = [BSSortViewController new];
    [vcArray addObject:sortVC];
    
    BSTextViewController *textVC = [BSTextViewController new];
    [vcArray addObject:textVC];
    
    BSPicViewController *picVC = [BSPicViewController new];
    [vcArray addObject:picVC];
    
    BSVideoViewController *videoVC = [BSVideoViewController new];
    [vcArray addObject:videoVC];
    
    BSGirlViewController *girlVC = [BSGirlViewController new];
    [vcArray addObject:girlVC];
    
    // 分段样式属性工具
    MJCSegmentStylesTools *tools = [MJCSegmentStylesTools jc_initWithSegmentStylestoolsBlock:^(MJCSegmentStylesTools *jc_tools) {
        jc_tools.jc_titleBarStyles(MJCTitlesScrollStyle).
        jc_titlesViewFrame(CGRectMake(0, 0, self.view.jc_width,40));
        jc_tools.ItemDefaultShowCount = 6;
        jc_tools.childScollEnabled = YES;
        jc_tools.indicatorFollowEnabled = YES;
        jc_tools.itemTextGradientEnabled = YES; //滑动渐变
        jc_tools.indicatorColorEqualTextColorEnabled = YES; //指示器与标题颜色一致
        //这个SB第三方库，使用了readonly属性，使用KVC赋值
        [jc_tools setValue:[UIColor darkGrayColor] forKey:@"itemTextNormalColor"];
        [jc_tools setValue:[UIColor redColor] forKey:@"itemTextSelectedColor"];
        [jc_tools setValue:@"16" forKey:@"itemTextFontSize"];
    }];
    
    MJCSegmentInterface *interFace = [MJCSegmentInterface initWithFrame:CGRectMake(0,64,self.view.jc_width, self.view.jc_height-64) interFaceStyletools:tools];
    interFace.delegate = self;
    [self.view addSubview:interFace];
    [interFace intoTitlesArray:titleArray intoChildControllerArray:vcArray hostController:self];
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
