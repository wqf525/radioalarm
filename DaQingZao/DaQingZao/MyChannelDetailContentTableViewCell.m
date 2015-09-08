//
//  MyChannelDetailContentTableViewCell.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/4/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "MyChannelDetailContentTableViewCell.h"
#import "DownLoadTask.h"
#import "UIView+Common.h"
#import "MyGettingSongsDBEntity.h"
#import "MySongDownloadRecordsDBEntity.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "RightViewController.h"
#import "UIView+Common.h"

@interface MyChannelDetailContentTableViewCell()
{
    DownLoadTask *newTask;
    BOOL _isPlaying;
    RightViewController *_rVC;
}
@end
@implementation MyChannelDetailContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.channelTitle.text = self.songEntity.songName;
    [self.downloadChannelButton addTarget:self action:@selector(downThisSong) forControlEvents:UIControlEventTouchUpInside];
    [self.chooseChannelButton addTarget:self action:@selector(setMyALarmSong) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton addTarget:self action:@selector(play4Music) forControlEvents:UIControlEventTouchUpInside];
    
    _rVC = (RightViewController *)[SlideNavigationController sharedInstance].rightMenu;
    [_rVC addObserver:self forKeyPath:@"changedSong" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString: @"changedSong"])
    {
        if([_rVC.tempSongUrl isEqualToString:self.songEntity.songUrl])
        {
            
        }else
        {
            [self.playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
        }
    }
}

-(void)play4Music
{
    if(!_rVC)
    {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _rVC = (RightViewController *)(((SlideNavigationController*)appDelegate.navVC).rightMenu);
    }
    
    if(_isPlaying)
    {
        _isPlaying = NO;
        [_rVC pausePlayingMusic];
        [self.playButton setImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    }else
    {
        _isPlaying = YES;
        [_rVC playTempMusic:self.songEntity];
        [self.playButton setImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
        
    }
}

-(void)setSongEntity:(SongEntity *)songEntity
{
    if(songEntity==nil)
    {
        return;
    }
    _songEntity = songEntity;
    NSString *alarmUrl = [[LocalService sharedInstance] alarmedSongUrl];
    if(alarmUrl)
    {
        if([self.songEntity.songUrl isEqualToString:alarmUrl])
        {
            [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateNormal];
        }
        else
        {
            [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
    }
//    if(![self ifSelectedAsNotice])
//    {
//        [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
//    }else
//    {
//        [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateNormal];
//    }
    
    EdownloadedStatus downLoadStatus = [self getDownloadedStatus];
    if(downLoadStatus == downloaded)
    {
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"ic_downloaded"] forState:UIControlStateNormal];
        self.downloadProgress.progress = 1.0;
    }
    else if(downLoadStatus == downloading)
    {
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"ic_downloading"] forState:UIControlStateNormal];
        [self downLoadExistsFile];
//        [self downLoadFile];
        
    }else
    {
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
    }
    
}

-(void)downLoadExistsFile
{
    [[TWRDownloadManager sharedManager] isFileDownloadingForUrl:self.songEntity.songUrl withProgressBlock:^(CGFloat progress) {
        self.downloadProgress.progress = progress;
    } completionBlock:^(BOOL completed) {
        if(!completed)
            assert(nil);
        self.downloadProgress.progress = 1.0;
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"ic_downloaded"] forState:UIControlStateNormal];
    }];
}

-(void)downLoadFile
{
    [[TWRDownloadManager sharedManager] downloadFileForURL:self.songEntity.songUrl progressBlock:^(CGFloat progress) {
        self.downloadProgress.progress = progress;
    } completionBlock:^(BOOL completed) {
        if(!completed)
            assert(nil);
        self.downloadProgress.progress = 1.0;
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"ic_downloaded"] forState:UIControlStateNormal];
    } enableBackgroundMode:YES];
    
}

-(void)saveListOfSong
{
    NSArray *songEntities = [MyGettingSongsDBEntity MR_findAll];
    for (int i=0; i<songEntities.count; i++)
    {
        MyGettingSongsDBEntity *entity = songEntities[i];
        [entity MR_deleteEntity];
    }
    
    MyGettingSongsDBEntity *entity = [MyGettingSongsDBEntity MR_createEntity];
    entity.sceneIndex = [NSNumber numberWithInteger:self.sceneIndex];
    entity.songName = self.songEntity.songName;
    entity.songUrl = self.songEntity.songUrl;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)setMyALarmSong
{
//    BOOL isSelected = [self ifSelectedAsNotice];
    [[LocalService sharedInstance] setAlarmedSongUrl:self.songEntity.songUrl];
    
    [self saveListOfSong];
    
    [self.myViewController.navigationController popToRootViewControllerAnimated:YES];
    
    
//    if(alarmUrl)
//    {
//        [self deleteThisNotice];
//        [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
//        
//    }
//    else
//    {
//        [self saveThisNotice];
//        [self.chooseChannelButton setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateNormal];
//    }
}

-(EdownloadedStatus) getDownloadedStatus
{
    BOOL isExsits = [[TWRDownloadManager sharedManager] fileExistsForUrl:self.songEntity.songUrl];
    NSPredicate *precicate = [NSPredicate predicateWithFormat:@"sceneId==%@ AND songUrl==%@" argumentArray:@[[NSNumber numberWithInteger:self.sceneIndex],self.songEntity.songUrl]];
    MySongDownloadRecordsDBEntity *songDownloadEntity = [MySongDownloadRecordsDBEntity MR_findFirstWithPredicate:precicate];
    if(songDownloadEntity)
    {
        if(isExsits)
        {
            return downloaded;
        }
        return downloading;
    }
    return unload;
}

-(void)saveStoreSong
{
    MySongDownloadRecordsDBEntity *entity = [MySongDownloadRecordsDBEntity MR_createEntity];
    entity.sceneId = [NSNumber numberWithInteger:self.sceneIndex];
    entity.songName = self.songEntity.songName;
    entity.songUrl = self.songEntity.songUrl;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

-(void)deleteSotreSong
{
    NSPredicate *precicate = [NSPredicate predicateWithFormat:@"sceneId==%@ AND songUrl==%@" argumentArray:@[[NSNumber numberWithInteger:self.sceneIndex],self.songEntity.songUrl]];
    [MySongDownloadRecordsDBEntity MR_deleteAllMatchingPredicate:precicate];
    self.downloadProgress.progress = 0.0f;
}

-(void)downThisSong
{
    EdownloadedStatus downLoadStatus = [self getDownloadedStatus];
    if(downLoadStatus == downloaded)
    {
        [self deleteSotreSong];
        [[TWRDownloadManager sharedManager] deleteFileForUrl:self.songEntity.songUrl];
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
        
    }
    else if(downLoadStatus == downloading)
    {
        [[TWRDownloadManager sharedManager]cancelDownloadForUrl:self.songEntity.songUrl];
        [self deleteSotreSong];
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"btn_download"] forState:UIControlStateNormal];
        
    }else
    {
        [self saveStoreSong];
        [self downLoadFile];
        [self.downloadChannelButton setImage:[UIImage imageNamed:@"ic_downloading"] forState:UIControlStateNormal];
    }
}

-(void)dealloc
{
    [_rVC stopPlayingMusic];
    [_rVC removeObserver:self forKeyPath:@"changedSong"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
