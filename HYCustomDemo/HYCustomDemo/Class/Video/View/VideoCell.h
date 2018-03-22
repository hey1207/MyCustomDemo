//
//  VideoCell.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSTotalModel.h"

typedef void(^ClickPlayButtonBlock)(void);

@interface VideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;


@property (nonatomic,copy) ClickPlayButtonBlock clickPlayButtonBlock;

@property (nonatomic,strong) BS_List *list;

@end
