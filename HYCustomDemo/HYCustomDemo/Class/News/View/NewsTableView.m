//
//  NewsTableView.m
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

static NSString *NEWSCELLID=@"NEWSCELLID";

#import "NewsTableView.h"
#import "NewsCell.h"

@implementation NewsTableView {
    int _dataNum;
    NSMutableArray *_indesPaths;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self createTableView];
//        _dataNum = -1;
//        _indesPaths = [NSMutableArray array];
//        self.timer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(charusell) userInfo:nil repeats:YES];
    }
    return self;
}
-(void)createTableView{
    self.delegate=self;
    self.dataSource=self;
    [self registerClass:[NewsCell class] forCellReuseIdentifier:NEWSCELLID];
    self.showsVerticalScrollIndicator = NO;
    self.tableFooterView = [UIView new];
}
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}
//方式一:通过计时器，逐行插入cell，实现cell飞入效果
//-(void)charusell{
//    _dataNum = _dataNum +1;
//    if (_dataNum < self.dataArray.count) {
//        [_indesPaths addObject:[NSIndexPath indexPathForItem:_dataNum inSection:0]];
//        [self insertRowsAtIndexPaths:_indesPaths withRowAnimation:UITableViewRowAnimationRight];
//        [_indesPaths removeAllObjects];
//    }else{
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}

#pragma mark -------tableViewDelegate-------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell *newsCell = [tableView dequeueReusableCellWithIdentifier:NEWSCELLID forIndexPath:indexPath];
    newsCell.contentlist = self.dataArray[indexPath.row];
    //设置高度缓存
//    [newsCell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return newsCell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView cellHeightForIndexPath:indexPath model:self.dataArray[indexPath.row] keyPath:@"contentlist" cellClass:[NewsCell class] contentViewWidth:Main_Screen_Width];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectCell) {
        Contentlist *contentlist = self.dataArray[indexPath.row];
        self.selectCell(contentlist.link);
    }
}


@end
