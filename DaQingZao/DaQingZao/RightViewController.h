//
//  RightViewController.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/15.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StreamingKit/STKAudioPlayer.h>


@interface RightViewController : UIViewController
//#define kNotificationGetInToChannelView @"kNotificationGetInToChannelView"

@property (strong, nonatomic) STKAudioPlayer* audioPlayer;
@property (assign, nonatomic) BOOL isPlaying;
@property (assign, nonatomic) NSInteger listenedTime;
-(void)playMusic;

@property (nonatomic, assign) NSInteger changedSong;

@property (nonatomic, strong) NSString *tempSongUrl;

-(void)playTempMusic:(SongEntity *)songEntity;
-(void)stopPlayingMusic;
-(void)pausePlayingMusic;
-(void)runbackground;
-(void)runforeground;

-(void)setText;


@end
