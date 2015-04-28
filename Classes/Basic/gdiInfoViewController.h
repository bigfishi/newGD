//
//  gdiInfoViewController.h
//  GDiPhone
//
//  Created by YuDa on 14-9-25.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gdiInfoViewController : gdiBaseViewController<UITableViewDelegate, UITableViewDataSource>
- (void)changeInfo:(NSDictionary *)info;
@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSDictionary *infoDict;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSArray *titles;
@end
