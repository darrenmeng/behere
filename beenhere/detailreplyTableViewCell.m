//
//  detailreplyTableViewCell.m
//  beenhere
//
//  Created by ChiangMengTao on 2015/6/21.
//  Copyright (c) 2015年 MobileIT. All rights reserved.
//

#import "detailreplyTableViewCell.h"

@implementation detailreplyTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
    
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.timeLabel.frame);
}
@end
