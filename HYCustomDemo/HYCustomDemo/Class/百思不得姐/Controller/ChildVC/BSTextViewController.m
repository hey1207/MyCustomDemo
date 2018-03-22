//
//  BSTextViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSTextViewController.h"

@interface BSTextViewController ()

@end

@implementation BSTextViewController

-(NSString *)requestUrl:(NSString *)nextPage{
    return [NSString stringWithFormat:@"http://s.budejie.com/topic/tag-topic/64/hot/bs0315-iphone-4.5.6/%@-20.json",nextPage];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
