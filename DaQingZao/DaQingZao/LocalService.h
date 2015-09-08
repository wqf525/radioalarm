//
//  LocalService.h
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/23.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SongEntity.h"
#import <MapKit/MapKit.h>


@interface LocalService : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLLocation *_checkinLocation;
    CLGeocoder *_geocoder;
}
AS_SINGLETON(LocalService)

-(void)getMyLocation;

@property (nonatomic,strong) NSString *getUpTime;
@property (nonatomic,assign) NSInteger totalListenTime;
-(void)addListenTime:(float)tInteval;
@property (nonatomic,strong) NSString *myGetUpChannel;

@property (nonatomic,strong) NSString *listenedSongUrl;

@property (nonatomic, assign) NSInteger listenedSongCount;

@property (nonatomic,strong) NSString *alarmedSongUrl;

//@property (nonatomic,assign) BOOL alarmSettingFlag;
//setListeningTime
@property (nonatomic,assign) NSInteger listeningTime;
@property (nonatomic,assign) BOOL myAlarmStatus;

@property (nonatomic,strong) NSDictionary *settingMyWeek;

@property (nonatomic,assign) BOOL myEndUpSwitch;

@property (nonatomic, strong) NSString *myCityName;

-(void)setTimer2Weak;

//-(void)playNoSoundVoice;
-(void)stopPlayVoice;

-(NSString *)getDownloadDir;

-(NSArray *)getMyAlarmSongs;
-(void)addMyAlarmSong:(SongEntity *)mySong;



@end
