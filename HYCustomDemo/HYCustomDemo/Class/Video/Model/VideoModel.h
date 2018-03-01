//
//  VideoModel.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class V_Contentlist;

@interface VideoModel : NSObject
@property (nonatomic,strong) NSArray <V_Contentlist *> *contentlist;
@end

@interface V_Contentlist : NSObject
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *name; //name
@property (nonatomic,copy) NSString *profile_image; //icon
@property (nonatomic,copy) NSString *video_uri;
@property (nonatomic,copy) NSString *create_time;
@end
