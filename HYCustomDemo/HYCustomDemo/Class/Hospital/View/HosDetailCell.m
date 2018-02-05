//
//  HosDetailCell.m
//  MyHospitalDemo
//
//  Created by HY on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HosDetailCell.h"

@implementation HosDetailCell

-(void)setInfoDic:(NSDictionary *)infoDic{
    _infoDic = infoDic;
    
    //医院名称
    self.hosNameLabel.text = infoDic[@"hosName"];

    //类型
    NSString *type = infoDic[@"type"];
    if (type.length>0) {
        NSString *telStr = [NSString stringWithFormat:@"类型：%@",infoDic[@"type"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:telStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(3, telStr.length-3)];
        self.typeLabel.attributedText = att;
    }else{
        self.typeLabel.text = @"";
    }
    //级别
    NSString *level = infoDic[@"level"];
    if (level.length>0) {
        NSString *telStr = [NSString stringWithFormat:@"级别：%@",infoDic[@"level"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:telStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(3, telStr.length-3)];
        self.rankLabel.attributedText = att;
    }else{
        self.rankLabel.text = @"";
    }
    
    //电话
    NSString *tele = infoDic[@"tele"];
    if (tele.length>0) {
        NSString *telStr = [NSString stringWithFormat:@"电话：%@",infoDic[@"tele"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:telStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range: NSMakeRange(3, telStr.length-3)];
        self.telLabel.attributedText = att;
    }else{
        self.telLabel.text = @"";
    }
    
    //地址
    NSString *addr = infoDic[@"addr"];
    if (addr.length>0) {
        NSString *addrStr = [NSString stringWithFormat:@"地址：%@",addr];
        self.addressLabel.text = addrStr;
    }else{
        self.addressLabel.text = @"";
    }
    
    //官网
    NSString *hosLink = infoDic[@"hosLink"];
    if (hosLink.length>0) {
        NSString *hosStr = [NSString stringWithFormat:@"官网：%@     点击查看",infoDic[@"hosLink"]];
        [self.websiteButton setTitle:hosStr forState:UIControlStateNormal];
    }else{
        [self.websiteButton setTitle:@"" forState:UIControlStateNormal];
        self.websiteHeight.constant = 0;
    }
    
    //简介
    NSString *info = infoDic[@"info"];
    if (info.length>0) {
        NSString *infoStr = [NSString stringWithFormat:@"医院简介：%@",infoDic[@"info"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:infoStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 5)];
        self.infoLabel.attributedText = att;
    }else{
        self.addressLabel.text = @"";
    }
    //图片
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"img"]]];

    //特色
    NSString *keshi = infoDic[@"keshi"];
    if (keshi.length>0) {
        NSString *keshiStr = [NSString stringWithFormat:@"特色科室：%@",infoDic[@"keshi"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:keshiStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 5)];
        self.featureLabel.attributedText = att;
    }else{
        self.featureLabel.text = @"";
    }
    
    //交通
    NSString *bus = infoDic[@"bus"];
    if (bus.length>0) {
        NSString *jtStr = [NSString stringWithFormat:@"交通指南：%@",infoDic[@"bus"]];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:jtStr];
        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 5)];
        self.trafficLabel.attributedText = att;
    }else{
        self.trafficLabel.text = @"";
    }
}
- (IBAction)touchLookButton:(id)sender {
    NSLog(@"点击了网址:%@",self.infoDic[@"hosLink"]);
    if (self.clickWebsiteBlock) {
        self.clickWebsiteBlock(self.infoDic[@"hosLink"]);
    }
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
