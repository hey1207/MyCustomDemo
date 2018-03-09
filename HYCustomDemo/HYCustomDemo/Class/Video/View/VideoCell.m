//
//  VideoCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell


-(void)setList:(V_List *)list{
    V_U *u = list.u;
    NSString *iconStr = [u.header firstObject];
    [self.iconImageVIew sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"head-default"]];
    
    self.nameLabel.text = u.name.length>0?u.name:@"186****1207";
    self.createTimeLabel.text = [Tools compareCurrentTime:list.passtime];
    
    self.centerLabel.text = list.text;
    
    V_Video *video = list.video;
    
    self.imageHeight.constant = (CGFloat)video.height/video.width * Main_Screen_Width;
    [self layoutIfNeeded];
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:[video.thumbnail firstObject]]];
}

- (IBAction)playButtonAction:(id)sender {
    if (self.clickPlayButtonBlock) {
        self.clickPlayButtonBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageVIew.layer.masksToBounds = YES;
    self.iconImageVIew.layer.cornerRadius = 23;
    
    self.bgImageView.backgroundColor = [UIColor lightGrayColor];    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
