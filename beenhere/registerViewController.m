//
//  registerViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "registerViewController.h"
#import "ROOTViewController.h"
#import "mydb.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SERVERCLASS.h"



NSString *const bhereEmail = @"bhereEmail";
NSString *const bherePassword = @"bherePassword";
NSString *const bherename = @"bherename";
NSString *const bhereID = @"bhereID";

static NSString *const kurlson_download=@"http://localhost:8888/beenhere/index.php";

static NSString *const kurlson_upload=@"http://localhost:8888/beenhere/usersUP.php";




@interface registerViewController ()
{
    NSMutableArray *custs;
    BOOL existemail;
}




@end

@implementation registerViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//註冊第一步
-(void)registeraction{

    //測試
    NSString *myString = [[NSUserDefaults standardUserDefaults] stringForKey:bhereEmail];
    
    NSString *myString1 = [[NSUserDefaults standardUserDefaults] stringForKey:bherePassword];
    
    
    NSLog(@"%@ %@ ",myString,myString1);

    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:@"註冊" message:nil preferredStyle:UIAlertControllerStyleAlert];
    

   
    
    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"請輸入E-MAIL";
    
      
        
        CGFloat yourSelectedFontSize = 20.0 ;
        UIFont *yourNewSameStyleFont = [textField.font fontWithSize:yourSelectedFontSize];
        textField.font = yourNewSameStyleFont ;
        
        
        textField.text=[[NSUserDefaults standardUserDefaults] stringForKey:bhereEmail];
 
  
    }];
    
    
    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"密碼";
        textField.secureTextEntry=YES;
        
        CGFloat yourSelectedFontSize = 20.0 ;
        UIFont *yourNewSameStyleFont = [textField.font fontWithSize:yourSelectedFontSize];
        textField.font = yourNewSameStyleFont ;
        
        textField.text=[[NSUserDefaults standardUserDefaults] stringForKey:bherePassword];
        
       
    }];
    
    UIAlertAction * backbutton=[UIAlertAction actionWithTitle:@"back" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"繼續" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        
        UITextField * login=alertcontroller.textFields.firstObject;
         UITextField * password=alertcontroller.textFields.lastObject;
        
        
    

        
         [self setField:login forKey:bhereEmail];
         [self setField:password forKey:bherePassword];
        
        
        //呼叫方法判斷EMAIL有沒有註冊過
        [self SearchID:login.text andsearchthing:@"SearchEmail"];
       
        
        
   
    }];
    

    [alertcontroller addAction:cancelaction];
    [alertcontroller addAction:backbutton];
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    //判斷EMAIL有沒有註冊過
    //[self CheckEmail];

}

- (BOOL)validateAccount:(NSString *)account{
    NSString *regex = @"[A-Z0-9a-z]{1,18}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:account];
}

- (BOOL)validatePassword:(NSString *)password{
    NSString *regex = @"[A-Z0-9a-z]{6,18}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:password];
}


//接收註冊資訊並透過UIAlertController輸出
-(void)Emailinfo:(NSString *)account
{
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:account message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        if ([account isEqualToString:@"註冊成功"]) {
            //成功開始下一步
            [self registerwelcome];
        }else {
        
            
            if([account isEqualToString:@"ID重複"])
            {
                //返回重新輸入ID
                [self registerID];
            }else{
                //返回重新輸入email
                [self registeraction];
            
            }

        }
        
       
        
    }];
    
    [alertcontroller addAction:cancelaction];

    [self presentViewController:alertcontroller animated:YES completion:nil ];


}


-(void)registerwelcome{

    // Here we need to pass a full frame
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    // Add some custom content to the alert view
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 270, 180)];
    
    
    [imageView setImage:[UIImage imageNamed:@"welcome.jpg"]];
    
    [demoView addSubview:imageView];
    
    [alertView setContainerView:demoView];
    
    // Modify the parameters
       [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"確定", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
   
        [self registerID];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
    
}


//註冊第三步 輸入姓名及ID
-(void)registerID{
    
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"輸入ID";
        
        
         textField.text=[[NSUserDefaults standardUserDefaults] stringForKey:bhereID];
        
        CGFloat yourSelectedFontSize = 20.0 ;
        UIFont *yourNewSameStyleFont = [textField.font fontWithSize:yourSelectedFontSize];
        textField.font = yourNewSameStyleFont ;
        
        
    }];
    
    
    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder=@"輸入姓名";
        
        textField.text=[[NSUserDefaults standardUserDefaults] stringForKey:bherename];
        
        CGFloat yourSelectedFontSize = 20.0 ;
        UIFont *yourNewSameStyleFont = [textField.font fontWithSize:yourSelectedFontSize];
        textField.font = yourNewSameStyleFont ;
        
       
    }];
    
    
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"繼續" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
          UITextField * UserID=alertcontroller.textFields.firstObject;
         UITextField * USERNAME=alertcontroller.textFields.lastObject;
        
        
        //呼叫SERVERCLASS檢查mysql id有沒有重復

           // [[SERVERCLASS alloc]updateID:UserID.text andbherename:USERNAME.text andEmail:[[NSUserDefaults standardUserDefaults]stringForKey:bhereEmail ]];
        
        
        
     
        
            [self SearchID:UserID.text andsearchthing:@"updateID" ];
      
        
       
        //呼叫存入NSUserDefaults的方法
        [self setField:USERNAME forKey:bherename];
        [self setField:UserID forKey:bhereID];
        
        NSLog(@"USERNAME:%@,USER:%@",USERNAME.text,UserID.text);
        
        //執行新增資料到sqlite
       
   
       

        //到下一個viewcontroller
//        UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"root"];
//        
//        [self showDetailViewController:vc sender:self];

    }];
    
    
    UIAlertAction *cancelaction1=[UIAlertAction actionWithTitle:@"wellcome Beenhere" style:UIAlertActionStyleDefault handler:nil];
    
    
    
    [alertcontroller addAction:cancelaction];
    [alertcontroller addAction:cancelaction1];
  
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    
    //檢查ID傳回結果
    
    
    
   

    
}
-(void)CheckID{

    NSString * IDresult= [[NSUserDefaults standardUserDefaults]stringForKey:@"sreachID"];
    
    
    NSLog(@"userid:%@",IDresult);
    if ([IDresult isEqualToString:@"success"]) {
        [self newmenber];
        [self SinupMYsql];
    }else{
    
        [self Emailinfo:@"ID重複"];
    }
    
    
}

-(void)welcomebeenhere{
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:@"申請帳號成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        
        //到下一個viewcontroller
        UINavigationController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"root"];
        
        [self showDetailViewController:vc sender:self];
        
    }];

     [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];


}


- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
   
    [alertView close];
}

//將帳號密碼存入NSUserDefaults的方法
- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    
    
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self registeraction];
}


-(void)viewWillDisappear:(BOOL)animated{

    
   
}


#pragma php update
//新增將資料存到sqllite的method
-(void)newmenber{

    NSString *beemail = [[NSUserDefaults standardUserDefaults] stringForKey:@"bhereEmail"];
    
    NSString *bpassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"bherePassword"];
    
    NSString *bname = [[NSUserDefaults standardUserDefaults] stringForKey:@"bherename"];
    
    NSString *beid = [[NSUserDefaults standardUserDefaults] stringForKey:bhereID];
    
 
    
    
    [[mydb sharedInstance]insertMemeberNo:beid andMBName:bname andEMAIL:beemail andPassword:bpassword ];
    
    NSLog(@"%@ %@ %@ ",beemail ,beemail,bpassword);

    [self welcomebeenhere];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//透過Afnewworking傳遞參數到php檢查SQL將資料上傳到MYsql
-(void)SearchID:(NSString *)JudgeThing andsearchthing:(NSString *)cmd {
    
    
    
    //設定根目錄
    
    //設定要POST的鍵值
    
    //1. @"updateID"  2.@"SearchEmail"
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:cmd,@"cmd", JudgeThing, @"userID",nil];
    
    
    NSLog(@"params:%@",params);
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    
    [manager POST:@"http://localhost:8888/beenhere/api.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        // 取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"upID"];
        NSLog(@"upid result:%@",result);
        
        //   判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            if ([cmd isEqualToString:@"updateID"]) {
                NSLog(@"success");
                [self newmenber];
                [self SinupMYsql];
            }else{
            
                [self Emailinfo:@"註冊成功"];
                
                NSLog(@"success");
            
            }
            
           
            
        }else {
             if ([cmd isEqualToString:@"updateID"]) {
            [self Emailinfo:@"ID重複"];
            NSLog(@"up no suceess");
             }else{
             
                 NSLog(@"no suceess");
                 [self Emailinfo:@"此Email已存在"];

             }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
         [self Emailinfo:@"SERVER Error"];
    }];
    

    
    
    
}


-(void)SinupMYsql{
    
    //判斷基本的認證是否成功
    // if ([self validateAccount:_userIDTF.text] && [self validatePassword:_passwordTF.text]) {
    //產生hud物件，並設定其顯示文字
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setLabelText:@"connecting"];
    //存取userID及password
    NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:bhereID ];
    NSString *password = [[NSUserDefaults standardUserDefaults]stringForKey:bherePassword ];
    NSString *userEmail =[[NSUserDefaults standardUserDefaults]stringForKey:bhereEmail ];
    NSString *userName =[[NSUserDefaults standardUserDefaults]stringForKey:bherename ];
    //設定根目錄
    
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"signUp", @"cmd", userID, @"userID", password, @"password",userEmail, @"email",userName, @"name" ,nil];
    
    
    
    NSLog(@"註冊資料:%@",params);
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/api.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        //取的signIn的key值，並輸出
        NSString *result = [apiResponse objectForKey:@"signUp"];
        NSLog(@"result:%@",result);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //判斷signUp的key值是否等於success
        if ([result isEqualToString:@"success"]) {
            
            
            
            
            NSLog(@"insert success");
        }else {
            
            NSLog(@"no insert");
           
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        
        [self Emailinfo:@"SERVER Error"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    
}




@end
