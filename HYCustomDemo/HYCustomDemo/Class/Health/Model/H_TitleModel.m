//
//  H_TitleModel.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "H_TitleModel.h"

@implementation H_TitleModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [H_List class]};
}
@end

@implementation H_List
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"titleID":@"id"};
}
@end

