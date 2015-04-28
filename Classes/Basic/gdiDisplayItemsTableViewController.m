//
//  gdiDisplayItemsTableViewController.m
//  GDiPhone
//
//  Created by yuda on 14-12-12.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiDisplayItemsTableViewController.h"

@interface gdiDisplayItemsTableViewController ()
@property (strong, nonatomic) NSArray *itemsCn;
@property (strong, nonatomic) NSArray *itemsEn;
@property (strong, nonatomic) NSMutableArray *displayItemsCn;
@property (strong, nonatomic) NSMutableArray *displayItemsEn;
@property (strong, nonatomic) NSMutableArray *nodisplayItemsCn;
@property (strong, nonatomic) NSMutableArray *nodisplayItemsEn;
@end

@implementation gdiDisplayItemsTableViewController

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
    self.itemsCn = @[@"品牌",@"编号", @"特点",// @"描述", //描述改为特点
                     @"特征",@"名称",@"产地",
                     @"价格",@"推荐词",@"保修期"];
    self.itemsEn = @[kInfoBand,kInfoCode,kInfoFeature,
                     kInfoVersion,kInfoName,kInfoDependency,
                     kInfoPrice,kInfoRecomandWord,kInfoWarrantTime];
    [self initDisplayItems];
    self.tableView.editing = YES;
}

- (void)initDisplayItems
{
    self.displayItemsCn = [NSMutableArray arrayWithCapacity:5];
    self.displayItemsEn = [NSMutableArray arrayWithCapacity:5];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ProductInfo/setting.plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    dict = [dict objectForKey:@"displayItems"];
    if (dict)
    {
        NSString *cn = [dict objectForKey:@"cn"];
        NSArray *arr = [cn componentsSeparatedByString:@","];
        NSString *en = [dict objectForKey:@"en"];
        NSArray *arr2 = [en componentsSeparatedByString:@","];
        for (int i=0; i<arr.count; i++)
        {
            NSString *cnStr = arr[i];
            NSString *enStr = arr2[i];
            [self.displayItemsCn addObject:cnStr];
            [self.displayItemsEn addObject:enStr];
        }
    }
    else
    {
        self.displayItemsCn = [NSMutableArray arrayWithArray:@[@"名称", @"品牌", @"编号", @"价格", @"特点"]];
        self.displayItemsEn = [NSMutableArray arrayWithArray:@[kInfoName, kInfoBand, kInfoCode, kInfoPrice, kInfoFeature]];
    }
    self.nodisplayItemsCn = [self.itemsCn mutableCopy];
    [self.nodisplayItemsCn removeObjectsInArray:self.displayItemsCn];
    self.nodisplayItemsEn = [self.itemsEn mutableCopy];
    [self.nodisplayItemsEn removeObjectsInArray:self.displayItemsEn];
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
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ProductInfo/setting.plist"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSString *en = [self.displayItemsEn componentsJoinedByString:@","];
    NSString *cn = [self.displayItemsCn componentsJoinedByString:@","];
    NSDictionary *subDict = @{@"en": en, @"cn": cn};
    [dict setObject:subDict forKey:@"displayItems"];
    BOOL success = [dict writeToFile:path atomically:YES];
    if (!success)
    {
        gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"修改显示项失败，请重新修改!"];
        [tip showAndAutoRemove];
    }
    gdiSingleton *instance = [gdiSingleton getInstance];
    instance.displayItems = @[self.displayItemsEn, self.displayItemsCn];
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
            [self.displayItemsEn exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
            [self.displayItemsCn exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        }
        else
        {
            [self.nodisplayItemsEn exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
            [self.nodisplayItemsCn exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
        }
        return;
    }
    NSMutableArray *srcItemsEn = self.displayItemsEn;
    NSMutableArray *srcItemsCn = self.displayItemsCn;
    NSMutableArray *desItemsEn = self.nodisplayItemsEn;
    NSMutableArray *desItemsCn = self.nodisplayItemsCn;
    if (sourceIndexPath.section == 1)
    {
        srcItemsEn = self.nodisplayItemsEn;
        srcItemsCn = self.nodisplayItemsCn;
    }
    if (destinationIndexPath.section == 0) {
        desItemsEn = self.displayItemsEn;
        desItemsCn = self.displayItemsCn;
    }
    NSString *src = [srcItemsEn objectAtIndex:sourceIndexPath.row];
    [srcItemsEn removeObject:src];
    [desItemsEn insertObject:src atIndex:destinationIndexPath.row];
    
    src = [srcItemsCn objectAtIndex:sourceIndexPath.row];
    [srcItemsCn removeObject:src];
    [desItemsCn insertObject:src atIndex:destinationIndexPath.row];
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
        return self.displayItemsCn.count;
    }
    else
    {
        return self.nodisplayItemsCn.count;
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
        cell.textLabel.text = [self.displayItemsCn objectAtIndex:indexPath.row];
    }
    else
    {
        cell.textLabel.text = [self.nodisplayItemsCn objectAtIndex:indexPath.row];
    }
    return cell;
}

@end
