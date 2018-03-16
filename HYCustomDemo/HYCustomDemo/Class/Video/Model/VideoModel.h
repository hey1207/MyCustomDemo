//
//  VideoModel.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class V_List,V_Video,V_U;

@interface VideoModel : NSObject
@property (nonatomic,strong) NSDictionary *info; //np
@property (nonatomic,strong) NSArray <V_List *> *list;
@end

@interface V_List : NSObject
@property (nonatomic,strong) V_Video *video;
@property (nonatomic,copy)   NSString *videoID;
@property (nonatomic,copy)   NSString *passtime;
@property (nonatomic,copy)   NSString *type;
@property (nonatomic,copy)   NSString *text;
@property (nonatomic,copy)   NSString *share_url;
@property (nonatomic,strong) V_U *u;
@end

@interface V_Video : NSObject
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,copy)   NSString *duration;
@property (nonatomic,strong) NSArray *thumbnail;
@property (nonatomic,strong) NSArray *download;
@property (nonatomic,strong) NSArray *thumbnail_small;
@property (nonatomic,strong) NSArray *video;
@end

@interface V_U : NSObject
@property (nonatomic,copy)   NSString *room_name;
@property (nonatomic,strong)  NSArray *header;
@property (nonatomic,copy)   NSString *name;
@end
