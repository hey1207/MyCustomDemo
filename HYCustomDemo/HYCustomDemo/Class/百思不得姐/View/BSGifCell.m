//
//  BSGifCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSGifCell.h"
#import <FLAnimatedImage.h>
#import "ZXYSectorProgress.h"

@implementation BSGifCell{
    ZXYSectorProgress *_progress;
}

-(void)setList:(BS_List *)list{
    _list = list;
    
    BS_U *u = list.u;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:u.header.firstObject] placeholderImage:[UIImage imageNamed:@"head-default"]];
    
    self.nameLabel.text = u.name.length>0?u.name:@"未命名用户";
    self.timeLabel.text = [Tools compareCurrentTime:list.passtime];
    
    BS_Gif *gif = list.gif;
    
    self.imageHeight.constant = (CGFloat)gif.height/gif.width*(Main_Screen_Width-20);
    [self layoutIfNeeded];
    
    [self.gifImageView sd_setImageWithURL:[NSURL URLWithString:gif.gif_thumbnail.firstObject]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGifView:)];
    [self.gifImageView addGestureRecognizer:tap];
}
-(void)tapGifView:(UITapGestureRecognizer *)tap{
    _progress = [[ZXYSectorProgress alloc] initWithFrame:CGRectMake(0, 0, 50, 50) progress:0];
    _progress.fillColor = [UIColor lightGrayColor];
    [self.gifImageView addSubview:_progress];
    _progress.alpha = 0.5;
    _progress.sd_layout.centerXEqualToView(self.gifImageView).centerYEqualToView(self.gifImageView).heightIs(50).widthIs(50);
    [self layoutIfNeeded];
    
    BS_Gif *gif = self.list.gif;
    
    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:gif.images.firstObject] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"------%f",(CGFloat)receivedSize/expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            _progress.progress = (CGFloat)receivedSize/expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [_progress removeFromSuperview];
        FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
            imageView.animatedImage = gifImage;
            [self.gifImageView addSubview:imageView];
            imageView.sd_layout.leftSpaceToView(self.gifImageView, 0).topSpaceToView(self.gifImageView, 0).rightSpaceToView(self.gifImageView, 0).bottomSpaceToView(self.gifImageView, 0);
            [self layoutIfNeeded];
        });
    }];
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
