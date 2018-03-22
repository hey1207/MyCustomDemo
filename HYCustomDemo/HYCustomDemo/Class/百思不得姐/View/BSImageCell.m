//
//  BSImageCell.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSImageCell.h"
#import "ZXYSectorProgress.h"

@implementation BSImageCell{
    ZXYSectorProgress *_progress;
}

-(void)setList:(BS_List *)list{
    _list = list;
    
    BS_U *u = list.u;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:u.header.firstObject] placeholderImage:[UIImage imageNamed:@"head-default"]];
    
    self.nameLabel.text = u.name.length>0?u.name:@"未命名用户";
    self.timeLabel.text = [Tools compareCurrentTime:list.passtime];
    
    BS_Image *image = list.image;
    
    if ((CGFloat)image.height/image.width>1.5) {
        self.longPicLabel.hidden = NO;
        self.imageWidth.constant = 250;
        self.imageHeight.constant = 250;
        [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:image.thumbnail_small.firstObject] placeholderImage:nil];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction)];
        [self.bottomImageView addGestureRecognizer:tap];
        
    }else{
        self.longPicLabel.hidden = YES;
        self.imageWidth.constant = Main_Screen_Width-20;
        self.imageHeight.constant = (CGFloat)image.height/image.width * (Main_Screen_Width-20);
        [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:image.big.firstObject] placeholderImage:nil];
    }
    [self layoutIfNeeded];
    
}
-(void)tapImageAction{
    NSLog(@"点击了长图");
    
    _progress = [[ZXYSectorProgress alloc] initWithFrame:CGRectMake(0, 0, 50, 50) progress:0];
    _progress.fillColor = [UIColor lightGrayColor];
    [self.bottomImageView addSubview:_progress];
    _progress.alpha = 0.5;
    _progress.sd_layout.centerXEqualToView(self.bottomImageView).centerYEqualToView(self.bottomImageView).heightIs(50).widthIs(50);
    [self layoutIfNeeded];
    
    BS_Image *image = self.list.image;
    
    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:image.big.firstObject] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        NSLog(@"------%f",(CGFloat)receivedSize/expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            _progress.progress = (CGFloat)receivedSize/expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        [_progress removeFromSuperview];
        if (self.downloadImageBlock) {
            self.downloadImageBlock(image);
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
