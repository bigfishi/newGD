//
//  gdiAddHScrollView.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiAddHScrollView.h"
#import "gdiProductView.h"

@implementation gdiAddHScrollView
- (CGFloat)addHScrollView:(UIView *)parentView origin:(CGPoint)origin type:(NSString *)type
{
    // 默认是20高度，不过可变动
    CGFloat fRet = 20.0f;
    CGFloat padding = 10;
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(padding, origin.y, SCREEN_WIDTH-padding*2, fRet)];
    self.scroll.delegate = self;
//    self.scroll.backgroundColor = [UIColor whiteColor];
    // 设置不能纵向滚动，如果frame和contentSize一样，则默认不能滚动
    self.scroll.alwaysBounceVertical = NO;
    // 这个不需要，因为contentSize大于frame
//    self.scroll.alwaysBounceHorizontal = YES;
    self.scroll.canCancelContentTouches = YES;
    self.scroll.userInteractionEnabled = YES;
    
    
    CGFloat productWidth = 180;
    CGFloat productPadding = 10;
    CGFloat newHeight = fRet;
    
    gdiSingleton *instance = [gdiSingleton getInstance];
    NSArray *info = [instance getCategoryArray:type];
    float num = info.count;
    for (int i=0; i<num; i++)
    {
        gdiProductView *productView = [[gdiProductView alloc] initWidthInfo:[info objectAtIndex:0] frame:CGRectMake(i*(productWidth+productPadding), 0, productWidth, fRet)];
//        gdiProductView *productView = [[gdiProductView alloc] initWidthName:[NSString stringWithFormat:@"product%d", i+1] frame:CGRectMake(i*(productWidth+productPadding), 0, productWidth, fRet)];
        [self.scroll addSubview:productView];
        newHeight = newHeight < productView.height ? productView.height : newHeight;
    }
    CGFloat tmpWidth = (productWidth+productPadding)*num < self.scroll.frame.size.width ? self.scroll.frame.size.width : (productWidth+productWidth)*num;
    self.scroll.contentSize = CGSizeMake(tmpWidth, fRet);
    [parentView addSubview:self.scroll];
    CGRect frame = self.scroll.frame;
    frame.size.height = newHeight;
    self.scroll.frame = frame;
    fRet = newHeight;
    return fRet;
}
- (CGFloat)addHScrollView:(UIView *)parentView origin:(CGPoint)origin info:(NSArray *)info
{
    // 默认是20高度，不过可变动
    CGFloat fRet = 20.0f;
    CGFloat padding = 10;
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(padding, origin.y, SCREEN_WIDTH-padding*2, fRet)];
    self.scroll.delegate = self;
    //    self.scroll.backgroundColor = [UIColor whiteColor];
    // 设置不能纵向滚动，如果frame和contentSize一样，则默认不能滚动
    self.scroll.alwaysBounceVertical = NO;
    // 这个不需要，因为contentSize大于frame
    //    self.scroll.alwaysBounceHorizontal = YES;
    self.scroll.canCancelContentTouches = YES;
    self.scroll.userInteractionEnabled = YES;
    
    
    CGFloat productWidth = 180;
    CGFloat productPadding = 10;
    CGFloat newHeight = fRet;
    
    float num = info.count;
    for (int i=0; i<num; i++)
    {
        gdiProductView *productView = [[gdiProductView alloc] initWidthInfo:[info objectAtIndex:i] frame:CGRectMake(i*(productWidth+productPadding), 0, productWidth, fRet)];
        //        gdiProductView *productView = [[gdiProductView alloc] initWidthName:[NSString stringWithFormat:@"product%d", i+1] frame:CGRectMake(i*(productWidth+productPadding), 0, productWidth, fRet)];
        [self.scroll addSubview:productView];
        newHeight = newHeight < productView.height ? productView.height : newHeight;
    }
    CGFloat tmpWidth = (productWidth+productPadding)*num < self.scroll.frame.size.width ? self.scroll.frame.size.width : (productWidth+productPadding)*num;
    self.scroll.contentSize = CGSizeMake(tmpWidth, fRet);
    [parentView addSubview:self.scroll];
    CGRect frame = self.scroll.frame;
    frame.size.height = newHeight;
    self.scroll.frame = frame;
    fRet = newHeight;
    return fRet;
}
- (void)changeByInfo:(NSArray *)info
{
    // 默认是20高度，不过可变动
    CGFloat fRet = 20.0f;
//    CGFloat padding = 10;
    
    CGFloat productWidth = 180;
    CGFloat productPadding = 10;
    CGFloat newHeight = fRet;
    
    float num = info.count;
    
    for (gdiProductView *view in self.scroll.subviews) {
        [view removeFromSuperview];
    }
    for (int i=0; i<num; i++)
    {
        gdiProductView *productView = [[gdiProductView alloc] initWidthInfo:[info objectAtIndex:i] frame:CGRectMake(i*(productWidth+productPadding), 0, productWidth, fRet)];
        [self.scroll addSubview:productView];
        newHeight = newHeight < productView.height ? productView.height : newHeight;
    }
}
// 开始拖动，不显示横向的滚动条
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 默认开始拖动时，显示
    scrollView.showsHorizontalScrollIndicator = NO;
}
// 这个什么东西
- (NSString *)accessibilityScrollStatusForScrollView:(UIScrollView *)scrollView
{
    return @"123";
}
@end
