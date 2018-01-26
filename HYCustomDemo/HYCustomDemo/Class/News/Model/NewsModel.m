//
//  NewsModel.m
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"contentlist" : [Contentlist class]};
}

@end

@implementation Contentlist

+ (NSDictionary *)objectClassInArray{
    return @{@"imageurls" : [Imageurls class]};
}

@end

@implementation Imageurls

@end
