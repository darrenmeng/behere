//
//  PinEditViewController.m
//  beenhere
//
//  Created by CP Wen on 2015/6/24.
//  Copyright (c) 2015年 beenhere. All rights reserved.
//

#import "PinEditViewController.h"
#import "PinEditToolViewController.h"
#import "PinDAO.h"
#import "Pin.h"

@interface PinEditViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *theScrollView;
@property (weak, nonatomic) IBOutlet UIView *toolContainerView;

@end

@implementation PinEditViewController

- (IBAction)backBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.childViewControllers.
    Pin *pin = [Pin new];
    pin.memberId = 3;

    PinDAO *pinDAO = [[PinDAO alloc] init];
    NSMutableArray *rows = [pinDAO getAllPin];
    NSLog(@"rows= %@", rows);
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 監聽keyboard的動態
    // keyboard跳出來之後，這裡會放到通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    // 監聽keyboard的動態
    // keyboard將隱藏之前，這裡會放到通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 不知道initWithTarget是什麼意思？
    // 替scrollView加上手勢
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
    // 下一行self.myScrollView改成self.view也可以
    [self.theScrollView addGestureRecognizer:tapGesture];
    
    self.theScrollView.backgroundColor = [UIColor redColor];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// Called when the UIKeyboardDidShowNotification is sent.
// keyboard跳出來之後會進到這個方法
- (void)keyboardWillShow: (NSNotification *) aNotification {
    
    // userInfo裡有keyboard大小及尺寸的訊息
    NSDictionary *info = [aNotification userInfo];
    NSLog(@"info: %@", info);
    
    // 取出info裡的資訊
    // CGRectValue是一轉換的方法，轉換成CGRect
    // 因為CGRect包含座標原點及尺寸，如果只要尺寸，就用size屬性
    // kbSize是keyboard的尺寸
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGPoint kbPoint = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].origin;
    NSLog(@"kbPoint x = %f, y = %f", kbPoint.x, kbPoint.y);
    
    // edge inset是間隔的意思
    // 參數分別為物件內的間隔是：上 左 下 右
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, kbSize.width);
    self.theScrollView.contentInset = contentInsets;
    self.theScrollView.scrollIndicatorInsets = contentInsets;
    
    
    // 取得包住textView的View的尺寸，就先稱text爸
    CGRect bkgndRect = self.toolContainerView.superview.frame;
    NSLog(@"scrollView height = %f, width = %f", bkgndRect.size.height, bkgndRect.size.width);
    
    NSLog(@"scorllView's content height = %f, width = %f",self.theScrollView.contentSize.height, self.theScrollView.contentSize.width);
    
    // 將 text爸的高度 加上 keyboard的高度 再指定給text爸
    bkgndRect.size.height += kbSize.height;
    [self.toolContainerView.superview setFrame:bkgndRect];
    
    // Sets the offset from the content view’s origin that corresponds to the receiver’s origin.
    // 叫scrollView的contentView位移，這裡是x軸不動。
    [self.theScrollView setContentOffset:CGPointMake(0, self.toolContainerView.frame.origin.y-kbSize.height) animated:YES];
}

- (void)keyboardWillBeHidden: (NSNotification *) aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.theScrollView.contentInset = contentInsets;
    self.theScrollView.scrollIndicatorInsets = contentInsets;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    NSLog(@"shouldEnd");
    return true;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"didEnd");
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touched");
}

// 要加<UIScrollViewDelegate>，才有此方法
// 如果scrollView被滑動，就會進入此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    NSLog(@"contentOffset = %f", scrollView.contentOffset.x);
}

// 自訂方法，當使用者按下背景就進到這裡
- (void) hideKeyboard {
    
    //撤self.view下的keyboard
    [self.view endEditing:YES];
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
