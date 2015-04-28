//
//  SGFocusImageItem.h
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGFocusImageItem : NSObject

@property (nonatomic, retain)  NSString     *title;
@property (nonatomic, retain)  NSString      *image;
@property (nonatomic, assign)  NSInteger     tag;
@property (nonatomic, retain)  NSString     *no;
@property (nonatomic, retain)  NSString     *mapping_id;
@property (nonatomic, retain)  NSString     *mapping_name;
@property (nonatomic, retain)  NSString     *mapping_type;

- (id)initWithTitle:(NSString *)title image:(NSString *)image no:(NSString *)no tag:(NSInteger)tag;
- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag;
@end
