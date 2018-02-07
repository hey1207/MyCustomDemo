//
//  SceneryCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SceneryCell.h"

@implementation SceneryCell

-(void)setS_contentlist:(S_Contentlist *)s_contentlist{
    //标题
    self.s_nameLabel.text = s_contentlist.name;
    //简介
    if (s_contentlist.summary.length > 0) {
        NSString *text = [NSString stringWithFormat:@"简介：%@",s_contentlist.summary];
        NSMutableAttributedString *addAtt = [[NSMutableAttributedString alloc] initWithString:text];
        [addAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, 3)];
        [addAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        self.s_summaryLabel.attributedText = addAtt;
    }
    //地址
    NSString *addressText;
    if (s_contentlist.address.length>0) {
        addressText = [NSString stringWithFormat:@"地址：%@",s_contentlist.address];
    }else{
        addressText = [NSString stringWithFormat:@"地址：%@%@%@",s_contentlist.proName?s_contentlist.proName:@"",s_contentlist.cityName?s_contentlist.cityName:@"",s_contentlist.areaName?s_contentlist.areaName:@""];
    }
    NSMutableAttributedString *addAtt = [[NSMutableAttributedString alloc] initWithString:addressText];
    [addAtt addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, 3)];
    [addAtt addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
    self.s_addrLabel.attributedText = addAtt;
    
    //图片
    if (s_contentlist.picList.count == 0) { //无图
        self.centerMargin.constant = Main_Screen_Width;
        self.bottomMargin.constant = 5;
        [self layoutIfNeeded];
    }
    if (s_contentlist.picList.count > 0) {
        S_PicList *picList = s_contentlist.picList[0];
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
    }
    if (s_contentlist.picList.count > 1){
        S_PicList *picList = s_contentlist.picList[1];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
    }
    if(s_contentlist.picList.count > 2){
        S_PicList *picList = s_contentlist.picList[2];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.s_summaryLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
