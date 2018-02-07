//
//  HYGetParameter.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HYGetParameter.h"

@implementation HYGetParameter

+(NSDictionary *)getParameter:(NSDictionary *)dic{
    NSMutableDictionary *paramer = [NSMutableDictionary dictionaryWithDictionary:dic];
    [paramer setObject:@"43039" forKey:@"showapi_appid"];
    [paramer setObject:@"587ee3b043534ddf973ccd5bd5964ced" forKey:@"showapi_sign"];
    return paramer;
}

@end
