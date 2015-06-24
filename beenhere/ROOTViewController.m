//
//  ROOTViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/5/25.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "ROOTViewController.h"
#import "ContextMenuCell.h"
#import "YALContextMenuTableView.h"
#import "mydb.h"
#import "AFNetworking.h"
#import "friendTableViewController.h"
#import "StoreInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "CameraViewController.h"




static NSString *const menuCellIdentifier = @"rotationCell";

@interface ROOTViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
YALContextMenuTableViewDelegate,
UITextViewDelegate,
UIActionSheetDelegate
>
{
friendTableViewController * frinedview;
    NSString * NumRequest;
    UIView *contentView;
    UPStackMenu *stack;
    UIView *theSubView;
    NSString * TextContent;
    __weak IBOutlet UIView *thview;
}
@property (weak, nonatomic) IBOutlet UIButton *FriendreRreustlist;

@property (nonatomic, strong) YALContextMenuTableView* contextMenuTableView;

@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) NSArray *menuIcons;

@property (weak, nonatomic) IBOutlet UIView *Textview;
@property (weak, nonatomic) IBOutlet UIButton *SendAction;
@property (weak, nonatomic) IBOutlet UITextView *TextviewContent;


@end

@implementation ROOTViewController

- (IBAction)SendinfoAction:(id)sender {
    
    [self changeDemo];
    _Textview.hidden=YES;
    TextContent=_TextviewContent.text;
    NSLog(@"text:%@",TextContent);
    
    //通知到indexTableviewController
    [[NSNotificationCenter defaultCenter]postNotificationName:@"textcontent" object:TextContent];
    
    
}
- (IBAction)sendCancelaction:(id)sender {

    [self changeDemo];
    _Textview.hidden=YES;
    
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //測試
    NSString *beemail = [[NSUserDefaults standardUserDefaults] stringForKey:@"bhereEmail"];
    
    NSString *bpassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"bherePassword"];
    
     NSString *bname = [[NSUserDefaults standardUserDefaults] stringForKey:@"bherename"];
    NSString * BEID=[[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID" ];
    
    
    NSLog(@"%@ %@ %@ ",beemail ,bname,bpassword);
    
     _TextviewContent.delegate = self;
    
    [self contentview];
    
    [self initiateMenuOptions];
    
    [self inittextview];
    
    [self SearchRequest:BEID];
 
    
}
-(void)inittextview{

    [[_Textview layer] setBorderWidth:2.0];
    //邊框顏色
    [[_Textview layer] setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor];
    _Textview.layer.cornerRadius = 2.5;
    [[_Textview layer] setCornerRadius:10.0];


    _TextviewContent.text = @"寫下您的心情";
    _TextviewContent.textColor = [UIColor lightGrayColor];
  


}




-(void)contentview{

    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [contentView setBackgroundColor:[UIColor colorWithRed:112./255. green:47./255. blue:168./255. alpha:1.]];
     [contentView setBackgroundColor:[UIColor colorWithRed:24./255. green:182./255. blue:246./255. alpha:1.]];
    [contentView.layer setCornerRadius:6.];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(contentView.frame, 10, 10)];
    [contentView addSubview:icon];
    
    [self changeDemo];

}
-(void)changeDemo{

    if(stack)
        [stack removeFromSuperview];
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    [stack setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2 + 190)];
    [stack setDelegate:self];
    
    UPStackMenuItem *squareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"square"] highlightedImage:nil title:@"Square"];
    UPStackMenuItem *circleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"circle"] highlightedImage:nil title:@"Circle"];
    UPStackMenuItem *triangleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"triangle"] highlightedImage:nil title:@"Triangle"];
    UPStackMenuItem *crossItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"cross"] highlightedImage:nil title:@"Cross"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:squareItem, circleItem, triangleItem, crossItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:[UIColor blueColor]];
    }];
    
   
            [stack setAnimationType:UPStackMenuAnimationType_progressive];
            [stack setStackPosition:UPStackMenuStackPosition_up];
            [stack setOpenAnimationDuration:.4];
            [stack setCloseAnimationDuration:.4];
            [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
                [item setLabelPosition:UPStackMenuItemLabelPosition_right];
                [item setLabelPosition:UPStackMenuItemLabelPosition_left];
            }];
    
//        case 1:
//            [stack setAnimationType:UPStackMenuAnimationType_linear];
//            [stack setStackPosition:UPStackMenuStackPosition_down];
//            [stack setOpenAnimationDuration:.3];
//            [stack setCloseAnimationDuration:.3];
//            [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
//                [item setLabelPosition:UPStackMenuItemLabelPosition_right];
//            }];
//            break;
//            
//        case 2:
//            [stack setAnimationType:UPStackMenuAnimationType_progressiveInverse];
//            [stack setStackPosition:UPStackMenuStackPosition_up];
//            [stack setOpenAnimationDuration:.4];
//            [stack setCloseAnimationDuration:.4];
//            [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
//                if(idx%2 == 0)
//                    [item setLabelPosition:UPStackMenuItemLabelPosition_left];
//                else
//                    [item setLabelPosition:UPStackMenuItemLabelPosition_right];
//            }];
//            break;
//            
//        default:
//            break;
//    }
    
    [stack addItems:items];
    [self.view addSubview:stack];
    
    [self setStackIconClosed:YES];




}


- (IBAction)friendNoteAction:(UIBarButtonItem*)sender {
    
    
    NSLog(@"sadasd");
    
    NSString * numcount =[NSString stringWithFormat:@"有%@位使用者送出好友請求",NumRequest];
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:numcount message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
       
        
    
      
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    

    
    
    
    
}

-(void)sequefrinedtableview{



}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{

  



}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - uitextview
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    _TextviewContent.text = @"";
    _TextviewContent.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(_TextviewContent.text.length == 0){
        _TextviewContent.textColor = [UIColor lightGrayColor];
        _TextviewContent.text = @"寫下您的心情";
        [_TextviewContent resignFirstResponder];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    //should be called after rotation animation completed
    [self.contextMenuTableView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.contextMenuTableView updateAlongsideRotation];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    
    [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //should be called after rotation animation completed
        [self.contextMenuTableView reloadData];
    }];
    [self.contextMenuTableView updateAlongsideRotation];
    
}

#pragma mark - IBAction

- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    
    if (!self.contextMenuTableView) {
        self.contextMenuTableView = [[YALContextMenuTableView alloc]initWithTableViewDelegateDataSource:self];
        self.contextMenuTableView.animationDuration = 0.15;
        //optional - implement custom YALContextMenuTableView custom protocol
        self.contextMenuTableView.yalDelegate = self;
        
        //register nib
        UINib *cellNib = [UINib nibWithNibName:@"ContextMenuCell" bundle:nil];
        [self.contextMenuTableView registerNib:cellNib forCellReuseIdentifier:menuCellIdentifier];
    }
    
    // it is better to use this method only for proper animation
    [self.contextMenuTableView showInView:self.navigationController.view withEdgeInsets:UIEdgeInsetsZero animated:YES];
    
}

#pragma mark - Local methods

- (void)initiateMenuOptions {
    self.menuTitles = @[@"",
                        @"Send message",
                        @"Like profile",
                        @"Add to friends",
                        @"Add to favourites",
                        @"Block user"];
    
    self.menuIcons = @[[UIImage imageNamed:@"Icnclose"],
                       [UIImage imageNamed:@"SendMessageIcn"],
                       [UIImage imageNamed:@"LikeIcn"],
                       [UIImage imageNamed:@"AddToFriendsIcn"],
                       [UIImage imageNamed:@"AddToFavouritesIcn"],
                       [UIImage imageNamed:@"BlockUserIcn"]];
}


#pragma mark - YALContextMenuTableViewDelegate

- (void)contextMenuTableView:(YALContextMenuTableView *)contextMenuTableView didDismissWithIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"Menu dismissed with indexpath = %@", indexPath);
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (void)tableView:(YALContextMenuTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIViewController * setting = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
    
   UIViewController * friend = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    
    //透過menu 選單 跳到所需頁面
    switch (indexPath.row) {
        case  (1) :

             [self.navigationController pushViewController:setting animated:YES];
            break;
        case  (3) :
            
            [self.navigationController pushViewController:friend animated:YES];
            break;
            
        default:
            break;
    }
    
    
    [tableView dismisWithIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuTitles.count;
}

- (UITableViewCell *)tableView:(YALContextMenuTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:menuCellIdentifier forIndexPath:indexPath];
    
    if (cell) {
        cell.backgroundColor = [UIColor clearColor];
        cell.menuTitleLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        cell.menuImageView.image = [self.menuIcons objectAtIndex:indexPath.row];
    }
    
    
    
    
    
    
    
    return cell;
}

-(void)prepareForSegue:(YALContextMenuTableView *)segue sender:(id)sender{
   
    
}
#pragma mark - php search request
-(void)receiveFriendRquest:(NSDictionary *)receive{


  
    //將sql return 資料存成陣列
    
    [StoreInfo shareInstance].FriendRequestList=[receive[@"requestid"] mutableCopy];

    
    
    
    NumRequest=[NSString stringWithFormat:@"%lu",(unsigned long)[[StoreInfo shareInstance].FriendRequestList count]];
    
    [self.FriendreRreustlist setTitle:NumRequest forState:UIControlStateNormal];
    

    
    
   
    
}

#pragma mark - 確認資料庫好友請求
//確認資料庫有沒有好友請求
-(void)SearchRequest:(NSString *)SearchfriendID{
    
    
    
    //設定根目錄
    
    //設定要POST的鍵值
    
    //設定要POST的鍵值
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"findRequest",@"cmd", SearchfriendID, @"userID", nil];
    
   
    
    //產生控制request的物件
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //以POST的方式request並
    [manager POST:@"http://localhost:8888/beenhere/apiupdate.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //request成功之後要做的事情
        
        NSDictionary *apiResponse = [responseObject objectForKey:@"api"];
        NSLog(@"apiResponse:%@",apiResponse);
        
        
        // 取的signIn的key值，並輸出
       NSString *result = [apiResponse objectForKey:@"findRequest"];
        NSString * friend = [apiResponse objectForKey:@"requestid"];
        
        NSLog(@"result:%@ ",friend);
        
        
        //   判斷signUp的key值是否等於success
        if (![result isEqualToString:@"success"]) {
            //
            //
            NSLog(@"success");
            [self receiveFriendRquest:apiResponse];
            //
        }else{
            
            NSLog(@"no success");
            
            
        };
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"request error:%@",error);
        
        //  [self SearchResult:@"coneect error"];
        
        
        
        
    }];
    
    
    
    
}


- (IBAction)friendrequestcount:(id)sender {

    NSLog(@"sadasd");
    
    NSString * numcount =[NSString stringWithFormat:@"有%@位使用者送出好友請求",NumRequest];
    
    UIAlertController *alertcontroller=[UIAlertController alertControllerWithTitle:numcount message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelaction=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action){
        
        
        
        friendTableViewController * friend = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
        
        //friend.frindRequestList=ReturnInfo;
        
        
        
        [self.navigationController pushViewController:friend animated:YES];
        
        
    }];
    
    [alertcontroller addAction:cancelaction];
    
    [self presentViewController:alertcontroller animated:YES completion:nil ];
    
    


}


- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}


#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{

  
    switch (index) {
        case 0:
           _Textview.hidden=NO;
        [stack removeFromSuperview];
        [contentView removeFromSuperview];
            break;
            
        default:
            break;
    }
    NSLog(@"index:%lu",(unsigned long)index);
}



//code 跑出UIVIEW 待刪
-(void)UserTextView{
    
    theSubView=[[UIView alloc]
                        initWithFrame:CGRectMake(20, 380, 340, 130)];
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 280, 100)];
    
    
    
    
    
    text.backgroundColor=[UIColor whiteColor];
    theSubView.backgroundColor=[UIColor whiteColor];
    [theSubView addSubview:text];
    [[_Textview layer] setBorderWidth:3.0];
    //邊框顏色
    [[_Textview layer] setBorderColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor];
    
    [[theSubView layer] setCornerRadius:10.0];
    
    
    
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    theButton.frame = CGRectMake(280, 90, 60, 60);
    [theButton setImage:[UIImage imageNamed:@"Button Image.png"] forState:UIControlStateNormal];
    [theButton setTitle:@"c" forState:UIControlStateNormal];
    
    [theButton addTarget:self action:@selector(onSkillButton) forControlEvents:UIControlEventTouchUpInside];
    [theSubView addSubview:theButton];
   
    [self.view addSubview:theSubView];
    
}

// 點擊大頭照跳出選項
- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
}

// 點擊大頭照更換照片
- (IBAction)tap:(id)sender {
    NSString *aboutString = @"更新大頭貼照";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:aboutString
                                                            delegate:nil
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 ) {
        
        UIViewController *cameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraview"];
//        [self showViewController:cameraVC sender:self];
        [self presentViewController:cameraVC animated:YES completion:nil];
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }


}
@end
