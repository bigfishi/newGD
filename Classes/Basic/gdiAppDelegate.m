//
//  gdiAppDelegate.m
//  GDiPhone
//
//  Created by YuDa on 14-9-21.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//
// home.png地址：http://findicons.com/icon/158565/home#
// category.png地址：http://findicons.com/icon/265242/category_32?id=265877
// shop_cart地址：http://findicons.com/icon/267874/shop_cart?id=268216


#import "gdiAppDelegate.h"

@implementation gdiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"%@", NSHomeDirectory());
    // 这里设置不起作用
//    self.window.backgroundColor = [UIColor colorWithHexString:@"#FF0000"];
    // 写入document测试 数组写入plist
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSLog(@"doc is %@", docDir);
//    [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
//    NSString *filePath = [docDir stringByAppendingPathComponent:@"2.plist"];
//    NSArray * array = @[@1,@2,@3];
//    [array writeToFile:filePath atomically:YES];
//    NSLog(@"path:%@", filePath);
    
    // 写入document测试2 字符串写入txt文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = [paths objectAtIndex:0];
//    NSString *path = [documentPath stringByAppendingPathComponent:@"filename.txt"];
//    NSString *str = @"hello";
//    [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    // 写入document测试3 以追加的方式
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [docPath stringByAppendingPathComponent:@"测试.txt"];
//    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
//    if (fileHandle == nil)
//    {
//        NSFileManager *man = [NSFileManager defaultManager];
//        [man createFileAtPath:filePath contents:nil attributes:nil];
//        fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
//    }
//    [fileHandle seekToEndOfFile];
//    
//    NSArray *array = @[@"1", @2, @3, @(YES)];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
//    [fileHandle writeData:data];
//    [fileHandle closeFile];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    NSLog(@"---------------------");
}

@end
