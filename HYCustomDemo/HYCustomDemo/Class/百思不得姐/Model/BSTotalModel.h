//
//  BSTotalModel.h
//  HYCustomDemo
//
//  Created by HY on 2018/3/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BS_List,BS_Video,BS_U,BS_Image,BS_Gif;

@interface BSTotalModel : NSObject
@property (nonatomic,strong) NSDictionary *info; //np
@property (nonatomic,strong) NSArray <BS_List *> *list;
@end

@interface BS_List : NSObject
@property (nonatomic,strong) BS_Video *video;
@property (nonatomic,copy)   NSString *videoID;
@property (nonatomic,copy)   NSString *passtime;
@property (nonatomic,copy)   NSString *type;
@property (nonatomic,copy)   NSString *text;
@property (nonatomic,copy)   NSString *share_url;
@property (nonatomic,strong) BS_U *u;
@property (nonatomic,strong) BS_Image *image;
@property (nonatomic,strong) BS_Gif *gif;
@end

@interface BS_Video : NSObject
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,copy)   NSString *duration;
@property (nonatomic,strong) NSArray *thumbnail;
@property (nonatomic,strong) NSArray *download;
@property (nonatomic,strong) NSArray *thumbnail_small;
@property (nonatomic,strong) NSArray *video;
@property (nonatomic,assign) BOOL videoPlaying;
@end

@interface BS_U : NSObject
@property (nonatomic,copy)   NSString *room_name;
@property (nonatomic,strong)  NSArray *header;
@property (nonatomic,copy)   NSString *name;
@end

@interface BS_Image : NSObject
@property (nonatomic,strong) NSArray *big;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,strong) NSArray *thumbnail_small;
@end

@interface BS_Gif : NSObject
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *gif_thumbnail;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@end

