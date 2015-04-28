//
//  gdiProductView.h
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gdiProductView : UIView
- (id)initWidthInfo:(NSDictionary *)info frame:(CGRect)frame;

@property (nonatomic, strong) NSDictionary *info;
@property (nonatomic, strong) NSString *no;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) NSString *strProductName;
@property (nonatomic, strong) NSString *strProductRecommandWord;
@property (nonatomic, strong) NSString *strProductPrice;
@property (nonatomic, strong) UILabel *productName;
@property (nonatomic, strong) UILabel *productRecommandWord;
@property (nonatomic, strong) UILabel *productPrice;
@property (nonatomic) CGFloat height;
@end
