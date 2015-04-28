//
//  gdiDataOperation.h
//  GDiPhone
//
//  Created by YuDa on 14-11-3.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gdiDataOperation : NSObject
+ (id)getInstance;
- (void)encodeIcon;
- (void)encodeDetail:(NSString *)name;
- (void)encodeMovie:(NSString *)name;


@property (nonatomic) BOOL threadHasStopped;
@end
