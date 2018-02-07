//
//  SceneryCell.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneryModel.h"

@interface SceneryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *s_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *s_summaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *s_addrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (nonatomic,strong) S_Contentlist *s_contentlist;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerMargin;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomMargin;
@end
