//
//  UIScrollView+HYRefresh.h
//  HYCustomDemo
//
//  Created by HY on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (HYRefresh)

- (void)setRefreshWithHeaderBlock:(void(^)())headerBlock footerBlock:(void(^)())footerBlock;

- (void)headerBeginRefreshing;
- (void)headerEndRefreshing;
- (void)footerEndRefreshing;
- (void)footerNoMoreData;

- (void)hideHeaderRefresh;
- (void)hideFooterRefresh;

@end
