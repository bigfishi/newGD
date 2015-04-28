//
//  gdiSettingTableViewController.h
//  GDiPhone
//
//  Created by yuda on 14-12-12.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gdiSettingTableViewController : UITableViewController

- (IBAction)changeBgDownload:(UISwitch *)sender;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;

@end
