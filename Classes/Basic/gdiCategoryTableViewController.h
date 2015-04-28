//
//  gdiCategoryTableViewController.h
//  GDiPhone
//
//  Created by 夏震华 on 14-9-27.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeCategory;
@interface gdiCategoryTableViewController : UITableViewController

- (id)initWithKey:(NSString *)key;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *currentCategory;
@property (strong, nonatomic) NSMutableArray *categories;
@property (weak, nonatomic) id<changeCategory> uddelegate;

@end
