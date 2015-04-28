//
//  gdiDownloadHelper.h
//  GDiPhone
//
//  Created by YuDa on 14-11-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gdiDownloadHelper : NSObject
@property int imgCount;
@property int iconCount;
@property int detailCount;
@property int movieCount;

+ (id)getInstance;
- (BOOL)getProductInfoWithVersion:(NSNumber *)pv;
@end

@interface gdiDownloadIcon : NSObject
- (void)downLoadIconWithProId:(NSNumber *)Id;
@end

@interface gdiDownloadDetail : NSObject
- (void)setHasEnd;
- (void)downLoadDetailWithProId:(NSNumber *)Id;
@end

@interface gdiDownloadMovie : NSObject
- (void)setHasEnd;
- (void)downLoadMovieWithProId:(NSNumber *)Id;
@end

@interface gdiDownloadImgTurn : NSObject
- (void)downLoadImgTurnWithId:(NSNumber *)Id name:(NSString *)name;
@end
