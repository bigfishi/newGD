//
//  gdiPriceTableViewController.h
//  GDiPhone
//
//  Created by YuDa on 14-10-18.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changePrice;
@interface gdiPriceTableViewController : UITableViewController

@property (strong, nonatomic) NSString *currentPrice;
@property (strong, nonatomic) NSArray *prices;
@property (weak, nonatomic) id<changePrice> uddelegate;

@end
