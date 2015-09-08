//
//  LocalService.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/23.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "LocalService.h"
#import "NSDate+Category.h"
#import "AppDelegate.h"
#import "SlideNavigationController.h"
#import "RightViewController.h"
#import "ListenedBroadViewController.h"

#define userGetUpTime           @"_getUpTime_"
#define userTotalListenTime     @"_totalListenTime_"
#define userGetUpChannel        @"_userGetUpChannel_"
#define userListeningTime       @"_userListeningTime_"
#define userMyAlarmStatus       @"_userMyAlarmStatus_"
#define userSettingMyWeek       @"_userSettingMyWeek_"
#define userMyEndUpSwitch       @"_userMyEndUpSwitch_"
#define userListenedSongUrl     @"_userListenedSongUrl_"
#define userGetCityName         @"_userGetCityName_"
#define userAlarmSongUrl        @"_userAlarmSongUrl_"

@interface LocalService()<AVAudioPlayerDelegate>
{
    NSTimer *_weakTimer;
}
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end
@implementation LocalService


DEF_SINGLETON(LocalService)

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self getDownloadDir];
    }
    return self;
}


-(void)setGetUpTime:(NSString *)getUpTime
{
    [[NSUserDefaults standardUserDefaults] setValue:getUpTime forKey:userGetUpTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)getUpTime
{
    NSString *strDate = [[NSUserDefaults standardUserDefaults] stringForKey:userGetUpTime];
    return strDate;
}

-(void) setTotalListenTime:(NSInteger)totalListenTime
{
    [[NSUserDefaults standardUserDefaults] setInteger:totalListenTime forKey:userTotalListenTime];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSInteger) totalListenTime
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:userTotalListenTime];
}

-(void)addListenTime:(float)tInteval;
{
    NSInteger totalTime = (NSInteger)tInteval +self.totalListenTime;
    [self setTotalListenTime:totalTime];
}

-(void)setMyGetUpChannel:(NSString *)myGetUpChannel
{
    [[NSUserDefaults standardUserDefaults] setObject:myGetUpChannel forKey:userGetUpChannel];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)myGetUpChannel
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:userGetUpChannel];
}

-(void)setMyCityName:(NSString *)myCityName
{
    [[NSUserDefaults standardUserDefaults] setObject:myCityName forKey:userGetCityName];
    [[NSUserDefaults standardUserDefaults]synchronize];

}

-(NSString*)myCityName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:userGetCityName];
}

-(void)setListenedSongUrl:(NSString *)listenedSongUrl
{
    self.listenedSongCount += 1;
    [[NSUserDefaults standardUserDefaults] setObject:listenedSongUrl forKey:userListenedSongUrl];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)listenedSongUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:userListenedSongUrl];
}

-(void)setAlarmedSongUrl:(NSString *)alarmedSongUrl
{
    [[NSUserDefaults standardUserDefaults] setObject:alarmedSongUrl forKey:userAlarmSongUrl];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)alarmedSongUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:userAlarmSongUrl];
}

//-(BOOL)alarmSettingFlag
//{
//    return [[NSUserDefaults standardUserDefaults]boolForKey:userAlarmSettingFlag];//userMyAlarmStatus
//}
//
//-(void)setAlarmSettingFlag:(BOOL)alarmSettingFlag
//{
//    [[NSUserDefaults standardUserDefaults]setBool:alarmSettingFlag forKey:userAlarmSettingFlag];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}

-(BOOL)myAlarmStatus
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:userMyAlarmStatus];//userMyAlarmStatus
}

-(void)setMyAlarmStatus:(BOOL)myAlarmStatus
{
    [[NSUserDefaults standardUserDefaults]setBool:myAlarmStatus forKey:userMyAlarmStatus];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)setListeningTime:(NSInteger)listeningTime
{
    [[NSUserDefaults standardUserDefaults]setInteger:listeningTime forKey:userListeningTime];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSInteger)listeningTime
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:userListeningTime];
}

-(NSDictionary *)settingMyWeek
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:userSettingMyWeek];
}

-(void)setSettingMyWeek:(NSDictionary *)settingMyWeek
{
    [[NSUserDefaults standardUserDefaults]setValue:settingMyWeek forKey:userSettingMyWeek];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(BOOL)myEndUpSwitch
{
    //userMyEndUpSwitch
    return [[NSUserDefaults standardUserDefaults]boolForKey:userMyEndUpSwitch];
}

-(void)setMyEndUpSwitch:(BOOL)myEndUpSwitch
{
    [[NSUserDefaults standardUserDefaults]setBool:myEndUpSwitch forKey:userMyEndUpSwitch];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(NSString *)getDownloadDir;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    
    return cachesDir;
}

-(void)playNoSoundVoice;
{
    dispatch_queue_t dispatchQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(dispatchQueue, ^(void) {
        NSError *audioSessionError = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession setCategory:AVAudioSessionCategoryPlayback error:&audioSessionError]){
            NSLog(@"Successfully set the audio session.");
        } else {
            NSLog(@"Could not set the audio session");
        }
        
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *filePath = [mainBundle pathForResource:@"sample" ofType:@"m4a"];
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        
        if (self.audioPlayer != nil){
            self.audioPlayer.delegate = self;
            
            [self.audioPlayer setNumberOfLoops:-1];
            
            BOOL prepareToPlay = [self.audioPlayer prepareToPlay];
            BOOL play = [self.audioPlayer play];
            if (prepareToPlay && play){
                NSLog(@"Successfully started playing...");
            } else {
                NSLog(@"Failed to play.");
            }
        } else {
            NSLog(@"Failed to alloc.");
        }
    });
}

-(void)stopPlayVoice
{
    [self.audioPlayer stop];
}

-(NSArray *)getMyAlarmSongs;
{
    NSMutableArray* array = [NSMutableArray array];
    SongEntity *entity1 = [SongEntity new];
    entity1.songName = @"歌曲1";
    entity1.songUrl = @"http://sc1.111ttt.com/2015/1/08/03/101031755369.mp3";
    SongEntity *entity2 = [SongEntity new];
    entity2.songName = @"歌曲2";
    entity2.songUrl = @"http://sc.111ttt.com/up/mp3/213442/176ED0A6C9B50D4F1E9089B50B55E783.mp3";
    SongEntity *entity3 = [SongEntity new];
    entity3.songName = @"歌曲3";
    entity3.songUrl = @"http://sc1.111ttt.com/2015/1/08/03/101030933587.mp3";
    
    [array addObject:entity1];
    [array addObject:entity2];
    [array addObject:entity3];
    
    return array;
    
}
-(void)addMyAlarmSong:(SongEntity *)mySong;
{
    if(mySong==nil)
    {
        return;
    }
    
}

-(void)setTimer2Weak;
{
    if(![self myAlarmStatus])
    {
        return;
    }
    if(_weakTimer)
    {
        [_weakTimer invalidate];
        _weakTimer = nil;
    }
    NSDate *dateNow = [NSDate date];
    NSString *clockTime = [[LocalService sharedInstance] getUpTime];
    //_myWeekSetting;
    NSInteger nowWeekDay = dateNow.weekday;//3 ==周二
    if(nowWeekDay == 0)
    {
        nowWeekDay = 7;
    }else
    {
        nowWeekDay -= 1;
    }
    
    NSInteger nowYear = dateNow.year;
    NSInteger nowMonth = dateNow.month;
    
    NSInteger nowDay = dateNow.day;
    NSInteger nowHour = dateNow.hour;
    NSInteger nowMinute = dateNow.minute;
    
    NSDate *fireDate;
    NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
    NSInteger fireHour = [clockTimeArray[0] integerValue];
    NSInteger fireMinute = [clockTimeArray[1] integerValue];
    
    NSDictionary *weekDays = self.settingMyWeek;
    
    NSInteger usingWeekDay = nowWeekDay;
    NSString *usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
//    BOOL stop = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //判断当天 设不设置
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //成立的情况
        if(nowHour<fireHour)
        {
            NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)nowYear,(long)nowMonth,(long)nowDay,(long)fireHour,(long)fireMinute];
            fireDate = [dateFormatter dateFromString:timerStr];
            _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
            
            [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
            return;
        }else if(nowHour == fireHour)
        {
            if(nowMinute < fireMinute)
            {
                NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)nowYear,(long)nowMonth,(long)nowDay,(long)fireHour,(long)fireMinute];
                fireDate = [dateFormatter dateFromString:timerStr];
                _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
                
                NSLog(@"=====ttttt------ssssss");
                [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
                NSLog(@"======ttt-------test");
                return;
            }
        }
    }
    //判断明天
    if(usingWeekDay==7)
    {
        usingWeekDay = 1;
        usingWeekStr = @"1";
    }
    else
    {
        usingWeekDay += 1;
        usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
    }
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //直接生成 timer
        fireDate = [dateNow dateByAddingDays:1];
        //成立的情况
        NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)fireDate.year,(long)fireDate.month,(long)fireDate.day,(long)fireHour,(long)fireMinute];
        fireDate = [dateFormatter dateFromString:timerStr];
        _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
        return;
    }
    
    //判断第三天
    if(usingWeekDay==7)
    {
        usingWeekDay = 1;
        usingWeekStr = @"1";
    }
    else
    {
        usingWeekDay += 1;
        usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
    }
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //直接生成 timer
        fireDate = [dateNow dateByAddingDays:2];
        //成立的情况
        NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)fireDate.year,(long)fireDate.month,(long)fireDate.day,(long)fireHour,(long)fireMinute];
        fireDate = [dateFormatter dateFromString:timerStr];
        _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
        return;
    }
    
    //判断第四天
    if(usingWeekDay==7)
    {
        usingWeekDay = 1;
        usingWeekStr = @"1";
    }
    else
    {
        usingWeekDay += 1;
        usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
    }
    
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //直接生成 timer
        fireDate = [dateNow dateByAddingDays:3];
        //成立的情况
        NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)fireDate.year,(long)fireDate.month,(long)fireDate.day,(long)fireHour,(long)fireMinute];
        fireDate = [dateFormatter dateFromString:timerStr];
        _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
        return;
    }
    //判断第五天
    if(usingWeekDay==7)
    {
        usingWeekDay = 1;
        usingWeekStr = @"1";
    }
    else
    {
        usingWeekDay += 1;
        usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
    }
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //直接生成 timer
        fireDate = [dateNow dateByAddingDays:4];
        //成立的情况
        NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)fireDate.year,(long)fireDate.month,(long)fireDate.day,(long)fireHour,(long)fireMinute];
        fireDate = [dateFormatter dateFromString:timerStr];
        _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
        return;
    }
    //判断第六天
    if(usingWeekDay==7)
    {
        usingWeekDay = 1;
        usingWeekStr = @"1";
    }
    else
    {
        usingWeekDay += 1;
        usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
    }
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //直接生成 timer
        fireDate = [dateNow dateByAddingDays:5];
        //成立的情况
        NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)fireDate.year,(long)fireDate.month,(long)fireDate.day,(long)fireHour,(long)fireMinute];
        fireDate = [dateFormatter dateFromString:timerStr];
        _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
        return;
    }
    //判断第六天
    if(usingWeekDay==7)
    {
        usingWeekDay = 1;
        usingWeekStr = @"1";
    }
    else
    {
        usingWeekDay += 1;
        usingWeekStr = [NSString stringWithFormat:@"%ld",(long)usingWeekDay];
    }
    if([weekDays objectForKey:usingWeekStr] && [[weekDays objectForKey:usingWeekStr] integerValue]==1)//判断7次，因为1周有7天
    {
        //直接生成 timer
        fireDate = [dateNow dateByAddingDays:6];
        //成立的情况
        NSString *timerStr = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld",(long)fireDate.year,(long)fireDate.month,(long)fireDate.day,(long)fireHour,(long)fireMinute];
        fireDate = [dateFormatter dateFromString:timerStr];
        _weakTimer = [[NSTimer alloc] initWithFireDate:fireDate interval:1.0f target:self selector:@selector(openNextFireDate) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_weakTimer forMode:NSRunLoopCommonModes];
        return;
    }
}


-(void)openNextFireDate
{
    [_weakTimer invalidate];
    _weakTimer = nil;
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    RightViewController *rVC = (RightViewController *)(((SlideNavigationController*)appDelegate.navVC).rightMenu);
    rVC.listenedTime = self.listeningTime;
    [rVC playMusic];
    UIViewController *vc =[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListenedBroadViewController"];
    [[SlideNavigationController sharedInstance] pushViewController:vc animated:NO];
    
    [self setTimer2Weak];
}

//-(void)setMyGetUpChannel:(NSString *)myGetUpChannel
//{
////    return [[NSUserDefaults standardUserDefaults]integerForKey:userTotalListenTime];
//}

-(void)getMyLocation;
{
    if([CLLocationManager locationServicesEnabled]){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 5;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;//kCLLocationAccuracyBest;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    [_locationManager startUpdatingLocation];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    _checkinLocation = [locations lastObject];
    NSLog(@"------");
    [_locationManager stopUpdatingLocation];
    
    if(_geocoder == nil)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }
    [_geocoder reverseGeocodeLocation:_checkinLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error)
        {
            NSLog(@"failed with error: %@", error);
            return;
        }
        if(placemarks.count > 0)
        {
            NSString *MyAddress = @"";
            NSString *city = @"";
            CLPlacemark *placemark = placemarks[0];
            if([placemark.addressDictionary objectForKey:@"FormattedAddressLines"] != NULL)
                MyAddress = [[placemark.addressDictionary objectForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
            else
                MyAddress = @"Address Not founded";
            
            if([placemark.addressDictionary objectForKey:@"SubAdministrativeArea"] != NULL)
                city = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
            else if([placemark.addressDictionary objectForKey:@"City"] != NULL)
                city = [placemark.addressDictionary objectForKey:@"City"];
            else if([placemark.addressDictionary objectForKey:@"Country"] != NULL)
                city = [placemark.addressDictionary objectForKey:@"Country"];
            else
                city = @"City Not founded";
            NSDictionary *dic = placemark.addressDictionary;
            
            NSLog(@"%@",dic);
            self.myCityName  = city;
        }
    }];
}


- (void)locationManager:(CLLocationManager *)manager

       didFailWithError:(NSError *)error

{
    
    NSLog(@"执行error");
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            
        }
        default:
            break;
    }
}

@end
