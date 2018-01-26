//
//  HYDataBase.m
//  HYCustomDemo
//
//  Created by HY on 2017/8/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HYDataBase.h"
#import <FMDB.h>

@implementation HYDataBase{
    FMDatabase *_db;
}
//创建单例
+(instancetype)sharedHYDataBase{
    static HYDataBase *sharedHYDataBase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHYDataBase = [[super allocWithZone:NULL] init];
        [sharedHYDataBase initDataBase];
    });
    return sharedHYDataBase;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self sharedHYDataBase];
}

//初始化数据库
-(void)initDataBase{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [documentPath stringByAppendingString:@"news.sqlite"];
    
    _db = [[FMDatabase alloc] initWithPath:filePath];

    if ([_db open]) {
        NSString *newsSql = @"CREATE TABLE 'news' ('listId' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'pubDate' VARCHAR(255),'title' VARCHAR(255),'channelName' VARCHAR(255),'desc' VARCHAR(255),'link' VARCHAR(255),'channelTitle' VARCHAR(255))";
        BOOL isSuccess = [_db executeUpdate:newsSql];
        
        if (isSuccess) {
            NSLog(@"初始化表成功");
        }else{
            NSLog(@"初始化表失败");
        }
    }else{
        NSLog(@"数据库打开失败");
    }
}

-(void)addContentlist:(Contentlist *)contentList{
    NSNumber *maxID = @(0);
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM news "];
    //获取数据库中最大的ID
    while ([res next]) {
        if ([maxID integerValue] < [[res stringForColumn:@"listId"] integerValue]) {
            maxID = @([[res stringForColumn:@"listId"] integerValue] ) ;
        }
        
    }
    maxID = @([maxID integerValue] + 1);
    
    BOOL isSuccess = [_db executeUpdate:@"INSERT INTO news(listId,pubDate,title,channelName,desc,link,channelTitle)VALUES(?,?,?,?,?,?,?)",maxID,contentList.pubDate,contentList.title,contentList.channelName,contentList.desc,contentList.link,contentList.channelTitle];
    
    if (isSuccess) {
        NSLog(@"插入单条数据成功");
    }else{
        NSLog(@"插入单条数据失败");
    }    
}
-(void)deleteContentlist:(NSString *)channelTitle{
    [_db executeUpdate:@"DELETE FROM news WHERE channelTitle = ?",channelTitle];
}
-(NSMutableArray *)getAllContentlistWithChannelTitle:(NSString *)channelTitle{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM news where channelTitle = ?",channelTitle];
    
    while ([res next]) {
        Contentlist *contentList = [[Contentlist alloc] init];
        contentList.listId = [res stringForColumn:@"listID"];
        contentList.pubDate = [res stringForColumn:@"pubDate"];
        contentList.title = [res stringForColumn:@"title"];
        contentList.channelName = [res stringForColumn:@"channelName"];
        contentList.desc = [res stringForColumn:@"desc"];
        contentList.link = [res stringForColumn:@"link"];
        contentList.channelTitle = [res stringForColumn:@"channelTitle"];

        [dataArray addObject:contentList];
    }
    NSLog(@"总查到 %lu 条数据",(unsigned long)dataArray.count);
    return dataArray;
}
@end
