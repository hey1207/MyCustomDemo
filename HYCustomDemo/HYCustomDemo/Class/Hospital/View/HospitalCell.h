//
//  HospitalCell.h
//  MyHospitalDemo
//
//  Created by HY on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HospitalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *hospitalGrade;
@property (weak, nonatomic) IBOutlet UILabel *hospitalAddress;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *featureLabel;
@property (weak, nonatomic) IBOutlet UILabel *trafficLabel;

@property (nonatomic,strong) NSDictionary *infoDic;
@end
