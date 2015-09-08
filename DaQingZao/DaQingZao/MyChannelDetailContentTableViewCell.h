//
//  MyChannelDetailContentTableViewCell.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/4/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyChannelDetailContentTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UILabel *channelTitle;
@property (nonatomic, weak) IBOutlet UILabel *createTime;
@property (nonatomic, weak) IBOutlet UILabel *totalTime;
@property (nonatomic, weak) IBOutlet UIButton *downloadChannelButton;
@property (nonatomic, weak) IBOutlet UIButton *chooseChannelButton;

@property (nonatomic, weak) IBOutlet UIProgressView *downloadProgress;

@property (nonatomic,strong) SongEntity *songEntity;
@property (nonatomic,assign) NSInteger sceneIndex;
@end
