//
//  TreeViewNode.h
//  The Projects
//
//  Created by Ahmed Karim on 1/12/13.
//  Copyright (c) 2013 Ahmed Karim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TreeViewNode : NSObject

@property (nonatomic) NSUInteger nodeLevel;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic, strong) id nodeObject;
@property (nonatomic, strong) NSMutableArray *nodeChildren;
@property (nonatomic, strong) NSString* beeid;
@property (nonatomic, strong) NSDate * date;
@property (nonatomic, strong) NSString * content_no;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSData * image;
@end
