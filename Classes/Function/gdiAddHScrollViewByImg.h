//
//  gdiAddHScrollViewByImg.h
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gdiAddHScrollViewByImg : NSObject<UIScrollViewDelegate>
- (CGFloat)addHScrollView:(UIView *)parentView origin:(CGPoint)origin;
@property (nonatomic, strong) UIScrollView *scroll;
@end
