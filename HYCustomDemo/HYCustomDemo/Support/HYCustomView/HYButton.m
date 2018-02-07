//
//  HYButton.m
//  PSCityPickerViewDemo
//
//  Created by HY on 2018/2/1.
//  Copyright © 2018年 Shengpan. All rights reserved.
//

#import "HYButton.h"

@implementation HYButton

+(instancetype)buttonWithFrame:(CGRect)frame title:(NSString *)title handler:(tapHandler)handler{
    HYButton *button = [super buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.handler = handler;
    [button addTarget:button action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - handleButton
- (void)handleButton:(UIButton *)sender{
    if (self.handler) {
        self.handler(sender);
    }
}
@end
