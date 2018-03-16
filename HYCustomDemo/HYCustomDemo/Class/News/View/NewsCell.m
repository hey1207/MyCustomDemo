//
//  NewsCell.m
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#define SPACE 15
#define TOP 10

#import "NewsCell.h"
#import "PhotosContainerView.h"

@implementation NewsCell{
    PhotosContainerView *_photosContainer;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.numberOfLines = 3;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel = contentLabel;
    
    PhotosContainerView *photosContainer = [[PhotosContainerView alloc] initWithMaxItemsCount:9];
    _photosContainer = photosContainer;

    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor grayColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel = timeLabel;

    UILabel *comeLabel = [[UILabel alloc] init];
    comeLabel.font = [UIFont systemFontOfSize:14];
    comeLabel.textColor = [UIColor grayColor];
    comeLabel.textAlignment = NSTextAlignmentRight;
    self.comeLabel = comeLabel;

    [self.contentView sd_addSubviews:@[self.titleLabel, self.contentLabel,_photosContainer, self.timeLabel, self.comeLabel]];
    
    //layout
    self.titleLabel.sd_layout
    .leftSpaceToView(self.contentView, SPACE)
    .topSpaceToView(self.contentView, TOP)
    .rightSpaceToView(self.contentView, SPACE)
    .autoHeightRatio(0);
    
    self.contentLabel.sd_layout
    .leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, TOP)
    .rightEqualToView(self.titleLabel)
    .autoHeightRatio(0);
    
    _photosContainer.sd_layout
    .leftEqualToView(self.contentLabel)
    .rightEqualToView(self.contentLabel)
    .topSpaceToView(self.contentLabel, 10); // 高度自适应了，不需要再设置约束

}

-(void)setContentlist:(Contentlist *)contentlist {
    _contentlist = contentlist;
    
    self.titleLabel.text = contentlist.title;
    self.contentLabel.text = contentlist.desc;
    self.timeLabel.text = [Tools compareCurrentTime:contentlist.pubDate];
    self.comeLabel.text = contentlist.source;
    
    UIView *bottomView = _contentLabel;

    _photosContainer.photoNamesArray = contentlist.imageurls;
    if (contentlist.imageurls.count > 0) {
        _photosContainer.hidden = NO;
        bottomView = _photosContainer;
    } else {
        _photosContainer.hidden = YES;
    }
    
    self.timeLabel.sd_layout
    .leftEqualToView(self.contentLabel)
    .topSpaceToView(bottomView, TOP)
    .widthIs(200)
    .heightIs(20);
    
    self.comeLabel.sd_layout
    .rightEqualToView(self.contentLabel)
    .topEqualToView(self.timeLabel)
    .widthIs(100)
    .heightRatioToView(self.timeLabel, 1);

    [self setupAutoHeightWithBottomView:self.timeLabel bottomMargin:10];
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
