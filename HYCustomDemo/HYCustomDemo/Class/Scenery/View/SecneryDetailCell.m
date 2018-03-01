//
//  SecneryDetailCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SecneryDetailCell.h"

@implementation SecneryDetailCell

-(void)setContentlist:(S_Contentlist *)contentlist{
    //图片
    if (contentlist.picList.count == 0) { //无图
        self.picTopConstraint.constant = 0;
        self.picHeightConstraint.constant = 0;
        self.imageMaginConstraint.constant = Main_Screen_Width;
        self.imageTopConstraint.constant = 0;
        self.moreButton.hidden = YES;
    }
    if (contentlist.picList.count > 0) {
        S_PicList *picList = contentlist.picList[0];
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
        self.leftImageView.userInteractionEnabled = YES;
    }
    if (contentlist.picList.count > 1){
        S_PicList *picList = contentlist.picList[1];
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
        self.centerImageView.userInteractionEnabled = YES;
    }
    if(contentlist.picList.count > 2){
        S_PicList *picList = contentlist.picList[2];
        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
        self.rightImageView.userInteractionEnabled = YES;
    }
    
    //地址
    if (contentlist.address.length > 0) {
        NSString *address = [NSString stringWithFormat:@"地址：%@",contentlist.address];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:address];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 3)];
        self.addressLabel.attributedText = att;
    }else{
        self.addressTop.constant = 0;
    }
    //开放时间
    if (contentlist.opentime.length > 0) {
        NSString *opentime = [NSString stringWithFormat:@"开放时间：%@",contentlist.opentime];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:opentime];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
        self.openTimeLabel.attributedText = att;
    }else{
        self.openTimeTop.constant = 0;
    }
    //简介
    if (contentlist.content.length > 0 || contentlist.summary.length > 0) {
        NSString *str = [NSString stringWithFormat:@"景点简介：%@",(contentlist.content.length>0)?contentlist.content:contentlist.summary];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
        self.detailLabel.attributedText = att;
    }else{
        self.detailTop.constant = 0;
    }
    
    //开放时间
    if (contentlist.coupon.length > 0) {
        NSString *coupon = [NSString stringWithFormat:@"优惠政策：%@",contentlist.coupon];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:coupon];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
        self.couponLabel.attributedText = att;
    }else{
        self.couponTop.constant = 0;
    }
    //温馨提示
    if (contentlist.attention.length > 0) {
        NSString *attention = [NSString stringWithFormat:@"温馨提示：%@",contentlist.attention];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:attention];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
        self.attentionLabel.attributedText = att;
    }else{
        self.attentionTop.constant = 0;
    }
    
    [self layoutIfNeeded];

}

- (IBAction)moreButtonAction:(id)sender {
    if (self.clickPicBlock) {
        self.clickPicBlock();
    }
}
-(void)tapImageView{
    if (self.clickPicBlock) {
        self.clickPicBlock();
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    [self.leftImageView addGestureRecognizer:tap1];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    [self.centerImageView addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    [self.rightImageView addGestureRecognizer:tap3];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
