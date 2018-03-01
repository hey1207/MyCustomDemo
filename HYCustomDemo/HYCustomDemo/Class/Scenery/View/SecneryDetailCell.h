//
//  SecneryDetailCell.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneryModel.h"

typedef void(^ClickPicBlock)(void);

@interface SecneryDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *openTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponLabel;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *picsLabel;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageMaginConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openTimeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *couponTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionTop;

@property (nonatomic,copy) ClickPicBlock clickPicBlock;

@property (nonatomic,strong) S_Contentlist *contentlist;
@end
