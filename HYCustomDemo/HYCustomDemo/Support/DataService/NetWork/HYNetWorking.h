//
//  HYNetWorking.h
//  MyHospitalDemo
//
//  Created by HY on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSString *error);

@interface HYNetWorking : NSObject
//原生GET网络请求
+ (void)getWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)PostWithURL:(NSString *)url Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
