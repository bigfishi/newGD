//
//  gdiDetailViewController.h
//  GDiPhone
//
//  Created by YuDa on 14-9-21.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gdiInfoViewController.h"
#import "LGPlayerViewController.h"

@interface gdiDetailViewController : gdiBaseViewController
- (id)initWithInfo:(NSDictionary *)info;
- (void)changeInfo:(NSDictionary *)info;
@property (strong, nonatomic) NSString *iconPath;
@property (strong, nonatomic) NSString *infoPath;
@property (strong, nonatomic) NSString *detailPath;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIView *upView;
@property (strong, nonatomic) UIView *downView;

@property (strong, nonatomic) NSDictionary *info;
@property (strong, nonatomic) UIImageView *detailImg;


@property (nonatomic, strong) gdiInfoViewController *infoCnl;
@property (nonatomic, strong) LGPlayerViewController *fuckPlayer;

// 解密视频结束之后，删除死亡区域
- (void)removeDeathAreaView;
// 解密detail图片的回调
- (void)loadDetailImgCallBack;
@end
