//
//  HospitalCell.m
//  MyHospitalDemo
//
//  Created by HY on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HospitalCell.h"

@implementation HospitalCell

-(void)setInfoDic:(NSDictionary *)infoDic{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:infoDic[@"img"]]];
    self.hospitalName.text = infoDic[@"hosName"];
    self.hospitalGrade.text = infoDic[@"level"];
    self.hospitalAddress.text = [NSString stringWithFormat:@"%@%@",infoDic[@"provinceName"],infoDic[@"cityName"]];
    
    if (![infoDic[@"addr"] isEqualToString:@""]) {
        self.detailAddressLabel.text = [NSString stringWithFormat:@"地址：%@",infoDic[@"addr"]];
    }else{
        self.detailAddressLabel.text = @"";
    }
    
    if (infoDic[@"tele"]) {
        NSString *telStr = [NSString stringWithFormat:@"电话：%@",infoDic[@"tele"]];
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:telStr];
//        [att addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range: NSMakeRange(3, telStr.length-3)];
//        self.phoneLabel.attributedText = att;
        self.phoneLabel.text = telStr;
    }else{
        self.phoneLabel.text = @"";
    }
    
    if (![infoDic[@"keshi"] isEqualToString:@""]) {
        NSString *keshiStr = [NSString stringWithFormat:@"特色科室：%@",infoDic[@"keshi"]];
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:keshiStr];
//        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 5)];
//        self.featureLabel.attributedText = att;
        self.featureLabel.text = keshiStr;
    }else{
        self.featureLabel.text = @"";
    }

    if (![infoDic[@"bus"] isEqualToString:@""]) {
        NSString *jtStr = [NSString stringWithFormat:@"交通指南：%@",infoDic[@"bus"]];
//        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:jtStr];
//        [att addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range: NSMakeRange(0, 5)];
//        self.trafficLabel.attributedText = att;
        self.trafficLabel.text = jtStr;
    }else{
        self.trafficLabel.text = @"";
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
