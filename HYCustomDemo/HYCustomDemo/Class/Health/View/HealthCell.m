//
//  HealthCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HealthCell.h"

@implementation HealthCell

-(void)setList:(H_contentlist *)list{
    _list = list;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:list.img]];
    if( list.img.length== 0){
        self.iconLeft.constant = 0;
        self.iconHeight.constant = 0;
    }
    
    self.topLabel.text = list.title;
    self.detailLabel.text = list.intro;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
