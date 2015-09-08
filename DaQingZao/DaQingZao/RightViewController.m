//
//  RightViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/15.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "RightViewController.h"
#import "SampleQueueId.h"
#import <AVFoundation/AVFoundation.h>
#import "ChooseMyChannelTableViewController.h"
#import "MyGettingSongsDBEntity.h"

#define default_music @"sample.m4a"

@interface RightViewController ()<STKAudioPlayerDelegate>
{
    
    NSTimer* timer;
    NSTimer* _runOutTimer;
    
    NSDate *_startTime;
    NSDate *_endTime;
    BOOL _tempPlaying;
    BOOL _fakePlaying;
}
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (nonatomic, strong, readonly) NSArray *songArray;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)getIntoChannel:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;

@end

@implementation RightViewController

-(NSArray *)songArray
{
    return [MyGettingSongsDBEntity MR_findAll];
}

-(STKAudioPlayer *)audioPlayer
{
    if(!_audioPlayer)
    {
        NSError* error;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        _audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
        _audioPlayer.meteringEnabled = YES;
        _audioPlayer.volume = 1;
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"right_background"]]];
    [self.headImage.layer setMasksToBounds:YES];
    [self.headImage.layer setCornerRadius:self.headImage.frame.size.height/2.0];
    _slider.continuous = YES;
    _slider.minimumTrackTintColor = [UIColor colorWithRed:214.0f/255.0f green:218.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    _slider.maximumTrackTintColor = [UIColor lightGrayColor];
    [_slider setThumbImage:[UIImage imageNamed:@"player_progress_point_h"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(playMusic) forControlEvents:UIControlEventTouchUpInside];
    [self.prevButton addTarget:self action:@selector(prevMusicPlay) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(nextMusicPlay) forControlEvents:UIControlEventTouchUpInside];
    
    [self.slider addTarget:self action:@selector(sliderChange) forControlEvents:UIControlEventValueChanged];
    [self setupTimer];
    [self setText];
    
}

-(void)runbackNoVoice
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"novoice" ofType:@"mp3"];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    [self.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void)runbackground
{
    if(!self.isPlaying)
    {
        //直接play
        [self runbackNoVoice];
        _fakePlaying = YES;
    }
}

-(void)runforeground
{
    //停止play
    if(!self.isPlaying)
    {
        [self.audioPlayer stop];
        _fakePlaying = NO;
    }else
        [self animationOfImage];
}

-(void)setText
{
    if(self.songArray==nil || self.songArray.count==0)
    {
        
        [self.songNameLabel setText:@"没有设置我的媒体"];
        return;
    }
    
    NSInteger index = [self getSongIndex];
    MyGettingSongsDBEntity *entity = self.songArray[index];
    [self.songNameLabel setText:entity.songName];
}

-(void) setupTimer
{
    timer = [NSTimer timerWithTimeInterval:0.001 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void) tick
{
    if (!self.audioPlayer)
    {
        _slider.value = 0;
        
        //        label.text = @"";
        //        statusLabel.text = @"";ss
        
        return;
    }
    
    if (self.audioPlayer.currentlyPlayingQueueItemId == nil)
    {
        _slider.value = 0;
        _slider.minimumValue = 0;
        _slider.maximumValue = 0;
        
        //        label.text = @"";
        
        return;
    }
    
    if (self.audioPlayer.duration != 0)
    {
        _slider.minimumValue = 0;
        _slider.maximumValue = self.audioPlayer.duration;
        _slider.value = self.audioPlayer.progress;
        _rightTimeLabel.text = [self formatTimeFromSeconds:_audioPlayer.duration];
        _leftTimeLabel.text = [self formatTimeFromSeconds:_audioPlayer.progress];
    }
    else
    {
        _slider.value = 0;
        _slider.minimumValue = 0;
        _slider.maximumValue = 0;
    }
    
}

-(void)sliderChange
{
    if (!self.audioPlayer)
    {
        return;
    }
    
    NSLog(@"Slider Changed: %f", _slider.value);
    
    [self.audioPlayer seekToTime:_slider.value];
}

-(void)animationOfImage
{
    CABasicAnimation* rotationAnimation;
    if(![_headImage.layer animationForKey:@"rotationAnimation"])
    {
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 10;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = CGFLOAT_MAX;
        [_headImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    
    
    CFTimeInterval pausedTime = [_headImage.layer timeOffset];
    _headImage.layer.speed = 1.0;
    _headImage.layer.timeOffset = 0.0;
    _headImage.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [_headImage.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    _headImage.layer.beginTime = timeSincePause;
}


-(void)playTempMusic:(SongEntity *)songEntity;
{
    _startTime =[NSDate date];
    if(self.tempSongUrl && ([self.tempSongUrl isEqualToString:songEntity.songUrl]) &&(self.audioPlayer.state == STKAudioPlayerStatePaused))
    {
        [self.audioPlayer resume];
        return;
    }
    if([[TWRDownloadManager sharedManager] fileExistsForUrl:songEntity.songUrl])
    {
        NSString *filePath = [[TWRDownloadManager sharedManager] localPathForFile:songEntity.songUrl];
        NSURL* url = [NSURL fileURLWithPath:filePath];
        
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        [self.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
    }else
    {
        NSURL* url = [NSURL URLWithString:songEntity.songUrl];
        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
        [self.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
    }
    self.tempSongUrl = songEntity.songUrl;
    self.changedSong += 1;
//    NSLog(@"self.changedSong ===%ld, song url :%@",(long)self.changedSong,songEntity.songUrl);
    _tempPlaying = YES;
    
}
-(void)stopPlayingMusic;
{
    if(self.isPlaying || _tempPlaying)
    {
        _endTime = [NSDate date];
        [[LocalService sharedInstance] addListenTime:[_endTime secondsAfterDate:_startTime]];
    }
    
    self.isPlaying = NO;
    [self.audioPlayer stop];
    
    _slider.minimumValue = 0;
    _slider.maximumValue = 0;//self.audioPlayer.duration;
    _slider.value = 0;//self.audioPlayer.progress;
    _rightTimeLabel.text = 0;//[self formatTimeFromSeconds:_audioPlayer.duration];
    _leftTimeLabel.text = 0;//[self formatTimeFromSeconds:_audioPlayer.progress];
    
    _tempPlaying = NO;
    _fakePlaying = NO;
    [self runbackNoVoice];
}

//-(NSString *)getCurrentPlayedMusic;
//{
//    if()
//    return expression
//}

-(void)pausePlayingMusic;
{
    self.isPlaying = NO;
    [self.audioPlayer pause];
    _endTime = [NSDate date];
    [[LocalService sharedInstance] addListenTime:[_endTime secondsAfterDate:_startTime]];
    _tempPlaying = NO;
//    _startTime = _endTime;
}

-(void)closeFireMusic
{
    [self stopPlayingMusic];
    
    [_runOutTimer invalidate];
    _runOutTimer = nil;
    
//    [self runbackground];
    
    NSDate *fireDate = [NSDate date];
    
    if([[LocalService sharedInstance] myEndUpSwitch])
    {
        UILocalNotification *localNot = [[UILocalNotification alloc]init];
        localNot.alertBody = @"播放完毕";
        localNot.soundName = @"default_bugu.caf";
        localNot.alertAction = @"清早闹钟";
        localNot.fireDate = fireDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
    }
}

-(void)playMusic
{
    if(self.songArray ==nil || self.songArray.count==0)
    {
        return;
    }
    if(!self.isPlaying)
    {
        self.isPlaying = YES;
        
        [self animationOfImage];
        _startTime = [NSDate date];
        
        if(self.listenedTime>0)
        {
            NSDate *nowDate = [NSDate date];
            NSDate *fireDate = [nowDate dateByAddingSeconds:[[LocalService sharedInstance] listeningTime]];
            
            _runOutTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(closeFireMusic) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:_runOutTimer forMode:NSRunLoopCommonModes];
        }
    }
    else
    {
        self.isPlaying = NO;
        CFTimeInterval pausedTime = [_headImage.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _headImage.layer.speed = 0.0;
        _headImage.layer.timeOffset = pausedTime;
        _endTime = [NSDate date];
        
        [[LocalService sharedInstance] addListenTime:[_endTime secondsAfterDate:_startTime]];
        
    }
    [self callMusicSeperator];
}

-(void)callMusicSeperator
{
    if(self.isPlaying)
    {
        //正在播放音频
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self playButtonPressed];
    }
    else
    {
        //stop音频播放// 暂停
        [self.playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
        [self pauseButtonPressed];
    }
}

-(void) pauseButtonPressed
{
    [self.audioPlayer pause];
    
}

-(void) playButtonPressed
{
    if (!self.audioPlayer)
    {
        return;
    }
    
    if (self.audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [self.audioPlayer resume];
        return;
    }
    
    [self playMyMusicAndChoose2Play];
    //    [self.audioPlayer play];
}

-(void)playMyMusicAndChoose2Play
{
//    [self.audioPlayer stop];
    NSInteger index = [self getSongIndex];
    MyGettingSongsDBEntity *entity = self.songArray[index];
    BOOL existSong =[[TWRDownloadManager sharedManager] fileExistsForUrl:entity.songUrl];
    if(existSong)
    {
        [self audioPlayerViewPlayFromLocalFileSelected];
    }
    else
    {
        [self audioPlayerViewPlayFromHTTPSelected];
    }
}

-(void)prevMusicPlay
{
    if(self.songArray ==nil || self.songArray.count==0)
    {
        return;
    }
    NSInteger index = [self getSongIndex];
    if(index == 0)
    {
        index = self.songArray.count-1;
    }
    else
    {
        index -=1;
        if(self.songArray.count==1)
        {
            index = 0;
        }
    }
    MyGettingSongsDBEntity *entity = self.songArray[index];
    [[LocalService sharedInstance] setListenedSongUrl:entity.songUrl];
    [self.songNameLabel setText:entity.songName];
    [self playMyMusicAndChoose2Play];
}

-(void)nextMusicPlay
{
    if(self.songArray ==nil || self.songArray.count==0)
    {
        return;
    }
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"nextSong" object:nil];
    NSInteger index = [self getSongIndex];
    
    if(index >= self.songArray.count)
    {
        index = 0;
    }
    else
    {
        index +=1;
        if(self.songArray.count == 1)
        {
            index = 0;
        }
        if(index ==  self.songArray.count)
        {
            index = 0;
        }
    }
    MyGettingSongsDBEntity *entity = self.songArray[index];
    [[LocalService sharedInstance] setListenedSongUrl:entity.songUrl];
    [self.songNameLabel setText:entity.songName];
    [self playMyMusicAndChoose2Play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60);
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:animated];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.0];
    self.view.frame = CGRectMake(32, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
//    
//    if(isPlaying)
//    {
//        CABasicAnimation* rotationAnimation =(CABasicAnimation*) [_headImage.layer animationForKey:@"rotationAnimation"];
//        
////        if(![_headImage.layer animationForKey:@"rotationAnimation"])
////        {
//            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//            rotationAnimation.duration = 10;
//            rotationAnimation.cumulative = YES;
//            rotationAnimation.repeatCount = CGFLOAT_MAX;
////            [_headImage.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
////        }
//        
////        
//        CFTimeInterval pausedTime = [_headImage.layer timeOffset];
//        _headImage.layer.speed = 1.0;
//        _headImage.layer.timeOffset = 0.0;
//        _headImage.layer.beginTime = 0.0;
//        CFTimeInterval timeSincePause = [_headImage.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//        _headImage.layer.beginTime = timeSincePause;
//    }
}

-(void) updateControls
{
    if (self.audioPlayer == nil)
    {
        //[playButton setTitle:@"" forState:UIControlStateNormal];
        
    }
    else if (self.audioPlayer.state == STKAudioPlayerStatePaused)
    {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        //        [playButton setTitle:@"Resume" forState:UIControlStateNormal];
    }
    else if (self.audioPlayer.state & STKAudioPlayerStatePlaying)
    {
        [self.playButton setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    }
    else
    {
        [self.playButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    
    [self tick];
}

//代理
-(void) audioPlayer:(STKAudioPlayer*)audioPlayer stateChanged:(STKAudioPlayerState)state previousState:(STKAudioPlayerState)previousState
{
    if(_fakePlaying || _tempPlaying)
    {
        return;
    }
    if(state == STKAudioPlayerStateError)
    {
        NSLog(@"====");
    }
    [self updateControls];
}



-(void) audioPlayer:(STKAudioPlayer*)audioPlayer unexpectedError:(STKAudioPlayerErrorCode)errorCode
{
    if(_fakePlaying || _tempPlaying)
    {
        return;
    }
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didStartPlayingQueueItemId:(NSObject*)queueItemId
{
    if(_fakePlaying || _tempPlaying)
    {
        return;
    }
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    
    NSLog(@"Started: %@", [queueId.url description]);
    
    [self updateControls];
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishBufferingSourceWithQueueItemId:(NSObject*)queueItemId
{
    if(_fakePlaying)
    {
        SampleQueueId* queueId = (SampleQueueId*)queueItemId;
        [self.audioPlayer queueDataSource:[STKAudioPlayer dataSourceFromURL:queueId.url] withQueueItemId:[[SampleQueueId alloc] initWithUrl:queueId.url andCount:queueId.count + 1]];
        return;
    }
    if(_tempPlaying)
    {
        return;
    }
    [self updateControls];
    
    // This queues on the currently playing track to be buffered and played immediately after (gapless)
    
    if (1==1)
    {
//        SampleQueueId* queueId = (SampleQueueId*)queueItemId;
//        
//        NSLog(@"Requeuing: %@", [queueId.url description]);
//        
//        [self.audioPlayer queueDataSource:[STKAudioPlayer dataSourceFromURL:queueId.url] withQueueItemId:[[SampleQueueId alloc] initWithUrl:queueId.url andCount:queueId.count + 1]];
        [self nextMusicPlay];
    }
}

-(void) audioPlayer:(STKAudioPlayer*)audioPlayer didFinishPlayingQueueItemId:(NSObject*)queueItemId withReason:(STKAudioPlayerStopReason)stopReason andProgress:(double)progress andDuration:(double)duration
{
    if(_fakePlaying || _tempPlaying)
    {
        return;
    }
    [self updateControls];
    
    SampleQueueId* queueId = (SampleQueueId*)queueItemId;
    NSLog(@"Finished: %@,%u", [queueId.url description],stopReason);
    if(stopReason == STKAudioPlayerStopReasonNone)
    {
        NSLog(@"-----");
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextMusicPlay) name:@"nextSong" object:nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"nextSong" object:nil];
//        NSLog(@"ttttttt----<<<<>>>>>");
//        [self nextMusicPlay];
    }
}

-(void) audioPlayer:(STKAudioPlayer *)audioPlayer logInfo:(NSString *)line
{
    NSLog(@"%@", line);
}

-(void) audioPlayerViewPlayFromHTTPSelected
{
    NSInteger index = [self getSongIndex];
    MyGettingSongsDBEntity *entity = self.songArray[index];
    
    NSURL* url = [NSURL URLWithString:entity.songUrl];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
    
    
    [self.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

//-(void) audioPlayerViewPlayFromIcecastSelected
//{
//    NSURL* url = [NSURL URLWithString:@"http://shoutmedia.abc.net.au:10326"];
//
//    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
//
//    [self.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
//}
//
//-(void) audioPlayerViewQueueShortFileSelected
//{
//    NSString* path = [[NSBundle mainBundle] pathForResource:@"airplane" ofType:@"aac"];
//    NSURL* url = [NSURL fileURLWithPath:path];
//
//    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
//
//    [self.audioPlayer queueDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
//
//    [self.audioPlayer playDataSource:dataSource withQueueItemID:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
//}

-(void) audioPlayerViewPlayFromLocalFileSelected
{
    
    NSInteger index = [self getSongIndex];
    MyGettingSongsDBEntity *entity = self.songArray[index];
    //    NSString *filePath = [NSString stringWithFormat:@"%@/%@",[[LocalService sharedInstance] getDownloadDir],entity.songName];
    NSString *filePath = [[TWRDownloadManager sharedManager] localPathForFile:entity.songUrl];
    
    //    NSString* path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"m4a"];
    NSURL* url = [NSURL fileURLWithPath:filePath];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];

//    dataSource.delegate = self;
    [self.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

-(void) audioPlayerViewQueuePcmWaveFileSelected
{
    NSURL* url = [NSURL URLWithString:@"http://www.abstractpath.com/files/audiosamples/perfectly.wav"];
    
    STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
//    dataSource.delegate = self;
    [self.audioPlayer queueDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSInteger)getSongIndex
{
    NSString *songUrl= [[LocalService sharedInstance] listenedSongUrl];
    if(songUrl==nil)
    {
        return 0;
    }
    if(self.songArray==nil)
    {
        return 0;
    }
    int index = 0;
    for (int i=0; i<self.songArray.count; i++)
    {
        MyGettingSongsDBEntity *recordDBEntity = self.songArray[i];
        if([songUrl isEqualToString:recordDBEntity.songUrl])
        {
            index = i;
            break;
        }
    }
    
    return index;
}


- (IBAction)getIntoChannel:(id)sender
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ChooseMyChannelTableViewController"];
    
    [[SlideNavigationController sharedInstance] pushViewController:vc
                                                          animated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGetInToChannelView object:nil];
}
@end
