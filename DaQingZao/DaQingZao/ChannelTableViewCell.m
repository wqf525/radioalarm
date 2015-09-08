//
//  ChannelTableViewCell.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/20.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "ChannelTableViewCell.h"
@implementation ChannelTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UIView *actionView=[self.contentView viewWithTag:100];
    [actionView.layer setBorderColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
    [actionView.layer setBorderWidth:2.0];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
