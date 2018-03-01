//
//  CityCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProvinceCell.h"

@implementation ProvinceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI{
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.font = [UIFont systemFontOfSize:14];
    self.cityLabel.adjustsFontSizeToFitWidth = YES;
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.cityLabel];
    self.cityLabel.sd_layout.leftSpaceToView(self.contentView, 5).topSpaceToView(self.contentView, 5).rightSpaceToView(self.contentView, 5).bottomSpaceToView(self.contentView, 5);
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor py_colorWithHexString:@"e1e1e1"];
    [self.contentView addSubview:lineLabel];
    lineLabel.sd_layout.leftSpaceToView(self.contentView, 2).rightSpaceToView(self.contentView, 2).bottomSpaceToView(self.contentView, 0.5).heightIs(0.5);
}

-(void)setDic:(NSDictionary *)dic{
    self.cityLabel.text = dic[@"name"];
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
