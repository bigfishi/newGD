//
//  gdiListViewController.h
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeCategory<NSObject>
- (void)changeCategory:(NSString *)category;
@end
@protocol changePrice<NSObject>
- (void)changePrice:(NSString *)price;
@end


@interface gdiListViewController : gdiBaseViewController<changeCategory, changePrice, UISearchBarDelegate>

- (id)initWithCategory:(NSString *)category;

@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) UIScrollView *listScroll;

@property (nonatomic, strong) NSString *strTitle;

@end
