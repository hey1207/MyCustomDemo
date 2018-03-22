//
//  BSGifCell.h
//  HYCustomDemo
//
//  Created by HY on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTotalModel.h"

@interface BSGifCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;

@property (nonatomic,strong) BS_List *list;

@end
