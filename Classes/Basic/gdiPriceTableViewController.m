//
//  gdiPriceTableViewController.m
//  GDiPhone
//
//  Created by YuDa on 14-10-18.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiPriceTableViewController.h"

#import "gdiListViewController.h"

@interface gdiPriceTableViewController ()

@end



@implementation gdiPriceTableViewController
static NSString *identifier = @"cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.prices = @[@"所有", @"0~200", @"200~500", @"500~1000", @"1000~2000", @"2000~5000", @"5000~10000", @"10000~20000", @"2万以上"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.title = @"价格";
}

- (void)timerFire:(NSTimer *)timer
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.prices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.prices objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:self.currentPrice])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.uddelegate changePrice:[self.prices objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}
@end
