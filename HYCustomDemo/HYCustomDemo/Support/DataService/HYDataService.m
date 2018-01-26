//
//  HYDataService.m
//  HYCustomDemo
//
//  Created by HY on 2017/7/29.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HYDataService.h"

@implementation HYDataService

+(HYDataService *)sharedClient{
    static HYDataService *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedClient == nil) {
            _sharedClient = [[HYDataService alloc] init];
        }
    });
    _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/plain", nil];
    return _sharedClient;
}

-(void)requestWithUrlString:(NSString *)urlString parameters:(id)parameters method:(REQUEST_METHOD)method success:(void (^)(id, NSError *, NSDictionary *))success failure:(void(^)(id,NSError *))failure{
    //get方式
    if (method == REQUEST_METHOD_GET) {
        [self GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                success(responseObject,nil,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(nil,error);
            NSLog(@"task.stase %ld %@",(long)task.state, task.response);
        }];
    }
    //post方式
    if (method == REQUEST_METHOD_POST) {
        [self POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (responseObject) {
                success(responseObject,nil,nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(nil,error);
            NSLog(@"task.stase %ld %@",(long)task.state, task.response);
        }];
    }
}
@end
