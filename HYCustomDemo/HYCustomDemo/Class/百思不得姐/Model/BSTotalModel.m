//
//  BSTotalModel.m
//  HYCustomDemo
//
//  Created by HY on 2018/3/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BSTotalModel.h"

@implementation BSTotalModel
+(NSDictionary *)mj_objectClassInArray{
    return @{@"list":[BS_List class]};
}
@end

@implementation BS_List
+(NSDictionary *)mj_objectClassInArray{
    return @{@"video":[BS_Video class],@"u":[BS_U class],@"image":[BS_Image class],@"gif":[BS_Gif class]};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"id":@"videoID"};
}
@end

@implementation BS_Video

@end

@implementation BS_U

@end

@implementation BS_Image

@end

@implementation BS_Gif

@end
