//
//  Tools.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

//url中文转码
+(NSString *)chineseEncodingWithUrl:(NSString *)url;

//转换成几分钟前
+ (NSString *)compareCurrentTime:(NSString *)str;

@end
