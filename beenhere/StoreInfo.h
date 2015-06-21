//
//  StoreInfo.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/14.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreInfo : NSObject

@property (strong, nonatomic)NSMutableArray * FriendRequestList;

@property (strong, nonatomic)NSMutableArray * MyFriendtList;

@property (strong, nonatomic)NSMutableArray * indexContent;

@property (strong, nonatomic)NSMutableArray * ContentList;

+(StoreInfo *)shareInstance;



@end
