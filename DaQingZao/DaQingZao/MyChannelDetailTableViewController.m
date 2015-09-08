//
//  MyChannelDetailTableViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/4/7.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "MyChannelDetailTableViewController.h"
#import "MyChannelDetailHeadTableViewCell.h"
#import "MyChannelDetailContentTableViewCell.h"
#import "DownLoadTask.h"
#import "MyGettingSongsDBEntity.h"

@interface MyChannelDetailTableViewController ()

@end

@implementation MyChannelDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}
//
//#pragma mark - Table view data source
////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 161.0;
    }
    else
    {
        return 55.0;
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return YES;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section==0)
    {
        return 1;
    }
    return [[LocalService sharedInstance] getMyAlarmSongs].count;
}

//-(BOOL)ifSelectedAsNotice:(SongEntity *)entity;
//{
//    NSPredicate *precicate = [NSPredicate predicateWithFormat:@"sceneIndex==%@ AND songUrl==%@" argumentArray:@[[NSNumber numberWithInteger:self.sceneIndex],entity.songUrl]];
//    MyGettingSongsDBEntity *songStoredentity = [MyGettingSongsDBEntity MR_findFirstWithPredicate:precicate];
//    if(songStoredentity)
//    {
//        return YES;
//    }
//    return NO;
//}
//
//-(BOOL)ifSucceedDownLoad:(SongEntity *)entity;
//{
//    return NO;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0)
    {
        MyChannelDetailHeadTableViewCell *cell = (MyChannelDetailHeadTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyChannelDetailHeadTableViewCell"];
        return cell;
    }else
    {
        MyChannelDetailContentTableViewCell *cell = (MyChannelDetailContentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MyChannelDetailContentTableViewCell"];
        SongEntity *songEntity=[[[LocalService sharedInstance] getMyAlarmSongs] objectAtIndex:indexPath.row];
        cell.songEntity = songEntity;
        cell.sceneIndex = self.sceneIndex;
//        if([self ifSelectedAsNotice:songEntity])
//        {
//            [cell.chooseChannelButton setImage:[UIImage imageNamed:@"btn_selected"] forState:UIControlStateNormal];
//        }else
//        {
//            [cell.chooseChannelButton setImage:[UIImage imageNamed:@"btn_select"] forState:UIControlStateNormal];
//        }
//        cell.chooseChannelButton
//        cell.downloadChannelButton
        return cell;
    }
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
