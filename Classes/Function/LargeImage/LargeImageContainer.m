//
//  liViewController.m
//  testLargeImage
//
//  Created by yuda on 14-12-15.
//  Copyright (c) 2014年 yuda. All rights reserved.
//

#import "LargeImageContainer.h"
#import "LargeImageDownsizingView.h"

@interface LargeImageContainer ()
@property (nonatomic, strong) LargeImageDownsizingView *largeImgDownsizing;
@property (nonatomic, weak) UIView *parent;
@end

@implementation LargeImageContainer

- (id)initWithImgPath:(NSString *)path andParent:(UIView *)parent
{
    self = [super init];
    if (self) {
        self.parent = parent;
        self.frame = self.parent.bounds;
        self.backgroundColor = [UIColor whiteColor];
        LargeImageDownsizingView *largeImgDownsizing = [[LargeImageDownsizingView alloc] initWithFrame:self.bounds];
        largeImgDownsizing.backgroundColor = [UIColor clearColor];
        [self addSubview:largeImgDownsizing];
        [largeImgDownsizing loadWithPath:path];
        largeImgDownsizing.delegate = self;
        self.largeImgDownsizing = largeImgDownsizing;
    }
    return self;
}

- (void)fitImageView:(UIImageView *)imageView andSize:(CGSize)size
{
//    [imageView sizeToFit];
//    CGFloat scale = size.width / [UIScreen mainScreen].bounds.size.width;
//    CGRect frame = imageView.frame;
//    frame.size = CGSizeMake(size.width/scale, size.height/scale);
//    imageView.frame = frame;
//    self.frame = frame;
}

- (void)LoadLargeImageComplete:(CGSize)imgSize
{
    [self fitImageView:self.largeImgDownsizing andSize:imgSize];
}

- (void)removeFromSuperview
{
    [self.largeImgDownsizing removeFromSuperview];
    [super removeFromSuperview];
}

@end
