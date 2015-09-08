//
//  MYChannelCollectionViewCell.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/31.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYChannelCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *channelViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *ChannelName;
@property (weak, nonatomic) IBOutlet UILabel *ChannelDetail;
@end
