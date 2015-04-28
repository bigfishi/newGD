//
//  liViewController.h
//  testLargeImage
//
//  Created by yuda on 14-12-15.
//  Copyright (c) 2014年 yuda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoadLargeImageViewDelegate;

@interface LargeImageContainer : UIView<LoadLargeImageViewDelegate>
- (id)initWithImgPath:(NSString *)path andParent:(UIView *)parent;
@end
