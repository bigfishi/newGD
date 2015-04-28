//
//  gdiSingleton.m
//  GDiPhone
//
//  Created by zhongbinghong on 14-9-27.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiSingleton.h"
#import "gdiDataOperation.h"


@implementation gdiSingleton
static gdiSingleton *instance = nil;
static NSString *hotString = @"hot";
static NSString *displayString = @"displayItems";
static NSString *categoryString = @"keyword";
static NSString *movieString = @"movie";

+ (id)getInstance {
    @synchronized(self) {
        if (instance == nil)
        {
            instance = [[self alloc] init];
            instance.detailController = [[gdiDetailViewController alloc] init];
        }
    }
    return instance;
}

+ (NSString *)getAppPath
{
    NSString *tmp = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [tmp stringByAppendingPathComponent:@"tmp"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path])
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
    }
    return path;
}

- (void)initInfo
{
    [self initPath];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSecondInfo) name:kNotiDownloadDataOver object:nil];
    NSNumber *pv = [self getProductVersion];
    self.dh = [gdiDownloadHelper getInstance];
    [self.dh getProductInfoWithVersion:pv];
    //    [self initProductNames];
    //    [self initProductTips];
}

- (void)initSecondInfo
{
    self.dataOperation = [gdiDataOperation getInstance];
    // 没有加密icon
//    [self.dataOperation encodeIcon];
//    [self.dataOperation encodeImgTurn];
    [self initDisplay];
    [self initImgTurnArray];
    [self initProductArray];
    [self initCategory];
    [self initBands];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiInitDataOver object:nil];
}

- (NSDictionary *)getInfo:(NSString *)no
{
    NSUInteger count = [self.productArray count];
    for (int i=0; i<count; i++) {
        NSDictionary *dict = [self.productArray objectAtIndex:i];
        id udno = [dict objectForKey:kInfoNo];
        if (![udno isKindOfClass:[NSString class]])
        {
            udno = [NSString stringWithFormat:@"%@", udno];
        }
        if ([udno isEqualToString:no])
        {
            return dict;
        }
    }
    return nil;
}
- (NSArray *)getArrayWithKey:(NSString *)key andTypes:(NSArray *)types enablePart:(BOOL)enablePart
{
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger typesCount = types.count;
    for (int i=0; i<typesCount; i++)
    {
        NSString *type = [types objectAtIndex:i];
        if (type == nil || [type isEqualToString:@""] || [type isEqualToString:@"所有"])
        {
            return self.productArray;
        }
        else
        {
            NSUInteger count = self.productArray.count;
            for (int i=0; i<count; i++)
            {
                NSDictionary *dict = [self.productArray objectAtIndex:i];
                NSString *cate = [dict objectForKey:key];
                NSString *typeValue = [dict objectForKey:type];
                if ([key isEqualToString:kInfoCategory]) // 每个商品分类可以有多个，所以直接判断包含
                {
                    if ([cate rangeOfString:typeValue].location != NSNotFound)
                    {
                        [result addObject:dict];
                    }
                }
                else
                {
                    if (enablePart)
                    {
                        if ([cate rangeOfString:typeValue].location != NSNotFound)
                        {
                            [result addObject:dict];
                        }
                    }
                    else
                    {
                        if ([cate isEqualToString:typeValue])
                        {
                            [result addObject:dict];
                        }
                    }
                }
            }
        }
    }
    return result;
}
- (NSArray *)getArrayWithKey:(NSString *)key andTypeValues:(NSArray *)typeValues enablePart:(BOOL)enablePart
{
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger typesCount = typeValues.count;
    for (int i=0; i<typesCount; i++)
    {
        NSString *type = [typeValues objectAtIndex:i];
        if (type == nil || [type isEqualToString:@""] || [type isEqualToString:@"所有"])
        {
            return self.productArray;
        }
        else
        {
            NSUInteger count = self.productArray.count;
            for (int i=0; i<count; i++)
            {
                NSDictionary *dict = [self.productArray objectAtIndex:i];
                NSString *cate = [dict objectForKey:key];
                if ([key isEqualToString:kInfoCategory]) // 每个商品分类可以有多个，所以直接判断包含
                {
                    if ([cate rangeOfString:type].location != NSNotFound)
                    {
                        [result addObject:dict];
                    }
                }
                else
                {
                    if (enablePart)
                    {
                        if ([cate rangeOfString:type].location != NSNotFound)
                        {
                            [result addObject:dict];
                        }
                    }
                    else
                    {
                        if ([cate isEqualToString:type])
                        {
                            [result addObject:dict];
                        }
                    }
                }
            }
        }
    }
    return result;
}
- (NSArray *)getArrayWithKey:(NSString *)key andStr:(NSString *)str andTypes:(NSArray *)types enablePart:(BOOL)enablePart
{
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger typesCount = types.count;
    
    
    NSUInteger count = self.productArray.count;
    for (int i=0; i<count; i++)
    {
        NSDictionary *dict = [self.productArray objectAtIndex:i];
        for (int j=0; j<typesCount; j++)
        {
            NSString *type = [types objectAtIndex:j];
            NSString *typeValue = [dict objectForKey:type];
            if (type == nil || [type isEqualToString:@""] || [type isEqualToString:@"所有"])
            {
                return self.productArray;
            }
            else
            {
                if ([key isEqualToString:kInfoCategory]) // 每个商品分类可以有多个，所以直接判断包含
                {
                    if ([typeValue rangeOfString:str].location != NSNotFound)
                    {
                        [result addObject:dict];
                        break;
                    }
                }
                else
                {
                    if (enablePart)
                    {
                        if ([typeValue rangeOfString:str].location != NSNotFound)
                        {
                            [result addObject:dict];
                            break;
                        }
                    }
                    else
                    {
                        if ([typeValue isEqualToString:str])
                        {
                            [result addObject:dict];
                            break;
                        }
                    }
                }
            }
        }
    }
    return result;
}
- (NSArray *)getCategoryArray:(NSString *)category
{
    //    if (self.categoryBySetting)
    //    {
    //        if (category == nil || [category isEqualToString:@""] || [category isEqualToString:@"所有"])
    //        {
    //            return self.productArray;
    //        }
    //        else
    //        {
    //            NSMutableArray *array = [NSMutableArray array];
    //            NSUInteger count = self.categoryBySetting.count;
    //            for (int j=0; j<count; j++)
    //            {
    //                NSDictionary *dict = [self.categoryBySetting objectAtIndex:j];
    //                NSString *cate = [dict objectForKey:@"name"];
    //                if ([cate isEqualToString:category])
    //                {
    //                    NSString *productsStr = [dict objectForKey:@"products"];
    //                    NSArray *nos = [productsStr componentsSeparatedByString:@","];
    //                    NSArray *info = [instance getInfoWithNos:nos];
    //                    return info;
    //                }
    //            }
    //            return array;
    //        }
    //    }
    //    else
    {
        if (category == nil || [category isEqualToString:@""] || [category isEqualToString:@"所有"])
        {
            return self.productArray;
        }
        else
        {
            NSMutableArray *array = [NSMutableArray array];
            NSUInteger count = self.productArray.count;
            for (int i=0; i<count; i++)
            {
                NSDictionary *dict = [self.productArray objectAtIndex:i];
                NSString *cate = [dict objectForKey:kInfoBand];
                if ([category isEqualToString:cate])
                {
                    [array addObject:dict];
                }
            }
            return array;
        }
    }
}

- (NSArray *)getCategoryArrayWithPartCategory:(NSString *)partCategory
{
    if (self.categoryBySetting)
    {
        NSMutableArray *array = [NSMutableArray array];
        NSUInteger count = self.categoryBySetting.count;
        for (int j=0; j<count; j++)
        {
            NSDictionary *dict = [self.categoryBySetting objectAtIndex:j];
            NSString *cate = [dict objectForKey:@"name"];
            if ([cate rangeOfString:partCategory].location != NSNotFound)
            {
                NSString *productsStr = [dict objectForKey:@"products"];
                NSArray *nos = [productsStr componentsSeparatedByString:@","];
                NSArray *info = [instance getInfoWithNos:nos];
                return info;
            }
        }
        return array;
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        NSUInteger count = self.productArray.count;
        for (int i=0; i<count; i++)
        {
            NSDictionary *dict = [self.productArray objectAtIndex:i];
            NSString *cate = [dict objectForKey:kInfoCategory];
            if ([cate rangeOfString:partCategory].location != NSNotFound)
            {
                [array addObject:dict];
            }
        }
        return array;
    }
}
- (NSArray *)getInfoWithNosString:(NSString *)nosString
{
    NSArray *nos = [nosString componentsSeparatedByString:@","];
    return [self getInfoWithNos:nos];
}
- (NSArray *)getInfoWithNos:(NSArray *)nos
{
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger count = self.productArray.count;
    NSUInteger noCount = nos.count;
    for (int i=0; i<noCount; i++)
    {
        NSString *trueNo = [nos objectAtIndex:i];
        for (int j=0; j<count; j++)
        {
            NSDictionary *dict = [self.productArray objectAtIndex:j];
            id no = [dict objectForKey:kInfoNo];
            if ([no isKindOfClass:[NSNumber class]])
            {
                no = [NSString stringWithFormat:@"%@", no];
            }
            if ([trueNo isEqualToString:no])
            {
                [array addObject:dict];
                break;
            }
        }
    }
    return array;
}
- (NSArray *)getArrayWithPartName:(NSString *)partName
{
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger count = self.productArray.count;
    for (int i=0; i<count; i++)
    {
        NSDictionary *dict = [self.productArray objectAtIndex:i];
        NSString *name = [dict objectForKey:kInfoName];
        NSString *band = [dict objectForKey:kInfoBand];
        NSString *cate = [dict objectForKey:kInfoCategory];
        NSString *dependency = [dict objectForKey:kInfoDependency];
//        NSString *remarks = [dict objectForKey:kInfoRemarks];
        if ([name rangeOfString:partName].location!=NSNotFound
            ||[band rangeOfString:partName].location!=NSNotFound
            ||[dependency rangeOfString:partName].location!=NSNotFound
//            ||[remarks rangeOfString:partName].location!=NSNotFound
            ||[cate rangeOfString:partName].location!=NSNotFound)
        {
            [array addObject:dict];
        }
    }
    return array;
}
- (void)initPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSArray *array = @[[NSString stringWithFormat:@"%@/ImgTurn", docPath], [NSString stringWithFormat:@"%@/movie", docPath], [NSString stringWithFormat:@"%@/ProductInfo", docPath], [NSString stringWithFormat:@"%@/tmp", docPath]];
    NSError *error = nil;
    NSUInteger count = array.count;
    for (int i=0; i<count; i++)
    {
        NSString *strTmp = [array objectAtIndex:i];
        error = nil;
        if (![fm fileExistsAtPath:strTmp])
        {
            [fm createDirectoryAtPath:strTmp withIntermediateDirectories:YES attributes:nil error:&error];
            if (error) {
                NSLog(@"创建目录%@失败，错误信息:%@", strTmp, error);
            }
        }
    }
}
- (NSNumber *)getProductVersion
{
    NSNumber *pv = nil;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:@"version.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path])
    {
        NSDictionary *dict = @{@"version": @(0), @"hasLoadImg": @(NO), @"hasLoadMovie": @(NO)};
        BOOL b = [dict writeToFile:path atomically:YES];
        if (!b) {
            NSLog(@"创建版本文件失败...");
        }
        else
        {
            pv = @(0);
        }
    }
    else
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        pv = [dict objectForKey:@"version"];
    }
    return pv;
}

- (void)initDisplay
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        self.productSetting = [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"setting.plist"]];
    }
    if (self.productSetting == nil)
    {
        return;
    }
    NSString *hot = [self.productSetting objectForKey:hotString];
    self.hotProducts = [hot componentsSeparatedByString:@","];
    NSDictionary *displayItems = [self.productSetting objectForKey:displayString];
    NSString *en = [displayItems objectForKey:@"en"];
    NSString *cn = [displayItems objectForKey:@"cn"];
    NSArray *enArray = [en componentsSeparatedByString:@","];
    NSArray *cnArray = [cn componentsSeparatedByString:@","];
    self.displayItems = @[enArray, cnArray];
    
    self.categoryBySetting = [self.productSetting objectForKey:categoryString];
//    self.movieBySetting = [self.productSetting objectForKey:movieString];
}
- (void)initImgTurnArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ImgTurn"]];
    NSString *fileName = @"img";
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSArray *tmpArray = [NSArray arrayWithContentsOfFile:[path stringByAppendingPathComponent:@"setting.plist"]];
        for (int i=0; i<tmpArray.count; i++)
        {
            NSMutableDictionary *dict = [[tmpArray objectAtIndex:i] mutableCopy];
            NSString *imgPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%d.png", fileName, i+1]];
            [dict setObject:imgPath forKey:kImgTurnImg];
            NSString *mapping_id = [dict objectForKey:@"mapping_id"];
            // unused
            (void )mapping_id;
            NSString *mapping_type = [dict objectForKey:@"mapping_type"];
            if ([mapping_type isEqualToString:@"brand"])
            {
                ;
            }
            [array addObject:dict];
        }
    }
    self.imgTurnArray = [NSArray arrayWithArray:array];
}
- (void)initProductArray
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSString *proPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ProductInfo"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileNames = [fm contentsOfDirectoryAtPath:proPath error:&error];
    if (error || !fileNames)
    {
        NSLog(@"初始化产品数组出错：%@", error);
    }
    if (!self.limitObjectIds) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/keywordmap.plist"];
        NSDictionary *keywordMapDict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray *keywordMapArray = [keywordMapDict allValues];
        self.limitObjectIds = [NSMutableArray array];
        for (NSDictionary *dict in keywordMapArray) {
            NSNumber *keywordId = [dict objectForKey:@"keyword_id"];
            NSNumber *productId = [dict objectForKey:@"object_id"];
            if (LimitKeywordId == LimitKeywordIdNo) {
                [self.limitObjectIds addObject:productId];
            } else if ([keywordId intValue] == LimitKeywordId) {
                [self.limitObjectIds addObject:productId];
            }
        }
    }
    
    for (int i=0; i<fileNames.count; i++)
    {
        NSString *subPath = [fileNames objectAtIndex:i];
        // 从文件列表中去掉不在限制中的元素
        if (self.limitObjectIds) {
            NSNumber *num = [NSNumber numberWithInt:[subPath intValue]];
            if (![self.limitObjectIds containsObject:num]) {
                continue;
            }
        }
        if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@/%@/info.plist", proPath, subPath]])
        {
            NSString *path = [NSString stringWithFormat:@"%@/%@", proPath, subPath];
            NSString *iconName = [path stringByAppendingPathComponent:@"icon.jpg"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:iconName])
            {
                iconName = [path stringByAppendingPathComponent:@"icon.png"];
            }
            NSString *detailName = [path stringByAppendingPathComponent:@"detail.jpg"];
            if (![[NSFileManager defaultManager] fileExistsAtPath:detailName])
            {
                detailName = [path stringByAppendingPathComponent:@"detail.png"];
            }
            if (![[NSFileManager defaultManager] fileExistsAtPath:detailName])
            {
                if ([fm fileExistsAtPath:[path stringByAppendingPathComponent:@"detail.plist"]])
                {
                    detailName = @"下载";
                }
                else
                {
                    detailName = @"暂无图片";
                }
            }
            NSMutableDictionary *info = [NSMutableDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"info.plist"]];
            [info setObject:iconName forKey:kInfoIconName];
            [info setObject:detailName forKey:kInfoDetailName];
            // movie
            NSString *movieName = nil;
            if ([fm fileExistsAtPath:[NSString stringWithFormat:@"%@/movie.plist", path]])
            {
                movieName = @"介绍视频";
                [info setObject:movieName forKey:kInfoMovieName];
            }
//            NSString *no = [NSString stringWithFormat:@"%@%03d", productName, i];
//            [info setObject:no forKey:kInfoNo];
            NSString *no = [NSString stringWithFormat:@"%@", [info objectForKey:kInfoNo]];
            NSString *category = @"";
            NSUInteger innerCount = self.categoryBySetting.count;
            for (int j=0; j<innerCount; j++)
            {
                NSDictionary *dict = [self.categoryBySetting objectAtIndex:j];
                NSArray *array = [[dict objectForKey:@"products"] componentsSeparatedByString:@","];
                if ([array indexOfObject:no] != NSNotFound)
                {
                    if ([category isEqualToString:@""])
                    {
                        category = [dict objectForKey:@"name"];
                    }
                    else
                    {
                        category = [NSString stringWithFormat:@"%@,%@", category, [dict objectForKey:@"name"]];
                    }
                }
            }
            [info setObject:category forKey:kInfoCategory];
            
            //            NSString *band = [info objectForKey:kInfoBand];
            //            NSUInteger movieCount = self.movieBySetting.count;
            //            for (int j=0; j<movieCount; j++)
            //            {
            //                NSDictionary *dict = [self.movieBySetting objectAtIndex:j];
            //                NSString *innerBand = [dict objectForKey:kInfoBand];
            //                if ([innerBand isEqualToString:band])
            //                {
            //                    NSString *movieName = [dict objectForKey:kInfoMovieName];
            //                    NSString *fullMovieName = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/movie/%@", movieName]];
            //                    [info setObject:fullMovieName forKey:kInfoMovieName];
            //                }
            //            }
            // 已经有了no
            //            [info setObject:[NSString stringWithFormat:@"%@%03d", productName, i] forKey:@"id"];
            [array addObject:info];
        }
    }
    // JSJP001
    NSString *productName = @"JSJP";
    for (int i=1; i<200; i++)
    {
        NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *path = [docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProductInfo/%@%03d", productName, i]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            
        }
    }
    self.productArray = [NSArray arrayWithArray:array];
}
- (void)initCategory
{
    if (self.categoryBySetting)
    {
        NSArray *cate = self.categoryBySetting;
        NSUInteger count = cate.count;
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<count; i++)
        {
            NSDictionary *dict = [self.categoryBySetting objectAtIndex:i];
            NSString *name = [dict objectForKey:@"name"];
            [array addObject:name];
        }
        self.categories = [NSArray arrayWithArray:array];
    }
    else
    {
        NSUInteger count = self.productArray.count;
        NSMutableArray *array = [NSMutableArray array];
        for (int i=0; i<count; i++)
        {
            NSDictionary *dict = [self.productArray objectAtIndex:i];
            NSString *category = [dict objectForKey:kInfoCategory];
            if ([array indexOfObject:category] == NSNotFound)
            {
                [array addObject:category];
            }
        }
        self.categories = [NSArray arrayWithArray:array];
    }
}
- (void)initBands
{
    NSUInteger count = self.productArray.count;
    NSMutableArray *array = [NSMutableArray array];
    for (int i=0; i<count; i++)
    {
        NSDictionary *dict = [self.productArray objectAtIndex:i];
        NSString *band = [dict objectForKey:kInfoBand];
        if ([array indexOfObject:band] == NSNotFound)
        {
            [array addObject:band];
        }
    }
    self.bands = [NSArray arrayWithArray:array];
}

- (NSArray *)getArrayWithPrice:(NSString *)price
{
    if ([price isEqualToString:@"所有"])
    {
        return self.productArray;
    }
    else
    {
        
        NSMutableArray *result = [NSMutableArray array];
        NSUInteger count = self.productArray.count;
        if ([price isEqualToString:@"2万以上"])
        {
            for (int i=0; i<count; i++)
            {
                NSDictionary *info = [self.productArray objectAtIndex:i];
                NSString *price = [info objectForKey:kInfoPrice];
                NSInteger iPrice = [price intValue];
                if (iPrice >= 20000)
                {
                    [result addObject:info];
                }
            }
        }
        else
        {
            NSArray *prices = [price componentsSeparatedByString:@"~"];
            NSInteger iPrice1 = [[prices objectAtIndex:0] intValue];
            NSInteger iPrice2 = [[prices objectAtIndex:1] intValue];
            for (int i=0; i<count; i++)
            {
                NSDictionary *info = [self.productArray objectAtIndex:i];
                NSString *price = [info objectForKey:kInfoPrice];
                NSInteger iPrice = [price intValue];
                if (iPrice >= iPrice1 && iPrice <= iPrice2)
                {
                    [result addObject:info];
                }
            }
        }
        return result;
    }
}

+ (BOOL)getEnableBgDownload
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"EnableBgDownload"];
}
+ (void)setEnableBgDownload:(BOOL)enable
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:@(enable) forKey:@"EnableBgDownload"];
    [ud synchronize];
}


@end
