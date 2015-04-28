//
//  gdiAddHScrollViewByImg.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiAddHScrollViewByImg.h"

@implementation gdiAddHScrollViewByImg
- (CGFloat)addHScrollView:(UIView *)parentView origin:(CGPoint)origin
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
    float num = 10;
    CGFloat productWidth = 300;
    CGFloat productPadding = 15;
    CGFloat newHeight = fRet;
    for (int i=0; i<num; i++)
    {
        UIImage *img = [UIImage imageNamed:@"img1.png"];
        UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
        CGRect frame = imgView.frame;
        frame.origin.x = i*(productWidth+productPadding);
        frame.origin.y = 0;
        imgView.frame = frame;
        imgView.layer.cornerRadius = 20;
        
        imgView.layer.masksToBounds = YES;
        imgView.layer.cornerRadius = 20.0;
//        userhead.layer.borderWidth = 1.0;
//        userhead.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        [imgView fitAndScale:productWidth];
        [self.scroll addSubview:imgView];
        newHeight = newHeight < imgView.frame.size.height ? imgView.frame.size.height : newHeight;
    }
    self.scroll.contentSize = CGSizeMake((productWidth+productPadding)*num, fRet);
    [parentView addSubview:self.scroll];
    CGRect frame=  self.scroll.frame;
    frame.size.height = newHeight;
    self.scroll.frame = frame;
    fRet = newHeight;
    return fRet;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollView.showsHorizontalScrollIndicator = NO;
}
@end
