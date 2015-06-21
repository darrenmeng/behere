//
//  ViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/12.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)registerAction:(id)sender {
    
    
    
}

- (IBAction)loginAction:(id)sender {
    
     
}


- (IBAction)fbloginAction:(id)sender {
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //判斷NSUserDefaults是否有值
    NSString * AccountCookie=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereEmail"];
    //有值代表已有帳號並登入
    NSLog(@"%@",AccountCookie);
    
    if (![AccountCookie isEqualToString:@""]) {
        
        //直接登入主頁面
        UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"root"];
        
        [self showDetailViewController:vc sender:self];
        
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
