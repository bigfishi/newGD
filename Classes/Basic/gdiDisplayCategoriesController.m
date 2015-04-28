//
//  gdiDisplayCategoriesController.m
//  GDiPhone
//
//  Created by yuda on 15/3/23.
//  Copyright (c) 2015年 YuDa. All rights reserved.
//

#import "gdiDisplayCategoriesController.h"

@interface gdiDisplayCategoriesController ()
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSMutableArray *displayItems;
@property (nonatomic, strong) NSMutableArray *nodisplayItems;
@end

@implementation gdiDisplayCategoriesController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo"]];
    NSDictionary *productSetting = nil;
    NSArray *categoryBySetting = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        productSetting = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"setting.plist"]];
        categoryBySetting = [productSetting objectForKey:@"keyword"];
        self.items = categoryBySetting;
    }
    [self initDisplayItems];
    self.tableView.editing = YES;
}

- (void)initDisplayItems
{
    self.displayItems = [NSMutableArray arrayWithCapacity:5];
    for (int i=0; i<5; i++) {
        NSDictionary *dict = [self.items objectAtIndex:i];
        [self.displayItems addObject:dict];
    }
    self.nodisplayItems = [self.items mutableCopy];
    [self.nodisplayItems removeObjectsInArray:self.displayItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"显示项";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveChange];
}

- (void)saveChange
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo/setting.plist"]];
    NSDictionary *productSetting = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        productSetting = [NSDictionary dictionaryWithContentsOfFile:path];
//        categoryBySetting = [productSetting objectForKey:@"keyword"];
        NSMutableArray *items = [self.displayItems mutableCopy];
        [items addObjectsFromArray:self.nodisplayItems];
        NSMutableDictionary *dict = [productSetting mutableCopy];
        [dict setObject:items forKey:@"keyword"];
        BOOL b = [dict writeToFile:path atomically:YES];
        if (!b) {
            gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"修改失败，请重新修改!"];
            [tip showAndAutoRemove];
            return;
        }
        
        //self.categoryBySetting = [self.productSetting objectForKey:categoryString];
        gdiSingleton *instance = [gdiSingleton getInstance];
        instance.productSetting = dict;
        instance.categoryBySetting = [dict objectForKey:@"keyword"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    if (sourceIndexPath.section == destinationIndexPath.section)
    {
        if (sourceIndexPath.section == 0)
        {
            [self.displayItems exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        }
        else
        {
            [self.nodisplayItems exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        }
        return;
    }
    NSMutableArray *srcItems = self.displayItems;
    NSMutableArray *desItems = self.nodisplayItems;
    if (sourceIndexPath.section == 1)
    {
        srcItems = self.nodisplayItems;
    }
    if (destinationIndexPath.section == 0) {
        desItems = self.displayItems;
    }
    NSString *src = [srcItems objectAtIndex:sourceIndexPath.row];
    [srcItems removeObject:src];
    [desItems insertObject:src atIndex:destinationIndexPath.row];
    NSInteger count = [tableView numberOfRowsInSection:0];
    if (count < 5) {
        NSObject *first = [self.nodisplayItems objectAtIndex:0];
        [self.nodisplayItems removeObject:first];
        [self.displayItems addObject:first];
        // 出现白块，何解？
//        [tableView moveRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] toIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
        [tableView reloadData];
    } else if (count > 5) {
        NSObject *last = [self.displayItems lastObject];
        [self.displayItems removeObject:last];
        [self.nodisplayItems insertObject:last atIndex:0];
        // 出现白块，何解？
        //        [tableView moveRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1] toIndexPath:[NSIndexPath indexPathForItem:4 inSection:0]];
        [tableView reloadData];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)// 显示项
    {
        return @"显示项";
    }
    else // 不显示项
    {
        return @"隐藏项";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) // 显示项
    {
        return self.displayItems.count;
    }
    else
    {
        return self.nodisplayItems.count;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"displayItemIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //    cell.textLabel.text = self.cn[indexPath.row];
    if (indexPath.section == 0) // 显示项
    {
        cell.textLabel.text = [[self.displayItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    else
    {
        cell.textLabel.text = [[self.nodisplayItems objectAtIndex:indexPath.row] objectForKey:@"name"];
    }
    return cell;
}

@end
