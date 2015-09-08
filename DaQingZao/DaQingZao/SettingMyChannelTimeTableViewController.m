//
//  SettingMyChannelTimeTableViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/31.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "SettingMyChannelTimeTableViewController.h"
#import "LocalService.h"

@interface SettingMyChannelTimeTableViewController ()

@end

@implementation SettingMyChannelTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger time = [TIME_ARR[indexPath.row] integerValue];
    [[LocalService sharedInstance] setListeningTime:time];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return TIME_ARR.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TableSampleIdentifier = @"sampleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier];
        
        UIView *lineView1 = [[UIView alloc]init];
        [lineView1 setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [lineView1 setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        
        UIView *lineView2 = [[UIView alloc]init];
        [lineView2 setBackgroundColor:[UIColor colorWithRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0]];
        [lineView2 setFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 0.5)];
        [cell addSubview:lineView1];
        [cell addSubview:lineView2];
        
    }
    NSInteger locktimeDefault = [[LocalService sharedInstance]listeningTime];
    NSInteger timeInt = [TIME_ARR[indexPath.row] integerValue];
    if(locktimeDefault==0)
    {
        if(indexPath.row==0)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else
    {
        if(locktimeDefault==timeInt)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    //    label.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    
    timeInt = timeInt/60;
    if(timeInt<60)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld分钟",(long)timeInt];
    }
    else
    {
        cell.textLabel.text = @"1小时";
    }
    
    cell.textLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    return cell;
}

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

@end
