//
//  NewsModel.h
//  HYCustomDemo
//
//  Created by HY on 2017/8/1.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Contentlist,Imageurls;
@interface NewsModel : NSObject
@property (nonatomic,copy)   NSString *allPages;
@property (nonatomic,strong) NSArray  <Contentlist *>*contentlist;
@property (nonatomic,copy)   NSString *currentPage;
@property (nonatomic,copy)   NSString *allNum;
@property (nonatomic,copy)   NSString *maxResult;
@end

@interface Contentlist : NSObject
@property (nonatomic,copy)   NSString *listId;
@property (nonatomic,assign) BOOL havePic;
@property (nonatomic,copy)   NSString *pubDate;
@property (nonatomic,copy)   NSString *title;
@property (nonatomic,copy)   NSString *channelName;
@property (nonatomic,strong) NSArray  <Imageurls *>*imageurls;
@property (nonatomic,copy)   NSString *desc;
@property (nonatomic,copy)   NSString *source;
@property (nonatomic,copy)   NSString *channerId;
@property (nonatomic,copy)   NSString *link;
@property (nonatomic,assign) BOOL hasAll;
@property (nonatomic,copy)   NSString *channelTitle;
@end

@interface Imageurls : NSObject
@property (nonatomic,assign) NSInteger height;
@property (nonatomic,assign) NSInteger width;
@property (nonatomic,copy)   NSString *url;
@end
