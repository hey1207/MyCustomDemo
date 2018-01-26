//
//  HYDataBase.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface HYDataBase : NSObject

+(instancetype)sharedHYDataBase;
//添加
-(void)addContentlist:(Contentlist *)contentList;

//删除
-(void)deleteContentlist:(NSString *)channelTitle;

//获取所有
-(NSMutableArray *)getAllContentlistWithChannelTitle:(NSString *)channelTitle;

@end
