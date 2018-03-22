//
//  SingleView.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SingleView.h"

@implementation SingleView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.topImageView.layer.masksToBounds = YES;
    self.topImageView.layer.cornerRadius = 6;
}


@end
