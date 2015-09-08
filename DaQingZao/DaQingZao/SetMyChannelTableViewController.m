//
//  SetMyChannelTableViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/30.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "SetMyChannelTableViewController.h"
#import "LocalService.h"
#import "SettingMyChannelTimeTableViewController.h"

#define hourSectionArr @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"]
#define minuteSectionArr @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59"]

#define myWeekTimeArr @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"]

@interface SetMyChannelTableViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *_myHour;
    NSString *_myMinute;
    NSMutableDictionary *_myWeekSetting;
    NSTimer *_myTimer;
}
@property (weak,  nonatomic) IBOutlet   UISwitch        *mainSwitch;
@property (weak,  nonatomic) IBOutlet   UISwitch        *alarmSwitch;
@property (weak,  nonatomic) IBOutlet   UILabel         *getUpChannelLabel;
@property (weak,  nonatomic) IBOutlet   UILabel         *listenTotalTimeLabel;
@property (weak,  nonatomic) IBOutlet   UISwitch        *endUpSwitch;
@property (weak,  nonatomic) IBOutlet   UIButton        *stopMusic;
@property (strong,nonatomic)            UIPickerView    *myDatePicker;
@property (strong,nonatomic)            UIToolbar       *weekToolBar;
@property (strong,nonatomic)            UIToolbar       *myToolBar;
@property (weak,  nonatomic) IBOutlet   UILabel         *getUpTime;
@property (weak,  nonatomic) IBOutlet   UILabel         *circleDayTime;

- (IBAction)storeMyAlarmSetting:(UIBarButtonItem *)sender;
@end

@implementation SetMyChannelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_myHour ==nil)
    {
        _myHour = @"00";
    }
    if(_myMinute ==nil)
    {
        _myMinute= @"00";
    }
    NSDictionary *dic = [[LocalService sharedInstance]settingMyWeek];
    if(dic == nil || dic.count==0)
    {
        _myWeekSetting = [[NSMutableDictionary alloc] initWithDictionary:@{@"1":@"0",@"2":@"0",@"3":@"0",@"4":@"0",@"5":@"0",@"6":@"0",@"7":@"0"}];
    }else
    {
        _myWeekSetting = [[NSMutableDictionary alloc] initWithDictionary:dic];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    BOOL myAlarmSwitchFlag =[[LocalService sharedInstance] myAlarmStatus];
//    _alarmSwitch.enabled = NO;
    [[UISwitch appearance]setOnImage:[UIImage imageNamed:@"switch_on"]];
    [[UISwitch appearance]setOnImage:[UIImage imageNamed:@"switch_off"]];
    [_mainSwitch setOnImage:[UIImage imageNamed:@"switch_on"]];
    [_mainSwitch setOffImage:[UIImage imageNamed:@"switch_off"]];
    
    [_alarmSwitch setOn:myAlarmSwitchFlag];
    [_mainSwitch setOn:myAlarmSwitchFlag];
    
    NSString *strGetUpTime =  [[LocalService sharedInstance]getUpTime];
    if(!strGetUpTime || strGetUpTime.length==0)
    {
        self.getUpTime.text = @"xx:xx";
    }else
    {
        self.getUpTime.text = strGetUpTime;
    }
    
    [_mainSwitch addTarget:self action:@selector(openMyAlarm:) forControlEvents:UIControlEventValueChanged];
    NSMutableString *mutableDayString = [[NSMutableString alloc]init];
    for (int i=0; i<_myWeekSetting.count; i++)
    {
        NSString *str = _myWeekSetting[[NSString stringWithFormat:@"%d",i+1 ]];
        if(str && [str intValue]>0)
        {
            [mutableDayString appendString:[NSString stringWithFormat:@"%@,",myWeekTimeArr[i]]];
        }
    }
    self.circleDayTime.text = mutableDayString;
    
    [self.endUpSwitch addTarget:self action:@selector(changeMyEndUpSwitch:) forControlEvents:UIControlEventValueChanged];
    
    [self.endUpSwitch setOn:[[LocalService sharedInstance] myEndUpSwitch]];
}

-(void)changeMyEndUpSwitch:(UISwitch *)mySwitch
{
    [[LocalService sharedInstance] setMyEndUpSwitch:mySwitch.isOn];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return hourSectionArr.count;
    }
    else
    {
        return minuteSectionArr.count;
    }
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component ==0 )
    {
        return hourSectionArr[row];
    }
    else
    {
        return minuteSectionArr[row];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _myHour = [NSString stringWithFormat:@"%@",hourSectionArr[[pickerView selectedRowInComponent:0]]];
    _myMinute = [NSString stringWithFormat:@"%@",minuteSectionArr[[pickerView selectedRowInComponent:1]]];
    NSString *myGetUpTime  = [NSString stringWithFormat:@"%@:%@",_myHour,_myMinute];
    self.getUpTime.text = myGetUpTime;
    [[LocalService sharedInstance] setGetUpTime:myGetUpTime];
}

-(UIToolbar *)myToolBar
{
    if(_myToolBar == nil)
    {
        CGRect weekToolBarFrame = self.weekToolBar.frame;
        _myToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, weekToolBarFrame.origin.y-49, weekToolBarFrame.size.width, 49)];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 49)];
        [label setText:@"闹钟时间设置"];
        [label setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
        
        UIButton *rightButton = [[UIButton alloc]init];
        [rightButton setTitle:@"确定" forState:UIControlStateNormal];
        // 148 196 53
        [rightButton setTitleColor:[UIColor colorWithRed:148.0/255.0 green:196.0/255.0 blue:53.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        rightButton.frame= CGRectMake([UIScreen mainScreen].bounds.size.width-50-5, 0, 50, 49);
        [_myToolBar addSubview:label];
        [_myToolBar addSubview:rightButton];
        [rightButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, [UIScreen mainScreen].bounds.size.width, 1)];
        [lineView setBackgroundColor:[UIColor colorWithRed:212.0/255.0 green:212.0/255.0 blue:212.0/255.0 alpha:1.0]];
        [_myToolBar addSubview:lineView];
    }
    return _myToolBar;
}

-(void)removeView
{
    [self.myDatePicker removeFromSuperview];
    [self.weekToolBar removeFromSuperview];
    [self.myToolBar removeFromSuperview];
}

-(UIToolbar *)weekToolBar
{
    if(_weekToolBar == nil)
    {
        CGRect dataPickerFrame = self.myDatePicker.frame;
        _weekToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, dataPickerFrame.origin.y-49, dataPickerFrame.size.width, 49)];
        [_weekToolBar setBackgroundColor:[UIColor whiteColor]];
        float margin = 10;
        float topMargin =4;
        
        float buttonWidth =0;
        buttonWidth = (_weekToolBar.frame.size.width - 8*margin)/7;
        float buttonHeight = 49-topMargin-5 ;
        if(buttonWidth> buttonHeight)
        {
            buttonWidth = buttonHeight;
            //重做margin
            margin = (_weekToolBar.frame.size.width -7*buttonWidth)/8;
        }else
        {
            buttonHeight = buttonWidth;
        }
        //98 49
        NSMutableArray *arrays = [NSMutableArray array];
        for (int i=0; i<7; i++)
        {
            UIButton *dayButton = [[UIButton alloc]init];
            float y = topMargin;
            float width = buttonWidth;
            float height = buttonHeight;
            float x = (margin +buttonHeight)*i;
            [dayButton setFrame:CGRectMake(x, y, width, height)];
            
            NSString * str = [_myWeekSetting objectForKey:[NSString stringWithFormat:@"%d",i+1]];
            
            if(str && [str intValue]>0)
            {
                [dayButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_on",i+1]] forState:UIControlStateNormal];
            }else
            {
               [dayButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d_off",i+1]] forState:UIControlStateNormal];
            }
            dayButton.tag = i+1;
            [dayButton addTarget:self action:@selector(setMyDay:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *dayButtonItem = [[UIBarButtonItem alloc] initWithCustomView:dayButton];
            [arrays addObject:dayButtonItem];
        }
        [_weekToolBar setItems:arrays];
        
    }
    
    return _weekToolBar;
}

-(void)setMyDay:(UIButton *)button
{
    NSString * str = [_myWeekSetting objectForKey:[NSString stringWithFormat:@"%ld",(long)button.tag]];
    NSString * myKey = [NSString stringWithFormat:@"%ld",(long)button.tag];
    if(str && [str intValue]>0)
    {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_off",myKey]] forState:UIControlStateNormal];
        _myWeekSetting[myKey] = @"0";
    }else
    {
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_on",myKey]] forState:UIControlStateNormal];
        _myWeekSetting[myKey] = @"1";
    }
    [[LocalService sharedInstance] setSettingMyWeek:_myWeekSetting];
    
    NSMutableString *mutableDayString = [[NSMutableString alloc]init];
    for (int i=0; i<_myWeekSetting.count; i++)
    {
        NSString *str = _myWeekSetting[[NSString stringWithFormat:@"%d",i+1 ]];
        if(str && [str intValue]>0)
        {
            [mutableDayString appendString:[NSString stringWithFormat:@"%@,",myWeekTimeArr[i]]];
        }
    }
    self.circleDayTime.text = mutableDayString;
}


-(UIPickerView *)myDatePicker
{
    if(_myDatePicker==nil)
    {
        int totalHeight = self.navigationController.navigationBar.frame.size.height +[[UIApplication sharedApplication] statusBarFrame].size.height;
        _myDatePicker = [ [ UIPickerView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-270/2.0-totalHeight, [UIScreen mainScreen].bounds.size.width, 270/2.0)];
        _myDatePicker.backgroundColor = [UIColor blackColor];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _myDatePicker.frame.size.width, _myDatePicker.frame.size.height)];
        [imageView setImage:[UIImage imageNamed:@"timePickerBackGround"]];
        [_myDatePicker addSubview:imageView];
        _myDatePicker.showsSelectionIndicator = YES;
        _myDatePicker.dataSource = self;
        _myDatePicker.delegate = self;
    }
    
//#warning finished;
    
    NSString *strGetUpTime =  [[LocalService sharedInstance]getUpTime];
    NSInteger hour,minute;
    
    if(!strGetUpTime || strGetUpTime.length==0)
    {
        NSDate *nowDate = [NSDate date];
        hour = nowDate.hour;
        minute = nowDate.minute;
    }else
    {
        NSArray *strArray = [strGetUpTime componentsSeparatedByString:@":"];
        hour = [strArray[0] integerValue];
        minute = [strArray[1] integerValue];
    }
    [_myDatePicker selectRow:hour inComponent:0 animated:YES];
    [_myDatePicker selectRow:minute inComponent:1 animated:YES];
    
    [[LocalService sharedInstance] setGetUpTime:[NSString stringWithFormat:@"%@:%@",hourSectionArr[hour],minuteSectionArr[minute]]];
    
    return _myDatePicker;
}

-(void)openMyAlarm:(UISwitch *)mySwitch
{
    [_alarmSwitch setOn:mySwitch.isOn animated:YES];
    [[LocalService sharedInstance]setMyAlarmStatus:mySwitch.isOn];
}


-(UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if(component ==0)
    {
        myView =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = hourSectionArr[row];
        myView.font = [UIFont systemFontOfSize:30];
        myView.backgroundColor = [UIColor clearColor];
        myView.textColor = [UIColor whiteColor];
        
    }else
    {
        myView =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = minuteSectionArr[row];
        myView.font = [UIFont systemFontOfSize:30];
        myView.backgroundColor = [UIColor clearColor];
        myView.textColor = [UIColor whiteColor];
    }
    return myView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    CGFloat componentWidth = 0.0;
    
    if (component == 0)
        
        componentWidth = 100.0; // 第一个组键的宽度
    
    else
        
        componentWidth = 100.0; // 第2个组键的宽度
    
    return componentWidth;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    ///148,195,53
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:96.0/255.0 green:185.0/255.0 blue:101.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    //listen
    NSInteger timeInt = [[LocalService sharedInstance]listeningTime] ;
    if(timeInt ==0)
    {
        timeInt = [TIME_ARR[0]integerValue];
        [[LocalService sharedInstance] setListeningTime:timeInt];
    }
    timeInt = timeInt/60;
    if(timeInt<60)
    {
        _listenTotalTimeLabel.text = [NSString stringWithFormat:@"%ld分钟",(long)timeInt];
    }
    else
    {
        _listenTotalTimeLabel.text = @"1小时";
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        [self.tableView addSubview:self.myDatePicker];
        [self.tableView addSubview:self.weekToolBar];
        [self.tableView addSubview:self.myToolBar];
        
    }
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)storeMyAlarmSetting:(UIBarButtonItem *)sender
{
//    [[LocalService sharedInstance] setAlarmSettingFlag:_mainSwitch.isOn];
    //保存
    //清除所有的本地通知，第一步
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //判断，并且发送本地通知
    
    if(self.mainSwitch.isOn && ![self.getUpTime.text isEqualToString:@"xx:xx"])//可以发送本地通知
    {
        NSDictionary *dic = [[LocalService sharedInstance] settingMyWeek];
        
        NSString *clockTime = self.getUpTime.text;
        NSArray *clockTimeArray = [clockTime componentsSeparatedByString:@":"];
        NSDate *dateNow = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps= [[NSDateComponents alloc]init];
        
        NSInteger unitFlags = NSCalendarUnitEra |
        NSCalendarUnitYear  |
        NSCalendarUnitMonth |
        NSCalendarUnitDay   |
        NSCalendarUnitHour  |
        NSCalendarUnitMinute|
        NSCalendarUnitSecond|
        NSCalendarUnitWeekday|
        NSCalendarUnitWeekdayOrdinal|
        NSCalendarUnitQuarter|
        NSCalendarUnitWeekOfYear;
        
        comps = [calendar components:unitFlags fromDate:dateNow];
        [comps setHour:[[clockTimeArray objectAtIndex:0]intValue]];
        [comps setMinute:[[clockTimeArray objectAtIndex:1]intValue]];
        [comps setSecond:0];
        
        Byte i=0,j=-1;
        Byte clockDays[7];
        Byte weekday = [comps weekday];
        //设定周期模式
        for (id dicKey in dic)
        {
            NSInteger hasOpend = [[dic objectForKey:dicKey] integerValue];
            if(hasOpend>0)
            {
                clockDays[j] = i+1;
                j++;
            }
            i++;
        }
        int days=0,temp =0;
        if(j>=0)
        {
            for (i=0; i<(j+1); i++)
            {
                temp = clockDays[i] - weekday;
                days = (temp >= 0 ? temp : temp + 7);
                NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
                UILocalNotification *localNot = [[UILocalNotification alloc]init];
                localNot.alertBody = @"清晨起床感觉好";
                localNot.soundName = @"default_bugu.caf";
                
                localNot.alertAction = @"清早闹钟";
                localNot.repeatInterval = NSCalendarUnitWeekOfYear;
                
                localNot.fireDate = newFireDate;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
            }
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm:ss"];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components = [calendar components:(NSCalendarUnitYear  |
                                                                 NSCalendarUnitMonth |
                                                                 NSCalendarUnitDay   |
                                                                 NSCalendarUnitHour  |
                                                                 NSCalendarUnitMinute|
                                                                 NSCalendarUnitSecond) fromDate:[NSDate date]];
            NSDate *fireDate = [calendar dateFromComponents:components];
            
            UILocalNotification *localNot = [[UILocalNotification alloc]init];
            localNot.alertBody = @"清晨起床感觉好";
            localNot.soundName = @"default_bugu.caf";
            localNot.alertAction = @"清早闹钟";
            localNot.fireDate = fireDate;
            
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNot];
        }
        [[LocalService sharedInstance] setTimer2Weak];
//        [self setMyTimer];
    }
    NSLog(@"============1");
    [self.navigationController popViewControllerAnimated:YES];NSLog(@"============2");
}
@end

