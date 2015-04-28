//
//  gdiDataOperation.m
//  GDiPhone
//
//  Created by YuDa on 14-11-3.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiDataOperation.h"
#import "MHFileTool.h"
#import "DES.h"

@implementation gdiDataOperation
static gdiDataOperation *instance = nil;
+ (id)getInstance
{
    if (!instance)
    {
        instance = [[gdiDataOperation alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(movieHasStop) name:MOVIE_HAS_STOPPED object:nil];
//        instance.threadHasStopped = NO;
    }
    return instance;
}
- (void)encodeIcon
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    // 产品信息
    {
        NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ProductInfo"];
        NSArray *array = [fm contentsOfDirectoryAtPath:rootPath error:&error];
        if (error)
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"错误：%@", error] waitUntilDone:NO];
        }
        for (int i=0; i<array.count; i++)
        {
            NSString *no = [array objectAtIndex:i];
            NSArray *subArray = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", rootPath, no] error:&error];
            // 已经解密
            if ([subArray containsObject:@"jiemiicon.jpg"] || [subArray containsObject:@"jiemiicon.png"])
            {
                continue;
            }
            for (int j=0; j<subArray.count; j++)
            {
                NSString *name = [subArray objectAtIndex:j];
                NSString *shortName = [name substringToIndex:name.length-4];
                if ([shortName isEqualToString:@"icon"])
                {
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@", rootPath, no];
                    [self readQuestionData:name Path:filePath];
                }
            }
        }
    }
}
- (void)encodeImgTurn
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    // 产品信息
    {
        NSString *rootPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImgTurn"];
        NSArray *array = [fm contentsOfDirectoryAtPath:rootPath error:&error];
        if (error)
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"错误：%@", error] waitUntilDone:NO];
        }
        for (int i=0; i<array.count; i++)
        {
            NSString *name = [array objectAtIndex:i];
            NSFileManager *fm = [NSFileManager defaultManager];
            if([fm fileExistsAtPath:[NSString stringWithFormat:@"%@/jiemi%@", rootPath, name]] || [name hasPrefix:@"jiemi"])
            {
                continue;
            }
            NSString *shortName = [name substringFromIndex:name.length-3];
            if ([shortName isEqualToString:@"png"] || [shortName isEqualToString:@"jpg"])
            {
                [self readQuestionData:name Path:rootPath];
            }
        }
    }
}
- (void)encodeAll
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    // 产品信息
    {
        NSString *rootPath = [[NSBundle mainBundle] pathForResource:@"Resources备份/ProductInfo" ofType:nil];
        NSArray *array = [fm contentsOfDirectoryAtPath:rootPath error:&error];
        if (error)
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"错误：%@", error] waitUntilDone:NO];
        }
        for (int i=0; i<array.count; i++)
        {
            NSString *no = [array objectAtIndex:i];
            NSArray *subArray = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", rootPath, no] error:&error];
            for (int j=0; j<subArray.count; j++)
            {
                NSString *name = [subArray objectAtIndex:j];
                NSString *shortName = [name substringFromIndex:name.length-3];
                if ([shortName isEqualToString:@"png"] || [shortName isEqualToString:@"jpg"])
                {
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@", rootPath, no];
                    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", filePath, name];
                    if (![fm fileExistsAtPath:fullPath])
                    {
                        filePath = [NSString stringWithFormat:@"%@/%@", rootPath, no];
                        name = @"icon.png";
                        fullPath = [NSString stringWithFormat:@"%@/%@", filePath, no];
                    }
                    if (![fm fileExistsAtPath:fullPath])
                    {
                        continue;
                    }
                    [self makeQuestionData:name Path:filePath];
                }
            }
        }
    }
    // 视频
    {
        error = nil;
        NSString *rootPath = [[NSBundle mainBundle] pathForResource:@"Resources备份/movie" ofType:nil];
        NSArray *array = [fm contentsOfDirectoryAtPath:rootPath error:&error];
        if (error)
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"错误：%@", error] waitUntilDone:NO];
        }
        int count = array.count;
        for (int i=0; i<count; i++)
        {
            NSString *name = [array objectAtIndex:i];
            [self makeQuestionData:name Path:rootPath];
        }
    }
    // 图片轮播
    {
        error = nil;
        NSString *rootPath = [[NSBundle mainBundle] pathForResource:@"Resources备份/ImgTurn" ofType:nil];
        NSArray *array = [fm contentsOfDirectoryAtPath:rootPath error:&error];
        if (error)
        {
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:[NSString stringWithFormat:@"错误：%@", error] waitUntilDone:NO];
        }
        int count = array.count;
        for (int i=0; i<count; i++)
        {
            NSString *name = [array objectAtIndex:i];
            NSString *shortName = [name substringFromIndex:name.length-3];
            if ([shortName isEqualToString:@"png"] || [shortName isEqualToString:@"png"])
            {
                [self makeQuestionData:name Path:rootPath];
            }
        }
    }
    [self performSelectorOnMainThread:@selector(showMessage:) withObject:@"完成" waitUntilDone:NO];
}

- (void)showMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)decodeSomething:(NSString *)path
{
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(jiami:) object:path];
    [thread start];
}

- (void)jiami:(NSString *)path
{
    //解密文件
    //    [self readQuestionData];
}

- (NSArray *)readQuestionData:(NSString *)name Path:(NSString *)path andSavePath:(NSString *)savePath
{
    NSString *encFileName = name;//[NSString stringWithFormat:@"jiami%@", name];
    NSString *desFileName = [NSString stringWithFormat:@"jiemi%@", name];
    //    NSString *filePath = [MHFileTool getLocalFilePath:jiamiFileName];
    NSString *encPath = [NSString stringWithFormat:@"%@/%@", path, encFileName];
    NSString *desPath = [NSString stringWithFormat:@"%@/%@", savePath, desFileName];
    NSFileHandle *readFH = [NSFileHandle fileHandleForReadingAtPath:encPath];
    NSFileHandle *writeFH = [NSFileHandle fileHandleForWritingAtPath:desPath];
    if (!writeFH)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *error = nil;
        BOOL b = [fm createFileAtPath:desPath contents:nil attributes:nil];
        if (!b) {
            NSLog(@"error:%@", error);
        }
        writeFH = [NSFileHandle fileHandleForWritingAtPath:desPath];
    }
    do {
        @autoreleasepool
        {
            NSData *data = [readFH readDataOfLength:1398112]; // 1024*1024 个
            if (!data || data.length == 0)
            {
                [readFH closeFile];
                [writeFH closeFile];
                break;
            }
            NSData *desData = [DES decryptData:data];
            [writeFH seekToEndOfFile];
            [writeFH writeData:desData];
            [writeFH synchronizeFile];
        }
    } while (1);
    // 一次读取，一次写入，浪费资源
//    NSData *data = [NSData dataWithContentsOfFile:encPath];
//    if (data)
//    {
//        NSData *desData = [DES decryptData:data];
//        
//        if(desData)
//        {
//            //                NSString *filePath = [MHFileTool getLocalFilePath:jiemiFileName];
//            NSString *filePath = [NSString stringWithFormat:@"%@/%@", savePath, desFileName];
//            BOOL b = [desData writeToFile:filePath atomically:YES];
//            if (!b)
//            {
//                NSLog(@"存储文件出错了。。。");
//            }
//        }
//    }
    return nil;
}
//读取并解密-》加密的题库
- (NSArray *)readQuestionData:(NSString *)name Path:(NSString *)path
{
    return [self readQuestionData:name Path:path andSavePath:path];
}


//生产加密题库
- (NSArray *)makeQuestionData:(NSString *)name Path:(NSString *)path andSavePath:(NSString *)savePath
{
    NSString *jiamiFileName = [NSString stringWithFormat:@"%@", name];
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, name];
    if (filePath)
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data)
        {
            NSData *desData = [DES encryptData:data];
            if(desData)
            {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", savePath, jiamiFileName];
                [desData writeToFile:filePath atomically:YES];
            }
        }
    }
    return nil;
}
- (NSArray *)makeQuestionData:(NSString *)name Path:(NSString *)path
{
    return [self makeQuestionData:name Path:path andSavePath:path];
}

- (void)encodeDetail:(NSString *)name
{
    NSString *trueName = [[name componentsSeparatedByString:@"/"] lastObject];
    NSString *path = [name substringToIndex:name.length-trueName.length-1];
    NSString *savePath = [gdiSingleton getAppPath];
    
    gdiDataOperation *dataOperation = [gdiDataOperation getInstance];
    [dataOperation readQuestionData:trueName Path:path andSavePath:savePath];
    dispatch_async(dispatch_get_main_queue(), ^(){
        gdiSingleton *instance = [gdiSingleton getInstance];
        [instance.detailController loadDetailImgCallBack];
    });
}
- (void)encodeMovie:(NSString *)name
{
//    self.threadHasStopped = NO;
    name = [NSString stringWithFormat:@"%@.mp4", name];
    NSString *tmpStr = @"jiemi";
    if ([name rangeOfString:tmpStr].length != 0)
    {
        name = [name substringFromIndex:tmpStr.length];
    }
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/movie"];
    NSString *savePath = [gdiSingleton getAppPath];
    
    gdiDataOperation *dataOperation = [gdiDataOperation getInstance];
    [dataOperation readQuestionData:name Path:path andSavePath:savePath];
//    {
//        NSString *jiamiFileName = [NSString stringWithFormat:@"%@", name];
//        NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, name];
//        if (filePath)
//        {
//            NSFileHandle *readFH = [NSFileHandle fileHandleForReadingAtPath:filePath];
//            NSFileHandle *writeFH = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithFormat:@"%@/jiemi%@", savePath, name]];
//            if (!writeFH)
//            {
//                NSFileManager *fm = [NSFileManager defaultManager];
//                [fm createFileAtPath:[NSString stringWithFormat:@"%@/jiemi%@", savePath, name] contents:nil attributes:nil];
//                writeFH = [NSFileHandle fileHandleForWritingAtPath:[NSString stringWithFormat:@"%@/jiemi%@", savePath, name]];
//            }
//            do {
//                @autoreleasepool
//                {
//                    NSData *data = [readFH readDataOfLength:1376*1024];
//                    if (!data || data.length == 0) {
//                        [readFH closeFile];
//                        [writeFH closeFile];
//                        break;
//                    }
//                    NSData *desData = [DES decryptData:data];
//                    [writeFH seekToEndOfFile];
//                    [writeFH writeData:desData];
//                    [writeFH synchronizeFile];
//                }
//            } while (1);
//        }
//    }
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        //单例模式下，不现实
//        if (self.threadHasStopped)
//        {
//            return ;
//        }
        gdiSingleton *instance = [gdiSingleton getInstance];
        [instance.detailController.fuckPlayer loadMovieCallBack:nil];
        [instance.detailController removeDeathAreaView];
    });
}

- (void)movieHasStop
{
//    self.threadHasStopped = YES;
//    NSThread *thread = [NSThread currentThread];
    // 连主线程也一起停止了
//    [NSThread sleepForTimeInterval:10000];
//    [thread cancel];
//    [NSThread exit];
}

@end
