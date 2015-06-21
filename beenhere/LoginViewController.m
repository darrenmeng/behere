//
//  LoginViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/3.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "mydb.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *EmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *Passwordagain;




@end

@implementation LoginViewController

@synthesize EmailTextfield;
@synthesize PasswordTextfield;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    EmailTextfield.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereEmail" ];
     PasswordTextfield.text=[[NSUserDefaults standardUserDefaults]stringForKey:@"bherePassword" ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBTN:(id)sender {
    
    
}


- (IBAction)ContinueBTN:(id)sender {
    
  
    NSString *userID =EmailTextfield.text;
    NSString *password =PasswordTextfield.text;
    //設定根目錄
    //NSURL *hostRootURL = [NSURL URLWithString:ServerApiURL];
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"signIn", @"cmd", userID, @"userID", password, @"password", nil];
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/api.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        //將查詢資料存到NSDictionary
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        //取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"signIn"];
        NSLog(@"result:%@",result);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //判斷signUp的key值是否等於success
        if ([result isEqualToString:@"fail"]) {
            
            NSLog(@"no suceess");
            [self logincheck:@"帳號錯誤"];
            
            NSLog(@"success");
        }else {
          
            [self logincheck:@"登入成功"];
            
          BOOL  existemail=[[mydb sharedInstance]andnewEmail:userID ];
            if (existemail==true) {
                NSLog(@"have eamil");
                
            }else{
                
                NSLog(@"沒有email");
                [[mydb sharedInstance]insertCustDict:apiResponse];
    
            }

           

            NSLog(@"success");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        [self logincheck:@"SERVER Error"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];

    
}




-(void)logincheck:(NSString *)account{
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:account message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        if ([account isEqualToString:@"登入成功"]) {
            //成功開始下一步
           NSDictionary * row= [[mydb sharedInstance]queryemail:EmailTextfield.text][0];
            
            NSString * beid=row[@"id"];
            NSString * bename=row[@"name"];
            
            
            NSLog(@"id:%@,name:%@",beid,bename);
            
             [self setField:EmailTextfield.text forKey:@"bhereEmail"];
             [self setField:PasswordTextfield.text forKey:@"bherePassword"];
             [self setField:beid forKey:@"bhereID"];
              [self setField:bename forKey:@"bherename"];
            
            
            //到下一個viewcontroller
            UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"root"];
            
            [self showDetailViewController:vc sender:self];
        }
        //返回重新輸入email
    
        
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];






}

- (void)setField:(NSString *)field forKey:(NSString *)key
{
    
    
    if (field != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
