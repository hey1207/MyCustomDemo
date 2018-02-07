//
//  HYButton.h
//  PSCityPickerViewDemo
//
//  Created by HY on 2018/2/1.
//  Copyright © 2018年 Shengpan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapHandler)(UIButton *sender);

@interface HYButton : UIButton

@property (nonatomic,strong)tapHandler handler;

+ (instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title handler:(tapHandler)handler;

@end
