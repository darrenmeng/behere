//
//  DatabaseConnection.h
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//
//  DatabaseConnection.m的目的有：
//  建立DatabaseConnection的singleton，產生的物件是唯一的
//  將FMDB連結我們自訂的資料庫檔(.sqlite)

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface DatabaseConnection : NSObject


//建立iVar以讓所有所有的DAO(Data Access Object)可以存取
@property (strong, nonatomic) FMDatabase *sqliteDatabase;
+ (DatabaseConnection *) sharedInstance;

@end
