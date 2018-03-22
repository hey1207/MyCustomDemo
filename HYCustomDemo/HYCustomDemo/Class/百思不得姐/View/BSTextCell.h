//
//  BSTextCell.h
//  HYCustomDemo
//
//  Created by HY on 2018/3/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BSTotalModel.h"

@interface BSTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic,strong) BS_List *list;

@end
