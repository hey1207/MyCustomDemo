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
    BOOL _isDownloading;
}

-(void)setList:(BS_List *)list{
    _list = list;
    
    BS_U *u = list.u;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:u.header.firstObject] placeholderImage:[UIImage imageNamed:@"head-default"]];
    
    self.nameLabel.text = u.name.length>0?u.name:@"未命名用户";
    self.timeLabel.text = [Tools compareCurrentTime:list.passtime];
    
    self.detailLabel.text = list.text;
    
    BS_Image *bsImage = list.image;
    
    if ((CGFloat)bsImage.height/bsImage.width>1.2) {
        self.seeLongPicButton.hidden = NO;
        self.imageHeight.constant = 300;
        
        //长图处理,只显示顶部
        //第一步
        self.bottomImageView.contentMode = UIViewContentModeTop;
        self.bottomImageView.clipsToBounds = YES;
        
        [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:bsImage.big.firstObject] placeholderImage:[UIImage imageNamed:@"placeHolder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            //第二步
            CGFloat imageH = bsImage.width > 0 && bsImage.height > 0 ? Main_Screen_Width * bsImage.height/bsImage.width : 300;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(Main_Screen_Width, Main_Screen_Height),0, [UIScreen mainScreen].scale);
            [self.bottomImageView.image drawInRect:CGRectMake(0, 0, Main_Screen_Width, imageH)];
            self.bottomImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeLongPicButtonAction:)];
        [self.bottomImageView addGestureRecognizer:tap];
        
    }else{
        self.bottomImageView.contentMode = UIViewContentModeScaleToFill;
        self.bottomImageView.clipsToBounds = NO;
        
        self.seeLongPicButton.hidden = YES;
        
        self.imageHeight.constant = (CGFloat)bsImage.height/bsImage.width * (Main_Screen_Width-20);
        [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:bsImage.big.firstObject] placeholderImage:nil];
    }
    [self layoutIfNeeded];
    
}
- (IBAction)seeLongPicButtonAction:(id)sender {
    NSLog(@"点击了查看长图");
    
    if (_isDownloading) {
        return;
    }
    
    _progress = [[ZXYSectorProgress alloc] initWithFrame:CGRectMake(0, 0, 50, 50) progress:0];
    _progress.fillColor = [UIColor lightGrayColor];
    [self.bottomImageView addSubview:_progress];
    _progress.alpha = 0.5;
    _progress.sd_layout.centerXEqualToView(self.bottomImageView).centerYEqualToView(self.bottomImageView).heightIs(50).widthIs(50);
    [self layoutIfNeeded];
    
    BS_Image *image = self.list.image;
    
    [[SDWebImageManager sharedManager]loadImageWithURL:[NSURL URLWithString:image.big.firstObject] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        _isDownloading = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            _progress.progress = (CGFloat)receivedSize/expectedSize;
        });
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        _isDownloading = NO;
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
