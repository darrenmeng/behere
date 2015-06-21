//
//  StoreInfo.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/14.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "StoreInfo.h"

@implementation StoreInfo


static StoreInfo *shareInstance;

+(StoreInfo *)shareInstance {
    
    if (shareInstance == nil) {
        shareInstance = [[StoreInfo alloc] init];
    }
    return shareInstance;
}





@end
