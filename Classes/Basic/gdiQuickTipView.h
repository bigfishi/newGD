//
//  gdiQuickTipView.h
//  GDiPhone
//
//  Created by yuda on 15-1-12.
//  Copyright (c) 2015年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gdiQuickTipView : UIView
- (id)initWithMessage:(NSString *)msg;
- (void)showAndAutoRemove;
@end
