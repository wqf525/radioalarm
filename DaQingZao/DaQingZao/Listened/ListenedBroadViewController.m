//
//  ListenedBroadViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "ListenedBroadViewController.h"
#import "LocalService.h"
#import "LocalService+WebService.h"
#import "MyGettingSongsDBEntity.h"

@interface ListenedBroadViewController ()
@property (weak, nonatomic) IBOutlet UILabel *todayDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAndWeekLabel;
@property (weak, nonatomic) IBOutlet UILabel *myLocateCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *playingLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayingButton;

@end

@implementation ListenedBroadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.stopPlayingButton.layer setMasksToBounds:YES];
    [self.stopPlayingButton.layer setCornerRadius:5.0];
    if([[LocalService sharedInstance]myCityName])
    {
        self.myLocateCityLabel.text = [[LocalService sharedInstance]myCityName];
    }
    NSDate *nowDate = [NSDate date];
    self.todayDayLabel.text = [NSString stringWithFormat:@"%ld",(long)nowDate.day];
    self.monthAndWeekLabel.text = [NSString stringWithFormat:@"%ld月 %@",(long)nowDate.month,nowDate.weekdayDescription];
    
    UIImage* image = [UIImage imageNamed:@"listened_back_ground.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    [self.stopPlayingButton addTarget:self action:@selector(stopPlayingMusic) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = nil;
}
- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
}

-(void)stopPlayingMusic
{
    RightViewController *rightVC = (RightViewController *)[SlideNavigationController sharedInstance].rightMenu;
    [rightVC stopPlayingMusic];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[LocalService sharedInstance] getWeather:^(id retValue) {
        
        NSDictionary *retData = [(NSDictionary *)retValue objectForKey:@"retData"];
        NSDictionary *todayDic = [retData objectForKey:@"today"];
        NSLog(@"type:%@",[todayDic objectForKey:@"type"]);
        NSLog(@"tttt");
        self.weatherLabel.text = [NSString stringWithFormat:@"%@ %@~%@",[todayDic objectForKey:@"type"],[todayDic objectForKey:@"lowtemp"],[todayDic objectForKey:@"hightemp"]];
    } fail_block:^(NSError *error) {
        
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(nothing)];
    
    [[LocalService sharedInstance] addObserver:self forKeyPath:@"listenedSongCount" options:NSKeyValueObservingOptionNew context:nil];
    
    NSString *songUrl = [[LocalService sharedInstance] listenedSongUrl];
    if(!songUrl)
    {
        songUrl = [[LocalService sharedInstance] alarmedSongUrl];
    }
    if(songUrl)
    {
        NSPredicate *precicate = [NSPredicate predicateWithFormat:@"songUrl==%@",songUrl];
        MyGettingSongsDBEntity *entity = [MyGettingSongsDBEntity MR_findFirstWithPredicate:precicate];
        if(entity)
            self.playingLabel.text = [NSString stringWithFormat:@"正在播放 %@",entity.songName];
        else
        {
            NSArray *array =[MyGettingSongsDBEntity MR_findAll];
            self.playingLabel.text  = ((MyGettingSongsDBEntity *)(array[0])).songName;
        }
    }
}

-(void)nothing
{
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"listenedSongCount"])
    {
        NSString *songUrl = [[LocalService sharedInstance] listenedSongUrl];
        NSPredicate *precicate = [NSPredicate predicateWithFormat:@"songUrl==%@",songUrl];
        MyGettingSongsDBEntity *entity = [MyGettingSongsDBEntity MR_findFirstWithPredicate:precicate];
        if(entity)
            self.playingLabel.text = [NSString stringWithFormat:@"正在播放 %@",entity.songName];
        else
        {
            NSArray *array =[MyGettingSongsDBEntity MR_findAll];
            self.playingLabel.text  = ((MyGettingSongsDBEntity *)(array[0])).songName;
        }
    }
}

-(void)dealloc
{
    [[LocalService sharedInstance] removeObserver:self forKeyPath:@"listenedSongCount"];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
