//
//  IndexTableViewController.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/15.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexTableViewController : UITableViewController

@property (strong, nonatomic)NSMutableArray * contentlist;

-(void)loaddata;
@end
