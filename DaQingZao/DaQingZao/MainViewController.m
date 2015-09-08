//
//  MainViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/15.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "MainViewController.h"
#import "LocalService.h"
#import "NSDate+Category.h"
#import "ChooseMyChannelTableViewController.h"

//#define kNotificationGetInToChannelView @"kNotificationGetInToChannelView"
@interface MainViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *setAlarmButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *getupTime;
@property (weak, nonatomic) IBOutlet UILabel *timeToGetUpTime;
@property (weak, nonatomic) IBOutlet UILabel *totalListenTime;
@property (weak, nonatomic) IBOutlet UILabel *myRadioChannel;
@property (weak, nonatomic) IBOutlet UIButton *addCircleButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.
    // Do any additional setup after loading the view.
    [self.setAlarmButton.layer setMasksToBounds:YES];
    [self.setAlarmButton.layer setCornerRadius:5.0];
    
    [self.contentView.layer setMasksToBounds:YES];
    [self.contentView.layer setCornerRadius:5.0];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]]];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openMyChannel) name:kNotificationGetInToChannelView object:nil];
    
    NSString *titleStr = @"title";
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:titleStr]];
    imageView.contentMode= UIViewContentModeScaleAspectFit;
    [imageView setFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-30)/2, -10, 30, 100)];
    [self.view addSubview:imageView];
//    [self.navigationController.navigationBar addSubview:imageView];
    [[LocalService sharedInstance] setTimer2Weak];
    if([[LocalService sharedInstance] myCityName])
    {
        [[LocalService sharedInstance] getMyLocation];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runbackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runforeground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)runbackground
{
    RightViewController *rvc= (RightViewController *)[SlideNavigationController sharedInstance].rightMenu;
    [rvc runbackground];
}

-(void)runforeground
{
    RightViewController *rvc= (RightViewController *)[SlideNavigationController sharedInstance].rightMenu;
    [rvc runforeground];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
//ListenedBroadViewController

-(void)openMyChannel
{
    
//    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ListenedBroadViewController"];
////    [self presentViewController:vc animated:YES completion:nil];
//    
//    [self.navigationController pushViewController:vc animated:YES];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * vc = [sb instantiateViewControllerWithIdentifier:@"ChooseMyChannelTableViewController"];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *image = [self imageWithColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:YES];
    
    NSString *strGetUpTime =  [[LocalService sharedInstance]getUpTime];
    if(!strGetUpTime || strGetUpTime.length==0)
    {
        self.getupTime.text = @"xx:xx";
        self.timeToGetUpTime.text = @"可以设定您的起床时间";
    }
    else
    {
        self.getupTime.text = [[LocalService sharedInstance]getUpTime];
        int hour = 0;
        int minute = 0;
        NSArray *getupTimerArr = [strGetUpTime componentsSeparatedByString:@":"];
        
        hour = [getupTimerArr[0] intValue];
        minute = [getupTimerArr[1] intValue];
        
        NSDate * nowDate=[NSDate date];
        int thisHour = (int)nowDate.hour;
        int thisMinute = (int)nowDate.minute;
        //18:12,19:24
        //当前时间-设定时间
        //11:00 10:00;23
        if(thisHour>hour)
        {
            hour = 24-thisHour +hour;
        }
        else
        {
            //23:00 12:00;11
            hour = hour-thisHour;
        }
        //11:40;
        //12:50;
        if(thisMinute>minute)
        {
            hour -= 1;
            minute =60- (thisMinute- minute);
            if(hour<0)
            {
                hour = 23;
            }
        }
        else if(thisMinute==minute)
        {
            minute = 0;
        }
        else
        {
            minute = minute - thisMinute;
        }
        //距离起床 12小时32分
        self.timeToGetUpTime.text = [NSString stringWithFormat:@"距离起床 %02d小时%02d分",hour,minute];
    }
    //已经累计收听10000小时
    
    if([[LocalService sharedInstance] totalListenTime]<D_MINUTE)
    {
        self.totalListenTime.text = @"您刚才打开，还没统计您的时间呢";
    }else if([[LocalService sharedInstance] totalListenTime]<D_HOUR)
    {
      self.totalListenTime.text = [NSString stringWithFormat:@"已经累计收听%ld分钟",(long)[[LocalService sharedInstance] totalListenTime]/D_MINUTE];
    }
    else
    {
       self.totalListenTime.text = [NSString stringWithFormat:@"已经累计收听%ld小时",(long)[[LocalService sharedInstance] totalListenTime]/D_MINUTE];
    }
    
    //myRadioChannel
    NSString *radioChannel = [[LocalService sharedInstance]myGetUpChannel];
    if(!radioChannel)
    {
        radioChannel = @"请设置您的收听电台";
    }
    self.myRadioChannel.text = radioChannel;
    
    if(![[LocalService sharedInstance] myCityName])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"再您设定闹钟以后，我们会获取您的地址信息，为您提供当地的天气情况，请一定要打开GPS哦。"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else
    {
        [[LocalService sharedInstance] getMyLocation];
    }
    
    
    RightViewController *rvc = (RightViewController *)[SlideNavigationController sharedInstance].rightMenu;
    [rvc setText];
    
    
    if(![[LocalService sharedInstance] getUpTime])
    {
        self.contentView.hidden = YES;
        self.addCircleButton.hidden = NO;
    }else
    {
        self.contentView.hidden = NO;
        self.addCircleButton.hidden = YES;
    }
}

-(void)setMyAlarm
{
    
}


//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [[LocalService sharedInstance] getMyLocation];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu
{
    return YES;
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
