//
//  IndexTableViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/15.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "IndexTableViewController.h"
#import "StoreInfo.h"
#import "QuoteTableViewCell.h"
#import "TreeViewNode.h"
#import "replyViewController.h"
#import "mydb.h"
@interface IndexTableViewController ()
{

    NSMutableArray* Content;
    NSDictionary * contentkey;
    
    NSUInteger indentation;
    NSMutableArray *nodes;
    
}
#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@property (nonatomic, strong) QuoteTableViewCell *prototypeCell;
@property (nonatomic, retain) NSMutableArray *displayArray;


@end

@implementation IndexTableViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    
  // [self setupTableView];
    
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"welcome",@"text", nil];
    //展開收起
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
   
    
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 70.0;
    
     Content=[[NSMutableArray alloc]init ];
     nodes=[[NSMutableArray alloc]init ];
    [self fillNodesArray:params];
    [self fillDisplayArray];
  
  //  Content=[StoreInfo shareInstance].ContentList;
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddContent:) name:@"textcontent" object:nil];
    [self loaddata];
}
-(void)loaddata{

    
     NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
   Content=[[mydb sharedInstance]queryindexcontent:userID ];

    
    NSLog(@"content count:%lu",(unsigned long)Content.count);
   
    
    for (int a=0;  a==Content.count ; a++) {
        NSLog(@"dqwdqwdqwdqwdsdfsdf;sdkf;skdfks;dfk;sdfs");
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
        firstLevelNode1.nodeLevel = 0;
        firstLevelNode1.nodeObject = Content[a][@"text"];
        firstLevelNode1.isExpanded = YES;
        firstLevelNode1.beeid = Content[a][@"id"];
        firstLevelNode1.nodeChildren = [[self fillChildrenForNode:[NSString stringWithFormat:@"%@",Content[a][@"content_no"]]] mutableCopy];
        
        [nodes insertObject:firstLevelNode1 atIndex:0];
        NSLog(@"node repeat:%@",nodes);
    }
   
    
    NSMutableArray * i=[[NSMutableArray alloc] init];
    i=[[mydb sharedInstance]queryreplycontent:[NSString stringWithFormat:@"%@",Content[0][@"content_no"]]];
    
    
    NSLog(@"content_no:%@",i);
    NSLog(@"nodearray:%@",nodes);
    NSLog(@"%@",Content[0][@"content_no"]);
    
    [self fillDisplayArray];
    [self.tableView reloadData];
}
- (void)fillNodesArray:(NSDictionary *)parms
{
    
    
    
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
    firstLevelNode1.nodeLevel = 0;
    firstLevelNode1.nodeObject = parms[@"text"];
    firstLevelNode1.isExpanded = YES;
   // firstLevelNode1.nodeChildren = [[self fillChildrenForNode] mutableCopy];
   
     [nodes insertObject:firstLevelNode1 atIndex:0];
    
    
    
    
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (NSArray *)fillChildrenForNode:(NSString *)content_no
{
   
    NSMutableArray * child=[[NSMutableArray alloc] init];
    child=[[mydb sharedInstance]queryreplycontent:content_no];
    
    NSMutableArray *childrenArray=[[NSMutableArray alloc] init];
    
    for (int a=0; a == child.count; a++) {
        
        TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
        secondLevelNode1.nodeLevel = 1;
        secondLevelNode1.nodeObject = child[a][@"text"];
        
        [childrenArray insertObject:secondLevelNode1 atIndex:0];
    }
    
    
    return childrenArray;
   }


#pragma mark - 輸入的回覆的文字
//回覆按鈕
- (IBAction)replyAction:(id)sender {
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
      TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    NSLog(@"index:%@,row:%ld",indexPath,(long)indexPath.row);
   //replyViewController *tvc=segue.destinationViewController;
    
//    tvc.replylist=[self.displayArray objectAtIndex:indexPath.row];

}



#pragma mark - 輸入的文字存到陣列
-(void)AddContent:(NSNotification *)message{

    NSDictionary * dict=[[NSDictionary alloc]init];
    
    dict = [NSDictionary dictionaryWithObject:message.object forKey:@"text"];
    
    [self fillNodesArray:dict];
   
    
    //存到SQLite
    NSString *userID = [[NSUserDefaults standardUserDefaults]stringForKey:@"bhereID"];
    
     [[mydb sharedInstance]insertMemeberNo:userID andcontenttext:dict[@"text"] andlevel:@"0"];
    
    

    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrototypeCell
- (QuoteTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    }
    
    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(QuoteTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *quote = Content[indexPath.row][@"text"];
    
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    cell.contentlabel.text = node.nodeObject;
    NSLog(@"node:%@",node.nodeObject);
   
    
    
    NSDate * date=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentTime = [dateFormatter stringFromDate:date];
    //cell.numberLabel.text = [NSString stringWithFormat:@"Quote %ld", (long)indexPath.row];
    cell.detaillabel.text=currentTime;
    
   }

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return self.displayArray.count;
   
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contentcell" forIndexPath:indexPath];
    
    QuoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QuoteTableViewCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
   
//    if (Content[indexPath.row][@"text"]) {
//      
////       UILabel *label = (UILabel *)[self.tableView viewWithTag:101];
//
//        
//        
//        UIImage *uiimage = (UIImage *)[self.tableView viewWithTag:102];
//       // testLabel.text = Content[indexPath.row][@"text"];
//    }
//    
//   
//    if (Content[indexPath.row][@"image"]) {
//        
//    }
     [cell setNeedsDisplay];
    
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addFriendButton.frame = CGRectMake(300.0f, 5.0f, 75.0f, 30.0f);
    [addFriendButton setTitle:@"like" forState:UIControlStateNormal];
    [cell addSubview:addFriendButton];
    [addFriendButton addTarget:self
                        action:@selector(agreefriend:)
              forControlEvents:UIControlEventTouchUpInside];
   
  
    
    
    
   
    
    
    
    
    
    
    return cell;
    
    
    
    
    
    
}
#pragma mark-
- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.tableView reloadData];
    
    }
//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in nodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

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


#pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 
 
 NSIndexPath *indexpath=self.tableView.indexPathForSelectedRow;
  TreeViewNode *node = [self.displayArray objectAtIndex:indexpath.row];
 replyViewController *tvc=segue.destinationViewController;
 
  tvc.node=node;
     
   
 }

@end
