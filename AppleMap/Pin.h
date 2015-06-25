//
//  Pin.h
//  beenhere
//
//  Created by CP Wen on 2015/6/25.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Pin : MKPointAnnotation

@property (assign, nonatomic)NSInteger pinId;
@property (assign, nonatomic)NSInteger memberId;

@end
