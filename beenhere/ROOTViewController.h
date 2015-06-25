//
//  ROOTViewController.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/25.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPStackMenu.h"

@interface ROOTViewController : UIViewController<UPStackMenuDelegate>
{
    NSMutableArray * ReturnInfo;

}
- (IBAction)friendrequestcount:(id)sender;

- (IBAction)tap:(id)sender;

@end
