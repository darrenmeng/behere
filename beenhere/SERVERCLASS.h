//
//  SERVERCLASS.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/5.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SERVERCLASS;
@protocol serDelegate <NSObject>

@optional
-(void)updateID:(NSString *)beId andbherename:(NSString *)bename andEmail:(NSString *)beemail;

-(void)SearchID:(NSString *)JudgeThing andsearchthing:(NSString *)cmd;

-(NSString*)uploadUsers:(NSString *)cust;
@end
@interface SERVERCLASS : NSObject
{


}
@property (nonatomic, weak) id<serDelegate> delegate;


- (void) postRequest:(NSDictionary *)postParameters success:(void (^)(id jsonObject))success failure:(void (^)(NSError *error))failure;

-(NSDictionary*) getMutualFBFriendsWithFBid:(NSString*)fbID andCallback:(void (^)(NSDictionary *))callback;

@end
