//
//  DatabaseConnection.m
//  beenhere
//
//  Created by CP Wen on 2015/6/23.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "DatabaseConnection.h"

DatabaseConnection *dbConnection;

@implementation DatabaseConnection

- (void) connectDatabaseWithPathForFMDB {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths firstObject];
    
    NSString *editedDBPath = [documentPath stringByAppendingPathComponent:@"pin_V1_20150624.sqlite"];
    NSLog(@"可編輯的路徑: %@", editedDBPath);
    
    self.sqliteDatabase = [FMDatabase databaseWithPath:editedDBPath];

    if (![self.sqliteDatabase openWithFlags:SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE]) {
        NSLog(@"Could not open database.");
    }
  
}


- (DatabaseConnection *)init {
    self = [super init];
    if (self) {
        [self connectDatabaseWithPathForFMDB];
    }
    return self;
}


+ (DatabaseConnection *) sharedInstance {
    
    if (dbConnection == nil) {
        dbConnection = [[DatabaseConnection alloc] init];
    }
    
    return dbConnection;
}

@end
