//
//  BSGirlViewController.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSGirlViewController.h"

@interface BSGirlViewController ()

@end

@implementation BSGirlViewController

-(NSString *) requestUrl :(NSString *) nextpage{
    return [NSString stringWithFormat:@"http://s.budejie.com/topic/tag-topic/117/hot/bs0315-iphone-4.5.6/%@-20.json",nextpage];
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
