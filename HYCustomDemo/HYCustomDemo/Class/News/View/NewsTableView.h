//
//  NewsTableView.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

typedef void(^didSelectCell)(NSString *urlStr);

@interface NewsTableView : UITableView <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,copy) didSelectCell selectCell;


@property(nonatomic,strong) NSTimer * timer;

@end
