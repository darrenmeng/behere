//
//  PinDAO.m
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 CP Wen. All rights reserved.
//

#import "PinDAO.h"
#import "Pin.h"

FMDatabase *sqlDB;

@implementation PinDAO


- (PinDAO *) init {
    self = [super init];
    if (self) {
        DatabaseConnection *dbConnection = [DatabaseConnection sharedInstance];
        sqlDB = dbConnection.sqliteDatabase;
    }
    return self;
}

//與database相關的程式大多follow下面的程序
//利用FMDB API的方法，如：executeQuery或executeUpdate...，與資料庫溝通
//如果資料庫會回傳資料，就用FMResultSet去接資料，FMResultSet是資料集合
//利用FMDB API的方法next取得資料集合的內容
//如果資料集合不只一筆，用next搭配while取出每一筆資料


//查詢功能
- (NSMutableArray *) getAllPin{
    NSMutableArray *rows = [NSMutableArray new];
    
    //如果這行發生找不到table的error，表示沒有拿到sqlite檔案
    //上次發生錯誤，是sqlite的fileName打錯
    FMResultSet *resultSet;
    resultSet = [sqlDB executeQuery:@"select * from pins"];
    
    if ([sqlDB hadError]) {
        NSLog(@"DB Error %d: %@", [sqlDB lastErrorCode], [sqlDB lastErrorMessage]);
    }
    
    while ([resultSet next]) {
        [rows addObject:resultSet.resultDictionary];
        NSLog(@"resultDictionary: %@", resultSet.resultDictionary);
    }
    NSLog(@"rows = %@", rows);
    
    return rows;
}


 //新增功能
 - (void) insertRecordIntoSQLite: (Pin *)pin {
 
     //如果新增記錄錯誤，就秀錯誤訊息
     if (![sqlDB executeUpdate:@"insert into pins (pin_title, pin_latitude, pin_longitude) values (?, ?, ?)", pin.title, pin.coordinate.latitude, pin.coordinate.longitude]) {
         
         //去executeUpdate看說明，裡面會提到lastErrorMessage
         NSLog(@"Could not insert record: %@", [sqlDB lastErrorMessage]);
     };
 
 }
 

//刪除功能
 - (void) deleteRecordFromSQLite:(NSInteger *)pinId {
     if (![sqlDB executeUpdate:@"delete from pins where pin_id=?", pinId]) {
     
         NSLog(@"Could not delete record: %@", [sqlDB lastErrorMessage]);
     }
 }
 

 //修改功能
- (void) updateRecordFromSQLite:(NSInteger *)pinId setTitle:(NSString *) title{
     if(![sqlDB executeUpdate:@"update pins set pin_title=? where pin_id=?", title, pinId]) {
     
         NSLog(@"Could not update record: %@", [sqlDB lastErrorMessage]);
     }
     
 }


@end
