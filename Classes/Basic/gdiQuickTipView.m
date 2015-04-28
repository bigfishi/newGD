//
//  gdiQuickTipView.m
//  GDiPhone
//
//  Created by yuda on 15-1-12.
//  Copyright (c) 2015年 YuDa. All rights reserved.
//

#import "gdiQuickTipView.h"

@interface gdiQuickTipView()

@property (nonatomic, strong) NSString *msg;

@end

@implementation gdiQuickTipView
// 768 * 1024
// 120 * 80

- (id)initWithMessage:(NSString *)msg
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        self.msg = msg;
    }
    return self;
}

- (void)showAndAutoRemove
{
    CGPoint padding = CGPointMake(15, 20);
    CGRect frame = CGRectMake(0, 0, 120, 80);
    self.backgroundColor = [UIColor blackColor];
    self.layer.cornerRadius = 10;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding.x, padding.y, frame.size.width, frame.size.height)];
    label.text = self.msg;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    [label sizeToFit];
    frame = CGRectMake(0, 0, label.frame.size.width, label.frame.size.height);
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    self.bounds = CGRectMake(0, 0, label.frame.size.width+padding.x*2, label.frame.size.height+padding.y*2);
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(removeOnself) userInfo:nil repeats:NO];
}

- (void)removeOnself
{
    [UIView animateWithDuration:1.f animations:^{
        self.layer.opacity = 0.01f;
        CGPoint center = self.center;
        self.center = CGPointMake(center.x, center.y-100);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
