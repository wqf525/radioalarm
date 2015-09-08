//
//  MyChannelViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/3/31.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "MyChannelViewController.h"
#import "MYChannelCollectionViewCell.h"
#import "MyChannelDetailTableViewController.h"

@interface MyChannelViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MyChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MYChannelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MYChannelCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYChannelCollectionViewCell *cell
    = (MYChannelCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"MYChannelCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor =[UIColor whiteColor];//[self colorWithRandom];
    cell.tag = 2;
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //{top, left, bottom, right}
    return UIEdgeInsetsMake(10, 5, 0, 5);
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = ([UIScreen mainScreen].bounds.size.width-15)/2;
    float height = width;
    return CGSizeMake(width, height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MyChannelDetailTableViewController *vc = (MyChannelDetailTableViewController *)[sb instantiateViewControllerWithIdentifier:@"MyChannelDetailTableViewController"];
    vc.sceneIndex = self.channelIndex;
    [self.navigationController pushViewController:vc animated:YES];
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
