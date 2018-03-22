//
//  BSTextCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSTextCell.h"

@implementation BSTextCell

-(void)setList:(BS_List *)list{
    BS_U *u = list.u;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:u.header.firstObject] placeholderImage:[UIImage imageNamed:@"head-default"]];
    
    self.nameLabel.text = u.name.length>0?u.name:@"未命名用户";
    self.timeLabel.text = [Tools compareCurrentTime:list.passtime];
    
    self.detailLabel.text = list.text;
}



- (void)awakeFromNib {
    [super awakeFromNib];

    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 23;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
