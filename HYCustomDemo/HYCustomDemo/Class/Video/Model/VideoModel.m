//
//  VideoModel.m
//  HYCustomDemo
//
//  Created by HY on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":[V_List class]};
}
@end

@implementation V_List
+(NSDictionary *)mj_objectClassInArray{
    return @{@"video":[V_Video class]};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id":@"videoID"};
}
@end

@implementation V_Video
+(NSDictionary *)mj_objectClassInArray{
    return @{@"v":[V_U class]};
}
@end

@implementation V_U

@end
