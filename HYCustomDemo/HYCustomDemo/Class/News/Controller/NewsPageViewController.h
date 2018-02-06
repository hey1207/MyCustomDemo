//
//  NewsViewController.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTableView.h"
#import "NewsModel.h"

@interface NewsPageViewController : UIViewController
@property (nonatomic,copy) NSString *titleStr;
@property (nonatomic,strong) NewsTableView *newsTableView;
@end
