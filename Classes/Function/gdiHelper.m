//
//  gdiHelper.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiHelper.h"

@implementation gdiHelper

+ (BOOL)isiOS7
{
    BOOL bRet = NO;
    float deviceVersion = [[[UIDevice currentDevice]systemVersion] floatValue];
    if ([gdiHelper floatEqual:deviceVersion anotherFloat:7.0f] || deviceVersion > 7.0f)
    {
        bRet = YES;
    }
    return bRet;
}
// icon
NSString * getProIconFromDoc(NSString *str)
{
    NSString *strRet = nil;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo/%@/icon.png", str]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        strRet = path;
    }
    return strRet;
}
NSString * getProIconFromNative(NSString *str)
{
    return [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png" inDirectory:@"product1"];
}
// info
NSString * getProInfoFromDoc(NSString *str)
{
    NSString *strRet = nil;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo/%@/info.plist", str]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        strRet = path;
    }
    return strRet;
}
NSString * getProInfoFromNative(NSString *str)
{
    return [[NSBundle mainBundle] pathForResource:@"info" ofType:@"plist" inDirectory:@"product1"];
}
// detail
NSString * getProDetailFromDoc(NSString *str)
{
    NSString *strRet = nil;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo/%@/detail.jpg", str]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        strRet = path;
    }
    return strRet;
}
NSString * getProDetailFromNative(NSString *str)
{
    return [[NSBundle mainBundle] pathForResource:@"detail" ofType:@"jpg" inDirectory:@"product1"];
}

+ (BOOL)floatEqual:(float)num1 anotherFloat:(float)num2
{
    float littleNum = 0.0001f;
    float tmp = num1 - num2;
    if (tmp > -littleNum && tmp < littleNum)
    {
        return YES;
    }
    return NO;
}

+ (CGFloat)captionHeight
{
    return 44.0f;
}

@end
