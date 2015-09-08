//
//  AboutUSViewController.m
//  DaQingZao
//
//  Created by 吴启飞 on 15/8/10.
//  Copyright (c) 2015年 吴启飞. All rights reserved.
//

#import "AboutUSViewController.h"
#import "AboutUSContentTableViewCell.h"
#import "AboutUSHeadTableViewCell.h"
#import "AboutUSTailTableViewCell.h"

@interface AboutUSViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AboutUSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 90;
    }else if (indexPath.row==1)
    {
        return 100;
    }else
    {
        return 127;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row==0)
    {
        AboutUSHeadTableViewCell *aboutUSHeadTableViewCell;
        aboutUSHeadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AboutUSHeadTableViewCell" forIndexPath:indexPath];
        if(!aboutUSHeadTableViewCell)
        {
            aboutUSHeadTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AboutUSHeadTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        return aboutUSHeadTableViewCell;
    }
    else if(indexPath.row==1)
    {
        AboutUSContentTableViewCell *aboutUSContentTableViewCell;
        aboutUSContentTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AboutUSContentTableViewCell" forIndexPath:indexPath];
        if(!aboutUSContentTableViewCell)
        {
            aboutUSContentTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AboutUSContentTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        return aboutUSContentTableViewCell;
    }
    else
    {
        AboutUSTailTableViewCell *aboutUSTailTableViewCell;
        aboutUSTailTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AboutUSTailTableViewCell" forIndexPath:indexPath];
        if(!aboutUSTailTableViewCell)
        {
            aboutUSTailTableViewCell = [[[NSBundle mainBundle] loadNibNamed:@"AboutUSTailTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        return aboutUSTailTableViewCell;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    UIImage *image = [self imageWithColor:[UIColor clearColor]];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.title = @"关于我们";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
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
