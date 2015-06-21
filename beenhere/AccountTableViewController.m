//
//  AccountTableViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/30.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "AccountTableViewController.h"
#import "mydb.h"

#define NUMBERS @"0123456789"

@interface AccountTableViewController ()<UITextFieldDelegate>
{
    NSString * sex;
    UIDatePicker *datePicker;
    UITextField *dateTextField;
    NSLocale *datelocale;
    NSString * birthday;
    NSString * emailuserdefults;
    
    
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *sexselect;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *IDTextfield;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *NameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *BirthdatTextfield;
@property (weak, nonatomic) IBOutlet UITextField *TeleohoneTextfield;
@property (weak, nonatomic) IBOutlet UITextField *locationtextfield;


@end

@implementation AccountTableViewController
- (IBAction)sexaction:(id)sender {
    
    
    
    NSInteger tragetIndex=[sender selectedSegmentIndex];
    
    switch (tragetIndex) {
        case 0:
            sex=@"男";
            break;
        case 1:
            sex=@"女";
            break;
            
        default:
            break;
    }

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donenewcust) ];
    self.navigationItem.rightBarButtonItem=doneButton;
    
    // 加入 view 中
    [self.view addSubview:dateTextField];
    
    // 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    // 時區的問題
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    // 以下這行是重點 (螢光筆畫兩行) 將 UITextField 的 inputView 設定成 UIDatePicker
    // 則原本會跳出鍵盤的地方 就改成選日期了
    self.BirthdatTextfield.inputView = datePicker;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                                                          action:@selector(cancelPicker)];
    // 把按鈕加進 UIToolbar
    toolBar.items = [NSArray arrayWithObject:right];
    // 以下這行也是重點 (螢光筆畫兩行)
    // 原本應該是鍵盤上方附帶內容的區塊 改成一個 UIToolbar 並加上完成鈕
    self.BirthdatTextfield.inputAccessoryView = toolBar;
    self.TeleohoneTextfield.delegate=self;
    
    //初始化
    [self AccountDefault];
    
    
    //將資料修改結果透過NSNotificationCenter傳回
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ifsucess:) name:@"success" object:nil];
    
   
}



//初始化查詢登入者資料並SHOW在textfield
-(void)AccountDefault{
   
    
    //取NSUserDefaults
   NSString * emailuserdefult=[[NSUserDefaults standardUserDefaults] stringForKey:@"bhereEmail"];
    
     //透過存在NSUserDefaults的email 查詢使用者資料
   _dict=[[mydb sharedInstance]queryemail:emailuserdefult ][0];

    self.EmailTextfield.text=_dict[@"email"];
    
    NSLog(@"使用者資料%@",_dict);

    
     if (_dict[@"telephone"]!=[NSNull null]) {
         // 電話從sqlite取出是NSUMBER轉成nsstring
      NSString *mytelephone = [_dict[@"telephone"] stringValue];
         //從電話數字中加-
         NSMutableString *str = [[NSMutableString alloc] initWithString:mytelephone];
        // NSRange range = [str rangeOfString:@"-"];
             [str insertString:@"-" atIndex:3];
             [str insertString:@"-" atIndex:8];
             self.TeleohoneTextfield.text = str;
     }
    
    
    if (_dict[@"id"]!=[NSNull null]) {
        self.IDTextfield.text=_dict[@"id"];
    }
   
    if (_dict[@"location"]!=[NSNull null]) {
         self.locationtextfield.text=_dict[@"location"];
    }
    
     //從資料庫取出日期 轉成nsstring格式並秀在textfield
    if (_dict[@"birthday"]!= [NSNull null]) {
       NSDate *date = [NSDate dateWithTimeIntervalSince1970:[_dict[@"birthday"] integerValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm"];
    NSString *pushTime = [dateFormatter stringFromDate:date];
    
    _BirthdatTextfield.text=pushTime;
    }
    if (_dict[@"name"]!=[NSNull null]) {
        self.NameTextfield.text=_dict[@"name"];
    }
    self.PasswordTextfield.text=_dict[@"password"];
    
    
    NSString * sexs=[NSString stringWithFormat:@"%@",_dict[@"sex"]];
    if ([sexs isEqualToString:@"男"]) {
         self.sexselect.selectedSegmentIndex=0;
    }else{
        self.sexselect.selectedSegmentIndex=1;
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 按下完成鈕後的 method
-(void) cancelPicker {
    // endEditing: 是結束編輯狀態的 method
    if ([self.view endEditing:NO]) {
        // 以下幾行是測試用 可以依照自己的需求增減屬性
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"YYYY-MM-dd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        // 將選取後的日期 填入 UITextField
        self.BirthdatTextfield.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
        
        birthday=[formatter stringFromDate:datePicker.date];
        
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    

    NSCharacterSet*cs;
   cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if(!basicTest) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:@"請輸入數字"
                                                      delegate:nil
                                             cancelButtonTitle:@"確定"
                                             otherButtonTitles:nil];
        
        [alert show];
        return NO;
        
    }
  
    
    if (range.location == 13) {
        return NO;
    }else if (range.location == 8){
        
        NSMutableString *str = [[NSMutableString alloc] initWithString:self.TeleohoneTextfield.text];
        NSRange range = [str rangeOfString:@"-"];
        if (range.location!=NSNotFound)
        {
            
        }else {
            [str insertString:@"-" atIndex:3];
            [str insertString:@"-" atIndex:8];
            self.TeleohoneTextfield.text = str;
        }
        return YES;
    }else if(range.location==9) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:self.TeleohoneTextfield.text];
        NSString *str1;
        str1 = [str stringByReplacingOccurrencesOfString:@"-"withString:@""];
        self.TeleohoneTextfield.text = str1;
        return YES;
        
    }else
    {
        return YES;
    }
    
}


-(void)donenewcust{
  
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:birthday];
    
    NSLog(@"%@",birthday);
    NSLog(@"%@",_dict[@"bhere_no"]);
   // NSInteger num;
    
    //將電話數字中的-去掉
    NSString *telephone = [[NSString stringWithFormat:@"%@",_TeleohoneTextfield.text] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
   
    
    
    NSLog(@"電話:%@",telephone);
  
    
    
   [[mydb sharedInstance]updateBeName:_EmailTextfield.text    andBeTel:telephone andBeemail:self.EmailTextfield.text andBebirthday:date andBeid:self.IDTextfield.text andBelocation:self.locationtextfield.text andBepassword:self.PasswordTextfield.text  andBesex:sex andbhereno:_dict[@"bhere_no"] ];
    
    
    
    
    NSLog(@"id=%@",self.IDTextfield.text);
    
   

   // [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

-(void)ifsucess:(NSNotification *)message{

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message.object
                                                   delegate:nil
                                          cancelButtonTitle:@"確定"
                                          otherButtonTitles:nil];
    
    [alert show];


}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 3;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
