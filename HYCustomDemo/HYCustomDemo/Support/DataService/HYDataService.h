//
//  HYDataService.h
//  HYCustomDemo
//
//  Created by HY on 2017/7/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, REQUEST_METHOD) {
    REQUEST_METHOD_GET,
    REQUEST_METHOD_POST
};

@interface HYDataService : AFHTTPSessionManager

+(HYDataService *)sharedClient;

/**
 请求接口

 @param urlString 地址
 @param parameters 参数
 @param method 请求方式
 @param success 成功回调
 @param failure 失败回调
 */
-(void)requestWithUrlString:(NSString *)urlString
                 parameters:(id)parameters
                     method:(REQUEST_METHOD)method
                    success:(void (^)(id, NSError *, NSDictionary *))success
                    failure:(void(^)(id,NSError *))failure;
@end
