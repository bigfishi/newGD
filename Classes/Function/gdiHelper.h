//
//  gdiHelper.h
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define colorWithRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f]
#define UNUSED(t) ((void)(t))

@interface gdiHelper : NSObject
+ (BOOL)isiOS7;
+ (BOOL)floatEqual:(float)num1 anotherFloat:(float)num2;
+ (CGFloat)captionHeight;
@end


// icon
FOUNDATION_EXPORT NSString * getProIconFromDoc(NSString *str);
FOUNDATION_EXPORT NSString * getProIconFromNative(NSString *str);
// info
FOUNDATION_EXPORT NSString * getProInfoFromDoc(NSString *str);
FOUNDATION_EXPORT NSString * getProInfoFromNative(NSString *str);
// detail
FOUNDATION_EXPORT NSString * getProDetailFromDoc(NSString *str);
FOUNDATION_EXPORT NSString * getProDetailFromNative(NSString *str);
