//
//  SERVERCLASS.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/5.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//


#import "SERVERCLASS.h"
#import "AFNetworking.h"

static NSString *const PHPAPI=@"http://localhost:8888/beenhere/usersUP.php";

@implementation SERVERCLASS 
//sqlite 資料修改後就上傳ＭＹＳＱＬ
-(NSString*)uploadUsers:(NSString *)cust{
  
    
    
    //設定根目錄
    
    //設定要POST的鍵值

    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"findaccount",@"cmd", cust, @"userID", nil];
    
    NSLog(@"par:%@",params);

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
        NSString *result = [apiResponse objectForKey:@"findaccount"];
        NSLog(@"result:%@",result);
        
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
//            
//
            [self setField:result];
         
//
        }else{
            
        
            [self setField:result];
            
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        [self setField:@"coneect error"];
        
        
        
        
    }];
    
    

    NSString * result= [[NSUserDefaults standardUserDefaults]stringForKey:@"sreachID" ];
    
    
    
    return result;
 
}



-(void)SearchID:(NSString *)JudgeThing andsearchthing:(NSString *)cmd {
    
    
    
    //設定根目錄
    
    //設定要POST的鍵值
    
    
 

    
    //1. @"updateID"  2.@"SearchEmail"
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cmd,@"cmd", JudgeThing, @"userID",nil];
    
    
    NSLog(@"params:%@",params);
    
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
        NSString *result = [apiResponse objectForKey:@"upID"];
        NSLog(@"upid result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            [self setField:result];
            
            NSLog(@"success");
            
            
        }else {
            
            [self setField:result];
            NSLog(@"up no suceess");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
    }];
    

    
    
    
}


//確認ID或email有沒有存在
-(void)updateID:(NSString *)beId andbherename:(NSString *)bename andEmail:(NSString *)beemail{
    
    
    
    //設定根目錄
    
    //設定要POST的鍵值
    
    NSLog(@"userid:%@,username:%@,useremail:%@",beId,bename,beemail);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"updateID",@"cmd", beId, @"userID", bename, @"userName", beemail, @"email",nil];
    
    
    NSLog(@"params:%@",params);
    
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
        NSString *result = [apiResponse objectForKey:@"upID"];
        NSLog(@"upid result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            [self setField:result];
            
            NSLog(@"success");
            
            
        }else {
            
            [self setField:result];
            NSLog(@"up no suceess");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
    }];
    
 

    
    

}






- (void)setField:(NSString *)field
{
    
    

    [[NSUserDefaults standardUserDefaults] setObject:field forKey:@"sreachID"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma addfriend rqouest

-(NSString *)addfrinet:(NSString*)MYID andrequestId:(NSString*)requestID{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"addfriendrequest",@"cmd", MYID, @"userID", requestID, @"userName",nil];
    
    
    [self postRequest:params success:^(id jsonObject) {
        
        NSDictionary *apiResponse = [jsonObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"upID"];
        NSLog(@"upid result:%@",result);

       
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
    
    return 0;
    
    
}

#pragma block php 

-(NSDictionary*) getMutualFBFriendsWithFBid:(NSString*)fbID andCallback:(void (^)(NSDictionary *))callback {
    
//    [FBRequestConnection startWithGraphPath:[NSString stringWithFormat:@"/%@/mutualfriends/%@", [[PFUser currentUser] objectForKey:kFbID],userFBid]
//                                 parameters:nil
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
//                              //You should treat errors first
//                              //Then cast the result to an NSDictionary
//                              callback((NSDictionary*) result); //And trigger the callback with the result
//                          }];
    return 0;
}

//-(NSDictionary *)frinedinfo{
//
//
//    
//    NSDictionary *result;
//    
//       NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"addfriendrequest",@"cmd", MYID, @"userID", requestID, @"userName",nil];
//    
//    [self postRequest:params success:^(id jsonObject) {
//        result=jsonObject;
//    } failure:^(NSError *error) {
//        
//    }];
//
//    
//    
//}
#pragma mark - photo
//-(void)uploadPhoto{
//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://server.url"]];
//   // NSData *imageData = UIImageJPEGRepresentation(self.avatarView.image, 0.5);
//    NSDictionary *parameters = @{@"username": @""  , @"password" : @""};
//    AFHTTPRequestOperation *op = [manager POST:@"rest.of.url" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //do not put image inside parameters dictionary as I did, but append it!
//        [formData appendPartWithFileData:imageData name:cover fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@ ***** %@", operation.responseString, responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@ ***** %@", operation.responseString, error);
//    }];
//    [op start];
//}

- (void) postRequest:(NSDictionary *)postParameters success:(void (^)(id jsonObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if (success)
             success(responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Unavailable"
                                                         message:@"Unable to contact server. Please try again later."
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
         [alert show];
         
         if (failure)
             failure(error);
     }];
}



@end



