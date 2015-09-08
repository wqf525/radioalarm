//
//  AboutUSTailTableViewCell.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/10.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "AboutUSTailTableViewCell.h"
@interface AboutUSTailTableViewCell()
{
    
}
@property (weak, nonatomic) IBOutlet UIView *mailView;
@property (weak, nonatomic) IBOutlet UIView *wechatView;


@end

@implementation AboutUSTailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.mailView.userInteractionEnabled = YES;
    self.wechatView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureMail = [[UITapGestureRecognizer alloc]init];
    [tapGestureMail addTarget:self action:@selector(openMail)];
    tapGestureMail.numberOfTapsRequired = 1;
    [self.mailView addGestureRecognizer:tapGestureMail];
    UITapGestureRecognizer *tapGestureWechat = [[UITapGestureRecognizer alloc]init];
    [tapGestureWechat addTarget:self action:@selector(openWeChat)];
    tapGestureWechat.numberOfTapsRequired = 1;
    [self.wechatView addGestureRecognizer:tapGestureWechat];
    
}

-(void)openMail
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto://290334771@qq.com"]];
}

-(void)openWeChat
{
//    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto://290334771@qq.com"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
