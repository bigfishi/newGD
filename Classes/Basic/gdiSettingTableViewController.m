//
//  gdiSettingTableViewController.m
//  GDiPhone
//
//  Created by yuda on 14-12-12.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiSettingTableViewController.h"
#import "gdiListViewController.h"

@interface gdiSettingTableViewController ()

@end

@implementation gdiSettingTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView.
    self.navigationController.title = @"设置";
    self.title = @"设置";
    self.navigationItem.rightBarButtonItem = nil;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [self.switcher setOn:[ud boolForKey:@"backgroundDownload"] animated:NO];
    // 不起作用？
//    CGRect frame = self.view.frame;
//    frame.origin.y += 100;
//    self.view.frame = frame;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *identifier = @"settingCell";
//    NSString *trueIdentifier = [identifier stringByAppendingFormat:@"%d", (int)indexPath.row+1];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:trueIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:trueIdentifier];
//    }
//    return cell;
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"displayItem"])
    {
        NSLog(@"displayItem");
    }
    else if ([segue.identifier isEqualToString:@"contact"])
    {
        NSLog(@"contact");
    }
}

- (IBAction)changeBgDownload:(UISwitch *)sender
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (sender.isOn)
    {
        NSLog(@"开启后台下载");
        [ud setObject:@(YES) forKey:@"backgroundDownload"];
        [ud synchronize];
    }
    else
    {
        NSLog(@"关闭后台下载");
        [ud setObject:@(NO) forKey:@"backgroundDownload"];
        [ud synchronize];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self.switcher setOn:!self.switcher.isOn animated:YES];
    }
}
@end
