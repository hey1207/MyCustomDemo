//
//  HealthModel.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class H_contentlist;

@interface HealthModel : NSObject
@property (nonatomic,strong) NSArray <H_contentlist *>*contentlist;
@end

@interface H_contentlist : NSObject
@property (nonatomic,copy) NSString *h_Id;
@property (nonatomic,copy) NSString *wapurl;
@property (nonatomic,copy) NSString *intro;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *title;
@end
