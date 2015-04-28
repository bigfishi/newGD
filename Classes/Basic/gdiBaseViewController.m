//
//  gdiBaseViewController.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiBaseViewController.h"

@interface gdiBaseViewController ()

@end

@implementation gdiBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.baseScroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.baseScroll.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.baseScroll.contentSize = self.baseScroll.frame.size;
    [self.view addSubview:self.baseScroll];
    self.baseScroll.alwaysBounceVertical = YES;
    // 这个是让子视图能接收触摸事件
    self.baseScroll.userInteractionEnabled = YES;
    // 设置这个之后，先响应子页面的触摸事件
//    self.baseScroll.delaysContentTouches = NO;
}

@end
