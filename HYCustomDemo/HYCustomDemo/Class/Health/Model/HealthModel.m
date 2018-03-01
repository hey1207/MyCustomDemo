//
//  HealthModel.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HealthModel.h"

@implementation HealthModel
+ (NSDictionary *)objectClassInArray{
    return @{@"contentlist" : [H_contentlist class]};
}
@end

@implementation H_contentlist
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"h_Id":@"id"};
}
@end
