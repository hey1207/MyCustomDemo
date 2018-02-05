//
//  BaseViewController.m
//  HYCustomDemo
//
//  Created by HY on 2017/7/31.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import <LXSegmentTitleView.h>
#import <LXScrollContentView.h>
#import "NewsViewController.h"
#import "NewsModel.h"

@interface BaseViewController ()<LXSegmentTitleViewDelegate,LXScrollContentViewDelegate>
@property (nonatomic,strong) LXSegmentTitleView *titleView;
@property (nonatomic,strong) LXScrollContentView *contentView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *vcs;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"新闻";
    //不加titleView位置会动
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.titleView];
    [self.view addSubview:self.contentView];
    
    [self createViewControllers];
    
    self.titleView.sd_layout
    .leftSpaceToView(self.view, 0)
    .topSpaceToView(self.view, 64)
    .rightSpaceToView(self.view, 0)
    .heightIs(35);
    
    self.contentView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .topSpaceToView(self.titleView, 0)
    .bottomSpaceToView(self.view, 10);
}

-(void)createViewControllers{
    for (int i = 0; i<self.titleArray.count; i++) {
        NewsViewController *newsVC = [[NewsViewController alloc] init];
        newsVC.titleStr = self.titleArray[i];
        [self.vcs addObject:newsVC];
    }
    [self.contentView reloadViewWithChildVcs:self.vcs parentVC:self];
    self.contentView.currentIndex = 0;
}
#pragma mark --------LXSegmentTitleViewDelegate---------
-(void)segmentTitleView:(LXSegmentTitleView *)segmentView selectedIndex:(NSInteger)selectedIndex lastSelectedIndex:(NSInteger)lastSelectedIndex{
    self.contentView.currentIndex = selectedIndex;
}
#pragma mark --------LXScrollContentViewDelegate---------
-(void)contentViewDidScroll:(LXScrollContentView *)contentView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress{
    
}
-(void)contentViewDidEndDecelerating:(LXScrollContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    self.titleView.selectedIndex = endIndex;
}
#pragma mark --------懒加载---------
-(LXSegmentTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[LXSegmentTitleView alloc] initWithFrame:CGRectZero];
        _titleView.delegate = self;
        _titleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _titleView.titleFont = [UIFont systemFontOfSize:18];
        _titleView.segmentTitles = self.titleArray;
    }
    return _titleView;
}
-(LXScrollContentView *)contentView{
    if (!_contentView) {
        _contentView = [[LXScrollContentView alloc] initWithFrame:self.view.frame];
        _contentView.delegate = self;
    }
    return _contentView;
}
-(NSMutableArray *)vcs{
    if (!_vcs) {
        _vcs = [NSMutableArray array];
    }
    return _vcs;
}
-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"热点",@"财经",@"郑州",@"体育",@"篮球",@"汽车",@"房产",@"股票",@"足球",@"图片"];
    }
    return _titleArray;
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