//
//  UITableViewCell+CellAnimation.m
//  HYCustomDemo
//
//  Created by HY on 2017/12/14.
//  Copyright © 2017年 apple. All rights reserved.
//

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

#import "UITableViewCell+CellAnimation.h"

@implementation UITableViewCell (CellAnimation)

- (void)animationForIndexPath:(NSIndexPath *)indexPath {
//    NSInteger row = indexPath.row;
//    float radians = (120 + row*30)%360;
//    radians = 20;
//    CALayer *layer = [[self.layer sublayers] objectAtIndex:0];
//
//    // Rotation Animation
//    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    animation.fromValue =@DEGREES_TO_RADIANS(radians);
//    animation.toValue = @DEGREES_TO_RADIANS(0);
    
//    // Opacity Animation;
//    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    fadeAnimation.fromValue = @0.1f;
//    fadeAnimation.toValue = @1.f;
//
//    // Translation Animation
//    CABasicAnimation *translationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//    ;
//    translationAnimation.fromValue = @(-300.f * ((indexPath.row%2 == 0) ? -1: 1));
//    translationAnimation.toValue = @0.f;
    
    
//    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
//    animationGroup.duration = 0.4f;
//    animationGroup.animations = @[animation,fadeAnimation,translationAnimation];
//    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    [layer addAnimation:animation forKey:@"spinAnimation"];
}

@end
