//
//  NewsCell.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *comeLabel;

@property (nonatomic,strong) Contentlist *contentlist;

@end
