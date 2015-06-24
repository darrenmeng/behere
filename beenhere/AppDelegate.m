//
//  AppDelegate.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/12.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (NSString *)GetBundleFilePath:(NSString *)filename
{
    //可讀取，不可寫入
    NSString *bundleResourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *dbPath = [bundleResourcePath stringByAppendingPathComponent:filename];
    return dbPath;
    
}


- (NSString *)GetDocumentFilePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths firstObject];
    NSString *dbPath = [documentPath stringByAppendingPathComponent:filename];
    return dbPath;
    
}

-(void)copyDBtoDocumentifNeeded{
    
    //可讀寫 db:在document 內的實際資料
    NSString *dbPath=[self GetDocumentFilePath:@"beenhere.sqlite"];
    NSString *pinDBPath=[self GetDocumentFilePath:@"pin_V1_20150624.sqlite"];
    
    //發佈安裝時,再套件 bundle的原始db(只可讀取)
    NSString *defaultDBPath =[self GetBundleFilePath:@"beenhere.sqlite" ];
    NSString *defaultPinDBPath =[self GetBundleFilePath:@"pin_V1_20150624.sqlite" ];
    
    
    NSLog(@"\ndb:%@\ndefaltDB:%@",dbPath,defaultDBPath);
    
    NSFileManager *fileManager =[NSFileManager defaultManager];
    BOOL success, isPinDBPathOK;
    NSError *error, *pinDBPathError;
    
    success=[fileManager fileExistsAtPath:dbPath ];
    isPinDBPathOK=[fileManager fileExistsAtPath:pinDBPath ];

    
    if (!success) {
        //copy
        success=[fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        if (!success) {
            NSLog(@"error:%@",[error localizedDescription]);
        }
        
    }else{
        //處理db/table資料結構
        
    }
    
    if (!isPinDBPathOK) {
        //copy
        isPinDBPathOK=[fileManager copyItemAtPath:defaultPinDBPath toPath:pinDBPath error:&pinDBPathError];
        if (!isPinDBPathOK) {
            NSLog(@"pinDBPathError:%@",[pinDBPathError localizedDescription]);
        }
        
    }else{
        //處理db/table資料結構
        
    }
    
    
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self copyDBtoDocumentifNeeded];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
