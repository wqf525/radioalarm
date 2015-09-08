//
//  AboutUSHeadTableViewCell.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/10.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "AboutUSHeadTableViewCell.h"
@interface AboutUSHeadTableViewCell()
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation AboutUSHeadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [NSString stringWithFormat:@"大青枣 版本号:%@",[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
