//
//  H_TitleModel.h
//  HYCustomDemo
//
//  Created by HY on 2018/2/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class H_List;

@interface H_TitleModel : NSObject
@property (nonatomic,strong) NSArray <H_List *>*list;
@end

@interface H_List :NSObject
@property (nonatomic,copy) NSString *titleID;
@property (nonatomic,copy) NSString *name;
@end

