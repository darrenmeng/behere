//
//  registerViewController.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "mydb.h"

@interface registerViewController : UIViewController<CustomIOSAlertViewDelegate>




@property (assign, nonatomic) NSInteger flag;   //1:新增, 2:修改
@property (strong, nonatomic) NSDictionary *dict;
@end
