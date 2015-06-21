//
//  replyViewController.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "replyViewController.h"
#import "TreeViewNode.h"
#import "detailreplyTableViewCell.h"

#define SYSTEM_VERSION                              ([[UIDevice currentDevice] systemVersion])
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IS_IOS8_OR_ABOVE                            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))

@interface replyViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) detailreplyTableViewCell *prototypeCell;

@property (weak, nonatomic) IBOutlet UITextField *replytextfield;


@end

@implementation replyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    replylist=[[NSMutableArray alloc] init];
    
    replychildrn= _node.nodeChildren;

        
    NSLog(@"replyc:%@",replychildrn);
     [replylist addObject:_node];

    
    
    [self fillNodeWithChildrenArray:_node.nodeChildren];
 
    
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//This function is used to fill the array that is actually displayed on the table view
- (IBAction)replyAction:(id)sender {
    
    replytext=_replytextfield.text;
    
    
    
}





//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [replylist addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}
#pragma mark - PrototypeCell
- (detailreplyTableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        _prototypeCell = [self.tableview dequeueReusableCellWithIdentifier:NSStringFromClass([detailreplyTableViewCell class])];
    }
    
    return _prototypeCell;
}

#pragma mark - Configure
- (void)configureCell:(detailreplyTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
   // NSString *quote = replylist[indexPath.row];
    
    
    TreeViewNode * node=replylist[indexPath.row];
    cell.contentLabel.text =node.nodeObject;
    //cell.quoteLabel.text = quote;
}


- (NSArray *)fillChildrenForNode
{
    TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
    secondLevelNode1.nodeLevel = 1;
    secondLevelNode1.nodeObject = [NSString stringWithFormat:@"Child node 1"];
    
    
    NSArray *childrenArray = [NSArray arrayWithObjects:secondLevelNode1,  nil];
    
    return childrenArray;
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [replylist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailreplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([detailreplyTableViewCell class])];
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IOS8_OR_ABOVE) {
        return UITableViewAutomaticDimension;
    }
    
    //self.prototypeCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(self.prototypeCell.bounds));
    
    [self configureCell:self.prototypeCell forRowAtIndexPath:indexPath];
    
    [self.prototypeCell updateConstraintsIfNeeded];
    [self.prototypeCell layoutIfNeeded];
    
    return [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
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
