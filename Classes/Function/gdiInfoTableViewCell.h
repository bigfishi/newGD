//
//  gdiInfoTableViewCell.h
//  GDiPhone
//
//  Created by YuDa on 14-9-25.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gdiInfoTableViewCell : UITableViewCell
@property (strong, nonatomic) NSString *enTitle;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
- (void)cellDidLoad;
@end
