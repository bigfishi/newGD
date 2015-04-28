//
//  gdiAddHScrollView.h
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gdiAddHScrollView : NSObject<UIScrollViewDelegate, UIScrollViewAccessibilityDelegate>
- (CGFloat)addHScrollView:(UIView *)parentView origin:(CGPoint)origin type:(NSString *)type;
- (CGFloat)addHScrollView:(UIView *)parentView origin:(CGPoint)origin info:(NSArray *)info;
- (void)changeByInfo:(NSArray *)info;
@property (nonatomic, strong) UIScrollView *scroll;
@end
