//
//  detailreplyTableViewCell.h
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreeViewNode.h"

@interface detailreplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (retain, strong) TreeViewNode *treeNode;

@end
