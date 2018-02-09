//
//  MyPictureCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyPictureCell.h"

@implementation MyPictureCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setPicList:(S_PicList *)picList{
    _picList = picList;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:picList.picUrlSmall]];
}
-(void)createUI{
    UIImageView *bigImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:bigImageView];
    bigImageView.sd_layout.leftSpaceToView(self.contentView, 0).rightSpaceToView(self.contentView, 0).topSpaceToView(self.contentView, 0).bottomSpaceToView(self.contentView, 0);
    self.bigImageView = bigImageView;
}

@end
