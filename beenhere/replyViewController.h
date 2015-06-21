//
//  replyViewController.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface replyViewController : UIViewController
{

    NSMutableArray * replylist;
    NSMutableArray * replychildrn;
    NSString * replytext;
  
}

@property (strong,nonatomic)TreeViewNode * node;
@property (assign,nonatomic)NSInteger * indexpath;

@end
