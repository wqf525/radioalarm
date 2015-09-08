//
//  ChooseMyChannelTableViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/31.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "ChooseMyChannelTableViewController.h"
#import "MyChannelViewController.h"
#import "ChooseMyChannelTableViewCell.h"

@interface ChooseMyChannelTableViewController ()

@end

@implementation ChooseMyChannelTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(closeMyOption)];
}

-(void)closeMyOption
{
    @try {
        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     长见识
     涨知识
     听新闻
     找感觉
     学英语
     找乐子
     *///
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyChannelViewController *conn = (MyChannelViewController *)[sb instantiateViewControllerWithIdentifier:@"MyChannelViewController"];
    conn.channelIndex = indexPath.row;
    if(indexPath.row == 0)
    {
        conn.title = @"长见识";
    }
    if(indexPath.row == 1)
    {
        conn.title = @"涨知识";
    }
    if(indexPath.row == 2)
    {
        conn.title = @"听新闻";
    }
    if(indexPath.row == 3)
    {
        conn.title = @"找感觉";
    }
    if(indexPath.row == 4)
    {
        conn.title = @"学英语";
    }
    if(indexPath.row == 5)
    {
        conn.title = @"找乐子";
    }
    [self.navigationController pushViewController:conn animated:YES];
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
}

-(void)pressOnIndexPathButton:(UIButton *)button
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyChannelViewController *conn = (MyChannelViewController *)[sb instantiateViewControllerWithIdentifier:@"MyChannelViewController"];
    conn.channelIndex = button.tag;
    if(button.tag == 0)
    {
        conn.title = @"长见识";
    }
    if(button.tag == 1)
    {
        conn.title = @"涨知识";
    }
    if(button.tag == 2)
    {
        conn.title = @"听新闻";
    }
    if(button.tag == 3)
    {
        conn.title = @"找感觉";
    }
    if(button.tag == 4)
    {
        conn.title = @"学英语";
    }
    if(button.tag == 5)
    {
        conn.title = @"找乐子";
    }
    [self.navigationController pushViewController:conn animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseMyChannelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChooseMyChannelTableViewCell" forIndexPath:indexPath];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ChooseMyChannelTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    if(indexPath.row==0)
    {
        cell.backgroundImage.image = [UIImage imageNamed:@"bg_scope.png"];
        [cell.nameCNLabel setTitle:@"长见识" forState:UIControlStateNormal];
        [cell.nameLabel setText:@"SCOPE"];
    }
    if(indexPath.row==1)
    {
        cell.backgroundImage.image = [UIImage imageNamed:@"bg_knowledge.png"];
        [cell.nameCNLabel setTitle:@"涨知识" forState:UIControlStateNormal];
        [cell.nameLabel setText:@"KONWLEDGE"];
    }
    if(indexPath.row==2)
    {
        cell.backgroundImage.image = [UIImage imageNamed:@"bg_news.png"];
        [cell.nameCNLabel setTitle:@"听新闻" forState:UIControlStateNormal];
        [cell.nameLabel setText:@"NEWS"];
    }
    if(indexPath.row==3)
    {
        cell.backgroundImage.image = [UIImage imageNamed:@"bg_feeling.png"];
        [cell.nameCNLabel setTitle:@"找感觉" forState:UIControlStateNormal];
        [cell.nameLabel setText:@"FEELING"];
    }
    if(indexPath.row==4)
    {
        cell.backgroundImage.image = [UIImage imageNamed:@"bg_english.png"];
        [cell.nameCNLabel setTitle:@"学英语" forState:UIControlStateNormal];
        [cell.nameLabel setText:@"ENGLISH"];
    }
    if(indexPath.row==5)
    {
        cell.backgroundImage.image = [UIImage imageNamed:@"bg_funny.png"];
        [cell.nameCNLabel setTitle:@"找乐子" forState:UIControlStateNormal];
        [cell.nameLabel setText:@"FUNNY"];
    }
    
    [cell.nameCNLabel setTag:indexPath.row];
    [cell.nameCNLabel addTarget:self action:@selector(pressOnIndexPathButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 133;
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
