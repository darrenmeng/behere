//
//  QuoteTableViewCell.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/19.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "QuoteTableViewCell.h"



@implementation QuoteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (void)setBounds:(CGRect)bounds
//{
//    [super setBounds:bounds];
//    
//    self.contentView.frame = self.bounds;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
   self.contentlabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentlabel.frame);
}
- (void)drawRect:(CGRect)rect
{
//    CGRect cellFrame = self.contentlabel.frame;
//    CGRect buttonFrame = self.cellButton.frame;
//    int indentation = self.treeNode.nodeLevel * 25;
//   cellFrame.origin.x = cellFrame.origin.x + indentation + 5;
// //   buttonFrame.origin.x = 2 + indentation;
//    self.contentlabel.frame = cellFrame;
//    self.cellButton.frame = buttonFrame;
    CGRect cellFrame = self.contentlabel.frame;
    CGRect buttonFrame = self.cellButton.frame;
    CGRect detail=self.detaillabel.frame;
    CGRect userimage = self.userimage.frame;
    int indentation = self.treeNode.nodeLevel * 60;
    cellFrame.origin.x = buttonFrame.size.width + indentation + 70;
     detail.origin.x = buttonFrame.size.width + indentation + 70;
    userimage.origin.x = indentation +3;
  //  buttonFrame.origin.x = 2 + indentation;
    self.contentlabel.frame = cellFrame;
    self.cellButton.frame = buttonFrame;
    self.userimage.frame = userimage;
    self.detaillabel.frame=detail;
}

- (void)setTheButtonBackgroundImage:(UIImage *)backgroundImage
{
    [self.cellButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (IBAction)expand:(id)sender
{
    self.treeNode.isExpanded = !self.treeNode.isExpanded;
    [self setSelected:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ProjectTreeNodeButtonClicked" object:self];
}

- (IBAction)reply:(id)sender {
    
    
    
      [[NSNotificationCenter defaultCenter]postNotificationName:@"replyButtonClicked" object:self];
    
    
}


@end
