//
//  gdiInfoViewController.m
//  GDiPhone
//
//  Created by YuDa on 14-9-25.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiInfoViewController.h"
#import "gdiInfoTableViewCell.h"

@interface gdiInfoViewController ()
@property (strong, nonatomic) NSArray *cnTitles;
@end

static NSString *identifier = @"cell";
@implementation gdiInfoViewController

- (void)changeInfo:(NSDictionary *)info
{
    self.infoDict = info;
    [self lazyInit];
}

- (void)lazyInit
{
    gdiSingleton *instance = [gdiSingleton getInstance];
    if (instance.displayItems != nil)
    {
        self.titles = [instance.displayItems objectAtIndex:0];
        self.cnTitles = [instance.displayItems objectAtIndex:1];
    }
    else
    {
        self.titles = @[kInfoName, kInfoBand, kInfoCode, kInfoPrice, kInfoFeature];
        self.cnTitles = @[@"名称", @"品牌", @"编号", @"价格", @"特点"];
    }
    self.table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.baseScroll addSubview:self.table];
    // 分隔线样式
    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.table.separatorColor = [UIColor colorWithRed:52.0f/255.0f green:53.0f/255.0f blue:61.0f/255.0f alpha:1];
    self.table.separatorColor = [UIColor whiteColor];
    [self.table reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    gdiInfoTableViewCell *cell = (gdiInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[gdiInfoTableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.enTitle = [self.titles objectAtIndex:indexPath.row];
    cell.title = [self.cnTitles objectAtIndex:indexPath.row];
    NSObject *tmp = [self.infoDict objectForKey:[self.titles objectAtIndex:indexPath.row]];
    if ([cell.enTitle isEqualToString:kInfoWarrantTime])
    {
        int num = [tmp performSelector:@selector(intValue)];
        int year = num % 365;
        int month = (num - (year*365))/30;
        int day = num - year*365 - month*30;
        if (year > 0)
        {
            if (month > 0) {
                if (day > 0) {
                    cell.content = [NSString stringWithFormat:@"%d年%d月%d天", year, month, day];
                }
                else
                {
                    cell.content = [NSString stringWithFormat:@"%d年%d月", year, month];
                }
            }
            else
            {
                if (day > 0) {
                    cell.content = [NSString stringWithFormat:@"%d年%d天", year, day];
                }
                else
                {
                    cell.content = [NSString stringWithFormat:@"%d年", year];
                }
            }
        }
        else
        {
            if (month > 0) {
                if (day > 0) {
                    cell.content = [NSString stringWithFormat:@"%d月%d天", month, day];
                }
                else
                {
                    cell.content = [NSString stringWithFormat:@"%d月", month];
                }
            }
            else
            {
                if (day > 0) {
                    cell.content = [NSString stringWithFormat:@"%d天", day];
                }
                else
                {
                    // 不可能的
                    cell.content = [NSString stringWithFormat:@"%d天", day];
                }
            }
        }
    }
    else if ([cell.enTitle isEqualToString:kInfoPrice])
    {
        cell.content = [NSString stringWithFormat:@"￥%@", tmp];
    }
    else
    {
        cell.content = tmp;
    }
    [cell cellDidLoad];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    gdiInfoTableViewCell *cell = (gdiInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:cell.title message:cell.content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
