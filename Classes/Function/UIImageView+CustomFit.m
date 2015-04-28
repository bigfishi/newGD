//
//  UIImageView+CustomFit.m
//  GDiPhone
//
//  Created by YuDa on 14-9-23.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "UIImageView+CustomFit.h"

@implementation UIImageView (CustomFit)
- (void)fitAndScale
{
    [self sizeToFit];
    CGFloat scale = self.frame.size.width / [UIScreen mainScreen].bounds.size.width;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width/scale, frame.size.height/scale);
    self.frame = frame;
}
- (void)fitAndScale:(CGFloat)width
{
    [self sizeToFit];
    CGFloat scale = self.frame.size.width / width;
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width/scale, frame.size.height/scale);
    self.frame = frame;
}
@end
