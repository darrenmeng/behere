//
//  mydb.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/16.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "mydb.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "IndexTableViewController.h"

static NSString *const kurlson_upload=@"http://localhost:8888/beenhere/usersUP.php";

mydb *sharedInstance;

@implementation mydb

- (void)loadDB {
    NSLog(@"ok");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:@"beenhere.sqlite"];
    
    db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self loadDB];
    }
    return self;
}

+ (mydb *)sharedInstance {
    if (sharedInstance==nil) {
        sharedInstance = [[mydb alloc] init];
    }
    return sharedInstance;
}


#pragma mark - db methds

//瀏覽
- (id)queryCust {
    NSMutableArray *rows = [NSMutableArray new];
    FMResultSet *result = [db executeQuery:@"select * from memeber order by bhere_no"];
    while ([result next]) {     //BOF 1 2 3 4 5 ... EOF
        [rows addObject:result.resultDictionary];
    }
    return rows;
}

-(id)queryemail:(NSString *)beemail {
    
    
    NSString *query = [NSString stringWithFormat:@"%@", beemail];
   
    NSMutableArray *rows = [NSMutableArray new];
    FMResultSet *result = [db executeQuery:@"select * from memeber where email=? ", query];
   
    while ([result next]) {     //BOF 1 2 3 4 5 ... EOF
        [rows addObject:result.resultDictionary];
   }
    

    return rows;
    
}

//判斷EMAIL是否註冊過
- (BOOL)andnewEmail:(NSString *)email{
    
//判斷式要修改精簡
    
    NSLog(@"%@",email);
    NSMutableArray *rows = [NSMutableArray new];
    FMResultSet *result = [db executeQuery:@"select * from memeber where email=? ", email];
    NSLog(@"eee:%@",result);
    while ([result next]) {     //BOF 1 2 3 4 5 ... EOF
        [rows addObject:result.resultDictionary];
    }
    NSLog(@"%@",rows);
    if (rows.count>0) {
        return true;
       
    }else
    {
        return false;
     
    }

}



- (id)queryCustName:(NSString *)custname {
    NSString *query = [NSString stringWithFormat:@"%@%%", custname];
    
    NSMutableArray *rows = [NSMutableArray new];
    FMResultSet *result = [db executeQuery:@"select * from cust where cust_name like ? order by cust_no", query];
    while ([result next]) {     //BOF 1 2 3 4 5 ... EOF
        [rows addObject:result.resultDictionary];
    }
    return rows;
}

//取得流水號
- (NSString *)newCustNo {
    int maxno = 1;
    FMResultSet *result = [db executeQuery:@"select max(cust_no) from cust"];
    maxno = [result intForColumnIndex:0]+1;
    
    //    while ([result next]) {
    //        maxno = [result intForColumnIndex:0]+1;
    //    }
    return [NSString stringWithFormat:@"%03d", maxno];
}

//新增
- (void)insertMemeberNo:(NSString *)memberId andMBName:(NSString *)Bename andEMAIL:(NSString *)BeEMAIL andPassword:(NSString *)BePassword  {
    
    if (![db executeUpdate:@"insert into memeber (name,email,password,id) values (?,?,?,?)",Bename,BeEMAIL,BePassword,memberId]) {
        NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
    };
    NSLog(@"BEEMAIL:%@",BeEMAIL);
    
   // [self uploadUsers:BeEMAIL];
    
}


- (void)insertfriendname:(NSString *)memberId friendname:(NSString *)friendname andffriendID :(NSString *)friendID  {
    
    if (![db executeUpdate:@"insert into bh_firendlist (id,friendID,friendname) values (?,?,?)",memberId,friendID,friendname]) {
        NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
    };
    NSLog(@"BEEMAIL:%@",memberId);
    
    // [self uploadUsers:BeEMAIL];
    
}

//修改
//- (void)updateBeName:(NSString *)bename andBeTel:(NSString *)betel andBeemail:(NSString *)Beemail  andBeid:(NSString *)Beid andBelocation:(NSString *)Belocation andBepassword:(NSString *)bpw  andbhereno:(NSString *)bhereno {
//    
//    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//    f.numberStyle = NSNumberFormatterDecimalStyle;
//    NSNumber *myNumber = [f numberFromString:betel];
//    
//    
//    NSNumber *c = [[NSNumber alloc] init];
//    c = [NSNumber numberWithInt:betel];
//    
//    
//    if (![db executeUpdate:@"update memeber set name=?,telephone=?,location=?,email=?  ,password=? , id=? where bhere_no=?",bename,myNumber,Belocation,Beemail,bpw,Beid,bhereno]) {
//        NSLog(@"Could not update data:\n%@",[db lastErrorMessage]);
//    };
//}
- (void)updateBeName:(NSString *)bename andBeTel:(NSString *)betel andBeemail:(NSString *)Beemail andBebirthday:(NSDate *)Bebthday andBeid:(NSString *)Beid andBelocation:(NSString *)Belocation andBepassword:(NSString *)bpw andBesex:(NSString *)bsex andbhereno:(NSString *)bhereno {
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
      NSNumber *myNumber = [f numberFromString:betel];
    
    
    if (![db executeUpdate:@"update memeber set name=?,telephone=?,location=?,email=? ,sex=? ,password=? ,birthday=? , id=? where bhere_no=?",bename,myNumber,Belocation,Beemail,bsex,bpw,Bebthday,Beid,bhereno]) {
        NSLog(@"Could not update data:\n%@",[db lastErrorMessage]);
        message=@"已有此EMAIL或ID";
    }else{ message=@"修改完成";
    
        [self uploadUsers:Beemail];
    };
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"success" object:message];
}

//- (void)updateBeName:(NSString *)bename andBeTel:(NSInteger *)betel andBeemail:(NSString *)Beemail andBebirthday:(NSDate *)Bebthday andBeid:(NSString *)Beid andBelocation:(NSString *)Belocation andBepassword:(NSString *)bpw andBesex:(NSString *)bsex andbhereno:(NSString *)bhereno {
//    
//    if (![db executeUpdate:@"update memeber set name=?,telephone=?,location=?,email=? ,sex=? ,password=? ,birthday=? , id=? where bhere_no=?",bename,betel,Belocation,Beemail,bsex,bpw,Bebthday,Beid,bhereno]) {
//        NSLog(@"Could not update data:\n%@",[db lastErrorMessage]);
//    };
//}



//刪除
- (void)deleteCustNo:(NSString *)custno {
    if (![db executeUpdate:@"delete from cust where cust_no=?",custno]) {
        NSLog(@"Could not delete data:\n%@",[db lastErrorMessage]);
    };
}

//新增(以Dictionary)
- (void)insertCustDict:(NSDictionary *)custDict {
    /*
     MySQL          Local SQLite
     member_id      cust_no
     member_name    cust_name
     member_phone   cust_tel
     member_addr    cust_addr
     member_email   cust_email
     */
    FMResultSet *rs=[db executeQuery:@"select count(*) from memeber where bhere_no=?",custDict[@"bhere_no"]];
    
    while ([rs next]) {
        if ([rs intForColumnIndex:0]==0) {
            //可以新增
            if (![db executeUpdate:@"insert into memeber (bhere_no,birthday,cover,email,id,location,mapdgree,name,password,sex,telephone,userpicture) values (?,?,?,?,?,?,?,?,?,?,?,?)",
                  custDict[@"bhere_no"],
                  custDict[@"birthday"],
                  custDict[@"cover"],
                  custDict[@"email"],
                  custDict[@"id"],
                  custDict[@"location"],
                  custDict[@"mapdgree"],
                  custDict[@"name"],
                  custDict[@"password"],
                  custDict[@"sex"],
                  custDict[@"telephone"],
                  custDict[@"userpicture"]
                  ]) {
                NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
            
                
            
            
            };
            
            
        }
    }
}



//sqlite 資料修改後就上傳ＭＹＳＱＬ
-(void)uploadUsers:(NSString *)cust{
    
    
  
    //設定根目錄
    
    //設定要POST的鍵值
    NSDictionary *params = [self queryemail:cust][0];
    
    NSLog(@"params:%@",params);
    
    NSLog(@"telephone:%@",params[@"telephone"]);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/api.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
       // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"signIn"];
        NSLog(@"result:%@",result);
       
     //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
        
     
        
    }];
    

  
    
    
}


#pragma mark - content text
//新增內容
- (void)insertMemeberNo:(NSString *)memberId andcontenttext:(NSString *)Contenttext andlevel:(NSString *)level anddate:(NSDate *)date andcontentno:(NSString *)content_no{
    
   
    
    if (![db executeUpdate:@"insert into indexcontent (id,text,level,date) values (?,?,?,?)",memberId,Contenttext,level,date]) {
        NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
    };
   // [self uploadUsers:BeEMAIL];
    
   
    
    
}


//新增回覆內容
- (void)insertreplyMemeberNo:(NSString *)memberId andcontenttext:(NSString *)Contenttext andlevel:(NSString *)level anddate:(NSDate *)date andcontentno:(NSString *)content_no {
    

    if (![db executeUpdate:@"insert into indexcontent_reply (id,text,level,date,content_no) values (?,?,?,?,?)",memberId,Contenttext,level,date,content_no]) {
        NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
    };
    // [self uploadUsers:BeEMAIL];
    
}
//查詢主頁內容
-(id)queryindexcontent:(NSString *)beeid {
    
    
   
    
    NSMutableArray *rows = [NSMutableArray new];
    FMResultSet *result = [db executeQuery:@"select * from indexcontent where id=?  ", beeid];
    
    while ([result next]) {     //BOF 1 2 3 4 5 ... EOF
        [rows addObject:result.resultDictionary];
    }
    
    
    NSLog(@"rows:%@",rows);
    return rows;
  
    
}

//查詢主頁內容


//查詢回覆內容
-(id)queryreplycontent:(NSString *)content_id {
        
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *content_no = [f numberFromString:content_id];
    
        
        NSMutableArray *rows = [NSMutableArray new];
        FMResultSet *result = [db executeQuery:@"select * from indexcontent_reply where content_no=? ", content_no];
        
        while ([result next]) {     //BOF 1 2 3 4 5 ... EOF
            [rows addObject:result.resultDictionary];
        }
        
        
        NSLog(@"rows:%@",rows);
        return rows;
        
        
}

#pragma mark-查詢主頁內容
//查詢主頁內容
-(void)querymysqlindexcontent:(NSString *)beeid{
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"queryindexcontent",@"cmd", beeid, @"userID", nil];
    
    //產生hud物件，並設定其顯示文字
    
    
    
    NSLog(@"params:%@",params);
    
    NSLog(@"id=========:%@",params[@"userID"]);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
      
        NSString *result = [apiResponse objectForKey:@"queryindexcontentresult"];
   

        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
            NSMutableArray *data = [apiResponse objectForKey:@"queryindexcontent"];
            
            NSLog(@"index content:%@",data);
      
            for (NSDictionary *dict in data) {
           
                
                NSLog(@"DICT-content_no:%@",dict[@"content_no"]);
                [self insertMysqlContent:dict];
                
                
                [self Searchcontentno:dict[@"content_no"]];
            }
            
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
    }];

   
    
}
//serach content_no insert reply to sqlite
-(void)Searchcontentno:(NSString *)content_no{
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"searchcontentno",@"cmd", content_no, @"content_no",nil];
    
    
    NSLog(@"params serach content:%@",params);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        if (apiResponse[@"searchcontentnoresult"] != [NSNull null]) {
            
        NSString *result = [apiResponse objectForKey:@"searchcontentnoresult"];
        NSLog(@"upid result:%@",result);
            
       
            
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            NSMutableArray *data = [apiResponse objectForKey:@"searchcontentno"];
            
            
            NSLog(@"success");
            NSLog(@"data reply:%@",data);
      
            for (NSDictionary *dict in data) {
  
            //存到SQLITE
            [self insertMysqlreplyContent:dict];
           
              
            }
            
            
        }else {
            
            
            NSLog(@"up no suceess");
        }
        
        }
        
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
    }];
    
   
    
    
    
}
//從mysql查詢到子內容存到sqlite
- (void)insertMysqlreplyContent:(NSDictionary *)custDict{

    FMResultSet *rs=[db executeQuery:@"select count(*) from indexcontent_reply where reply_no=?",custDict[@"reply_no"]];
    
    while ([rs next]) {
        if ([rs intForColumnIndex:0]==0) {
            //可以新增
            if (![db executeUpdate:@"insert into indexcontent_reply (reply_no,content_no,id,text,image,level,date,like) values (?,?,?,?,?,?,?,?)",
                  custDict[@"reply_no"],
                  custDict[@"content_no"],
                  custDict[@"id"],
                  custDict[@"text"],
                  custDict[@"image"],
                  custDict[@"level"],
                  custDict[@"date"],
                  custDict[@"like"]
                  ]) {
                NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
                
            };
            
            
        }
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loaddata" object:message];
        
        
    }



}


//從mysql查詢內容存到sqlite
- (void)insertMysqlContent:(NSDictionary *)custDict {
  
    FMResultSet *rs=[db executeQuery:@"select count(*) from indexcontent where content_no=?",custDict[@"content_no"]];
    
    while ([rs next]) {
        if ([rs intForColumnIndex:0]==0) {
            //可以新增
            if (![db executeUpdate:@"insert into indexcontent (content_no,id,text,image,level,date,like) values (?,?,?,?,?,?,?)",
                  custDict[@"content_no"],
                  custDict[@"id"],
                  custDict[@"text"],
                  custDict[@"image"],
                  custDict[@"level"],
                  custDict[@"date"],
                  custDict[@"like"]
                  ]) {
                NSLog(@"Could not insert data:\n%@",[db lastErrorMessage]);
               
            };
            
            
        }
    }
}





#pragma mark-remote insert content
//遠端insert content 發布留言
-(void)insertcontentremote:(NSDictionary *)params{



    //設定要POST的鍵值
    
    NSLog(@"params:%@",params);
    
    NSLog(@"telephone:%@",params[@"userID"]);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"insertcontent"];
        NSLog(@"result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            //存入mysql後執行搜尋content_no
             [self SearchIDcontent:params[@"userID"] ];
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
        
        
        
    }];
    
}
//新增子回覆內容
-(void)insertcontentreplyremote:(NSDictionary *)params{
    
    
    
    //設定要POST的鍵值
    
    NSLog(@"params:%@",params);
    
    NSLog(@"telephone:%@",params[@"userID"]);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"insertcontentreply"];
        NSLog(@"result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
        
            [self Searchcontentno:params[@"content_no"]];
            
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
        
        
        
    }];
    
}


//serach content_no
-(void)SearchIDcontent:(NSString *)beid{
    
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"searchcontent",@"cmd", beid, @"userID",nil];
    
    
    NSLog(@"params serach content:%@",params);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse----:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"searchcontentresult"];
        NSLog(@"upid result:%@",result);
    
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
              NSDictionary *data = [apiResponse objectForKey:@"searchcontent"];
           
            
            NSLog(@"success");
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
//            NSDate *date = [dateFormatter dateFromString:birthday];
            
          
            //存到SQLITE
            [self insertMemeberNo:data[@"id"] andcontenttext:data[@"text"] andlevel:@"0" anddate:data[@"date"]  andcontentno:data[@"content_no"]];
            
        }else {
            
           
            NSLog(@"up no suceess");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
    }];
    
    
    
    
    
}


-(void)uploadUsersContent:(NSString *)beeid{



     NSDictionary *params = [self queryindexcontent:beeid][0];
    
    NSLog(@"params:%@",params);
    
    NSLog(@"telephone:%@",params[@"telephone"]);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/api.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"signIn"];
        NSLog(@"result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
            
            NSLog(@"success");
        }else {
            
            NSLog(@"no suceess");
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        
    }];
    
    
    

}




-(NSDictionary*)SearchRequest:(NSString *)SearchfriendID{
    
    
    
    //設定根目錄
    
    //設定要POST的鍵值
    
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"findRequest",@"cmd", SearchfriendID, @"userID", nil];
    
    NSLog(@"par:%@",params);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        
        
        RequestResult=apiResponse;
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"findRequest"];
        NSString * friend = [apiResponse objectForKey:@"requestid"];
        NSLog(@"result:%@   %@",result,friend);
        
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
         
            NSLog(@"success");
            
            //
        }else{
            
            NSLog(@"no success");
            
            
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
      //  [self SearchResult:@"coneect error"];
        
        
        
        
    }];
    
    
    
    return RequestResult;
    
}





@end













