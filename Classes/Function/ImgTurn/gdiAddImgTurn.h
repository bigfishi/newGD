//
//  gdiAddImgTurn.h
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGFocusImageFrame.h"

@interface gdiAddImgTurn : NSObject<SGFocusImageFrameDelegate>

- (CGFloat)addImgTurnToView:(UIView *)superView origin:(CGPoint)origin;
// SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item;
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index;

@end
