//
//  gdiSingleton.h
//  GDiPhone
//
//  Created by zhongbinghong on 14-9-27.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "gdiDataOperation.h"
#import "gdiDownloadHelper.h"

//#define kInfoNo             @"no"
#define kInfoBand           @"brand"
#define kInfoCode           @"code"
#define kInfoFeature        @"description"
#define kInfoNo             @"id"
#define kInfoVersion        @"model_size"
#define kInfoName           @"name"
#define kInfoDependency     @"origin_country"
#define kInfoPrice          @"price_retail"
#define kInfoRecomandWord   @"recommend_word"
#define kInfoUnit           @"unit"
#define kInfoValid          @"valid"
#define kInfoWarrantTime    @"warranty_days"

// keyword
#define kKeywordTypeCode    @"type_code"
#define kKeywordId          @"id"
#define kKeywordName        @"name"
#define kKeywordValid       @"valid"
#define kKeywordTypeProductLargeCategory        @"PRODUCTLARGECATEGORY"


#define kInfoIconName       @"iconName"
#define kInfoDetailName     @"detailName"
#define kInfoCategory       @"keyword"
#define kInfoMovieName      @"movieName"

#define kImgTurnImg         @"image"
#define kImgTurnTitle       @"title"
#define kImgTurnNo          @"no"

#define priceFont           [UIFont systemFontOfSize:18]
#define priceColor          [UIColor redColor]


#define MOVIE_HAS_STOPPED   @"movieHasStopped"



// 通知的名称
#define kNotiInitNeedDownloadOver   @"kInitNeedDownloadOver"
#define kNotiDownloadDataOver       @"kDownloadDataOver"
#define kNotiInitDataOver           @"kInitDataOver"
#define kNotiDownloadIconOver       @"kDownloadIconOver"
#define kNotiDownloadAllIconOver    @"kDownloadAllIconOver"

#define kNotiDownloadSomeDetailOver @"kDownloadSomeDetailOver"
#define kNotiDownloadDetailOver     @"kDownloadDetailOver"
#define kNotiDownloadAllDetailOver  @"kDownloadAllDetailOver"

#define kNotiDownloadSomeMovieOver  @"kNotiDownloadSomeMovieOver"
#define kNotiDownloadMovieOver      @"kDownloadMovieOver"
#define kNotiDownloadAllMovieOver   @"kDownloadAllMovieOver"

#define kNotiDownloadImgOver        @"kDownloadImgOver"
#define kNotiDownloadAllImgOver     @"kDownloadAllImgOver"


// table name
#define TABLE_NAME_PRODUCT              @"product"
#define TABLE_NAME_FILE                 @"product_file"
#define TABLE_NAME_KEYWORD              @"keyword"
#define TABLE_NAME_KEYWORD_TYPE         @"keyword_type"
#define TABLE_NAME_KEYWORD_MAPPING      @"keyword_mapping"
#define TABLE_NAME_CAROUSEL_IMAGE       @"carousel_image"

@interface gdiSingleton : NSObject
+ (id)getInstance;
+ (NSString *)getAppPath;
- (void)initInfo;
- (NSDictionary *)getInfo:(NSString *)no;
- (NSArray *)getInfoWithNos:(NSArray *)nos;
- (NSArray *)getCategoryArray:(NSString *)category;
- (NSArray *)getCategoryArrayWithPartCategory:(NSString *)partCategory;
- (NSArray *)getArrayWithPartName:(NSString *)partName;

- (NSArray *)getArrayWithKey:(NSString *)key andTypes:(NSArray *)types enablePart:(BOOL)enablePart;
- (NSArray *)getArrayWithKey:(NSString *)key andTypeValues:(NSArray *)typeValues enablePart:(BOOL)enablePart;
- (NSArray *)getArrayWithKey:(NSString *)key andStr:(NSString *)str andTypes:(NSArray *)types enablePart:(BOOL)enablePart;
- (NSArray *)getArrayWithPrice:(NSString *)price;

@property (nonatomic, strong) NSArray *imgTurnArray;
@property (nonatomic, strong) NSArray *productArray;
@property (nonatomic, strong) NSMutableArray *limitObjectIds;
@property (nonatomic, strong) NSArray *productArrayByCategory;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *bands;
@property (nonatomic, strong) NSArray *productNames;
@property (nonatomic, strong) NSArray *productTips; // 商品名下面的提示
@property (nonatomic, strong) NSArray *displayItems; // 显示那些项
@property (nonatomic, strong) NSDictionary *productSetting;
@property (nonatomic, strong) NSArray   *hotProducts;
@property (nonatomic, strong) NSArray   *categoryBySetting;
@property (nonatomic, strong) NSArray   *movieBySetting;
@property (nonatomic, strong) gdiDetailViewController * detailController;

@property (nonatomic, strong) gdiDataOperation *dataOperation;

@property (strong, nonatomic) gdiDownloadHelper *dh;

@property (strong, nonatomic) NSNumber *enableBgDownload;
+ (BOOL)getEnableBgDownload;
+ (void)setEnableBgDownload:(BOOL)enable;
@end





