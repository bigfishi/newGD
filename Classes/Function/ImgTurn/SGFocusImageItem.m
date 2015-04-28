//
//  SGFocusImageItem.m
//  ScrollViewLoop
//
//  Created by Vincent Tang on 13-7-18.
//  Copyright (c) 2013年 Vincent Tang. All rights reserved.
//

#import "SGFocusImageItem.h"

@implementation SGFocusImageItem
@synthesize title = _title;
@synthesize image = _image;
@synthesize no = _no;
@synthesize tag = _tag;

- (void)dealloc
{
    self.title = nil;
    self.image = nil;
    self.no = nil;
    [super dealloc];
}
- (id)initWithTitle:(NSString *)title image:(NSString *)image no:(NSString *)no tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        self.title = title;
        self.image = image;
        self.no = no;
        self.tag = tag;
    }
    
    return self;
}

- (id)initWithDict:(NSDictionary *)dict tag:(NSInteger)tag
{
    self = [super init];
    if (self)
    {
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            self.title = [dict objectForKey:@"title"];
            if (!self.title) {
                self.title = @"标题";
            }
            // 图片路径
            self.image = [dict objectForKey:@"image"];
            self.no = [dict objectForKey:@"no"];
            self.mapping_id = [dict objectForKey:@"mapping_id"];
            
            self.mapping_type = [dict objectForKey:@"mapping_type"];
            //...
            self.tag = tag;
        }
    }
    return self;
}
@end
