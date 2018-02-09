//
//  MyPictureCell.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneryModel.h"

@interface MyPictureCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *bigImageView;

@property (nonatomic,strong) S_PicList *picList;

@end
