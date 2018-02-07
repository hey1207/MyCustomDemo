//
//  SceneryModel.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class S_Contentlist,S_PicList;

@interface SceneryModel : NSObject
@property (nonatomic,strong) NSArray <S_Contentlist *> *contentlist;
@end

@interface S_Contentlist : NSObject
@property (nonatomic,copy) NSString *name; //景点名称
@property (nonatomic,copy) NSString *summary; //概要
@property (nonatomic,copy) NSString *proName; //省
@property (nonatomic,copy) NSString *cityName; //市
@property (nonatomic,copy) NSString *areaName; //区
@property (nonatomic,copy) NSString *address; //详细地址
@property (nonatomic,copy) NSString *coupon; //优惠
@property (nonatomic,copy) NSString *attention; //提示
@property (nonatomic,copy) NSString *opentime; //开放时间
@property (nonatomic,copy) NSString *content; //详细介绍
@property (nonatomic,copy) NSString *star; //级别
@property (nonatomic,strong) NSArray <S_PicList *>*picList;
@end

@interface S_PicList : NSObject
@property (nonatomic,copy) NSString *picUrl; //大图
@property (nonatomic,copy) NSString *picUrlSmall; //小图
@end
