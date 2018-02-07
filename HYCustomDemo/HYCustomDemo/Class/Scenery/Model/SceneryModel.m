//
//  SceneryModel.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SceneryModel.h"

@implementation SceneryModel
+ (NSDictionary *)objectClassInArray{
    return @{@"contentlist" : [S_Contentlist class]};
}
@end


@implementation S_Contentlist
+ (NSDictionary *)objectClassInArray{
    return @{@"picList" : [S_PicList class]};
}
@end


@implementation S_PicList

@end
