//
//  VideoCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell

-(void)setList:(V_Contentlist *)list{
    _list = list;
    
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:list.profile_image]];
    
    self.nameLabel.text = list.name;
    self.createTimeLabel.text = list.create_time;
    
    NSString *str = [list.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *textStr = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.centerLabel.text = textStr;
}

- (IBAction)playButtonAction:(id)sender {
    if (self.clickPlayButtonBlock) {
        self.clickPlayButtonBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageVIew.layer.masksToBounds = YES;
    self.iconImageVIew.layer.cornerRadius = 16;
    
    self.bgImageView.backgroundColor = [UIColor lightGrayColor];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
