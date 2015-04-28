//
//  gdiCategoryTableViewController.m
//  GDiPhone
//
//  Created by 夏震华 on 14-9-27.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiCategoryTableViewController.h"
#import "gdiListViewController.h"

@interface gdiCategoryTableViewController ()

@end


@implementation gdiCategoryTableViewController
static NSString *identifier = @"cell";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithKey:(NSString *)key
{
    self = [super init];
    if (self) {
        self.key = key;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    gdiSingleton *instance = [gdiSingleton getInstance];
    if ([self.key isEqualToString:kInfoCategory])
    {
        self.categories = [instance.categories mutableCopy];
    }
    else
    {
        self.categories = [instance.bands mutableCopy];
    }
    [self.categories insertObject:@"所有" atIndex:0];
//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.key isEqualToString:kInfoCategory])
    {
        self.navigationController.title = @"分类";
    }
    else
    {
        self.navigationController.title = @"品牌";
    }
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
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    if ([cell.textLabel.text isEqualToString:self.currentCategory])
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
    [self.uddelegate changeCategory:[self.categories objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
}


@end
