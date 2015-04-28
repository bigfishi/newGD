//
//  gdiAddImgTurn.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiAddImgTurn.h"
#import "SGFocusImageItem.h"
#import "gdiListViewController.h"

@implementation gdiAddImgTurn
- (CGFloat)addImgTurnToView:(UIView *)superView origin:(CGPoint)origin
{
    CGFloat fRet = 0;
    gdiSingleton *instance = [gdiSingleton getInstance];
    NSUInteger length = instance.imgTurnArray.count;
    
    NSArray *tempArray = instance.imgTurnArray;
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
    //添加最后一张图 用于循环
    if (length > 1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:length-1];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
        [itemArray addObject:item];
    }
    for (int i = 0; i < length; i++)
    {
        NSDictionary *dict = [tempArray objectAtIndex:i];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:i];
        [itemArray addObject:item];
    }
    //添加第一张图 用于循环
    if (length >1)
    {
        NSDictionary *dict = [tempArray objectAtIndex:0];
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:length];
        [itemArray addObject:item];
    }
    CGFloat xyScale = 0;
    // 复制第一张图片
    {
        NSString *imgPath = [(NSDictionary *)[tempArray objectAtIndex:0] objectForKey:@"image"];
        UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
        UIImageView *tmpImgView = [[UIImageView alloc] initWithImage:img];
        [tmpImgView sizeToFit];
        xyScale = tmpImgView.frame.size.height/tmpImgView.frame.size.width;
        fRet = SCREEN_WIDTH*xyScale;
    }
    
    
    NSDictionary *dict = [tempArray objectAtIndex:0];
    SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithDict:dict tag:-1];
    // 320 * 105
//    CGSize size = CGSizeMake(superView.frame.size.width, superView.frame.size.width/320*105);
    CGSize size = CGSizeMake(superView.frame.size.width, superView.frame.size.width*xyScale);
    CGRect frame = CGRectMake(origin.x, origin.y, size.width, size.height);
    SGFocusImageFrame *bannerView = [[SGFocusImageFrame alloc] initWithFrame:frame delegate:self imageItems:@[item] isAuto:YES];
    [superView addSubview:bannerView];
    
    [bannerView changeImageViewsContent:itemArray];
    return fRet;
}

- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    BOOL isCategory = YES;
    if ([item.mapping_type isEqualToString:@"product"])
    {
        isCategory = NO;
    }
    UINavigationController * cnl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (isCategory)
    {
        gdiListViewController *list = [[gdiListViewController alloc] initWithCategory:item.mapping_id];
        [cnl pushViewController:list animated:YES];
    }
    else
    {
        gdiSingleton *instance = [gdiSingleton getInstance];
        NSDictionary *info = [instance getInfo:item.mapping_id];
//        gdiDetailViewController *detail = [[gdiDetailViewController alloc] initWithInfo:info];
        gdiDetailViewController *detail = instance.detailController;
        [detail changeInfo:info];
        [cnl pushViewController:detail animated:YES];
    }
    // tag从0开始
    NSLog(@"选中了%d项, title为%@", (int)item.tag, item.title);
}
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame currentItem:(int)index
{
    // index从0开始
    NSLog(@"切换到了%d项", index);
}

@end
