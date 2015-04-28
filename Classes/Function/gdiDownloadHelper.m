//
//  gdiDownloadHelper.m
//  GDiPhone
//
//  Created by YuDa on 14-11-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiDownloadHelper.h"


@interface gdiDownloadHelper ()
@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSMutableArray *needDownloadIcons;
@property (strong, nonatomic) NSMutableArray *needDownloadDetails;
@property (strong, nonatomic) NSMutableArray *needDownloadMovies;
@property (strong, nonatomic) NSMutableArray *needDownloadImgTurns;

@property (strong, nonatomic) NSNumber *version;
@property (strong, nonatomic) NSNumber *tmpVersion;
@end

@implementation gdiDownloadHelper
static gdiDownloadHelper *instance = nil;

+ (id)getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
            instance.host = @"114.113.113.60:8080";
            instance.link = @"aagpm/rpc/Synchronize/download_product";
            instance.token = @"2f2ec84ae0d72590cacdccc52e814422";
        }
    }
    return instance;
}

- (BOOL)getProductInfoWithVersion:(NSNumber *)pv
{
    NSString *urlString = nil;
    int productVersion = [pv intValue];
    self.tmpVersion = pv;
    urlString = [NSString stringWithFormat:@"http://%@/%@?token=%@&productversion=%d", self.host, self.link, self.token, productVersion];
    
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:5.0]; // 设置超时
    
    self.receivedData = [[NSMutableData alloc] init];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection == nil) {
        // 创建失败
        NSLog(@"创建链接失败...");
        return NO;
    }
    return YES;
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"receive the response");
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"allHeaderFields: %@",dictionary);
    }
    [self.receivedData setLength:0];
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"get some data");
    [self.receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSString *results = [[NSString alloc]
//                         initWithBytes:[self.receivedData bytes]
//                         length:[self.receivedData length]
//                         encoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.receivedData options:NSJSONReadingMutableContainers error:nil];
    // 将数据放到文件中
    NSNumber *errorNum = [dict objectForKey:@"error"];
    NSString *msg = [dict objectForKey:@"message"];
    if (errorNum.intValue != 0 || (![msg isEqualToString:@"成功"]))
    {
        NSLog(@"error:%@", errorNum);
    }
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *proPath = [docPath stringByAppendingPathComponent:@"ProductInfo"];
//    NSNumber *version = [dict objectForKey:@"productversion"];
//    NSString *versionPath = [docPath stringByAppendingPathComponent:@"version.plist"];
    self.version = [dict objectForKey:@"productversion"];
    if ([self.version integerValue] > [self.tmpVersion integerValue])
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        // keyword
        NSString *keywordPath = [docPath stringByAppendingPathComponent:@"udkeyword.plist"];
        NSMutableDictionary *keywordDict = nil;
        if (![fm fileExistsAtPath:keywordPath]) {
            //        [fm createFileAtPath:keywordPath contents:nil attributes:nil];
            keywordDict = [NSMutableDictionary dictionary];
        }
        else
        {
            keywordDict = [[NSDictionary dictionaryWithContentsOfFile:keywordPath] mutableCopy];
        }
        NSString *keywordTypePath = [docPath stringByAppendingPathComponent:@"keywordtype.plist"];
        NSMutableDictionary *keywordTypeDict = nil;
        if (![fm fileExistsAtPath:keywordTypePath]) {
            //        [fm createFileAtPath:prokeywordPath contents:nil attributes:nil];
            keywordTypeDict = [NSMutableDictionary dictionary];
        }
        else
        {
            keywordTypeDict = [[NSDictionary dictionaryWithContentsOfFile:keywordTypePath] mutableCopy];
        }
        NSString *keywordMapPath = [docPath stringByAppendingPathComponent:@"keywordmap.plist"];
        NSMutableDictionary *keywordmapDict = nil;
        if (![fm fileExistsAtPath:keywordMapPath])
        {
            keywordmapDict = [NSMutableDictionary dictionary];
        }
        else
        {
            keywordmapDict = [[NSDictionary dictionaryWithContentsOfFile:keywordMapPath] mutableCopy];
        }
        
        
        NSArray *dataArray = [dict objectForKey:@"data"];
        NSMutableArray *tableNames = [[NSMutableArray alloc] init];
        for (int i=0; i<dataArray.count; i++)
        {
            NSDictionary *dict1 = (NSDictionary *)[dataArray objectAtIndex:i];
            NSDictionary *dict2 = [dict1 objectForKey:@"data"];
            NSString *tableName = [dict1 objectForKey:@"table_name"];
            if (![tableNames containsObject:tableName] && dict2)
            {
                [tableNames addObject:tableName];
                NSLog(@"%@", tableName);
                NSLog(@"%@", dict2);
            }
            if ([tableName isEqualToString:TABLE_NAME_PRODUCT]) //产品详细信息
            {
                NSNumber *Id = dict2[@"id"];
                // 两种方法判断
                if ([Id isKindOfClass:[NSNull class]] || !Id)
                {
                    continue;
                }
                NSString *productPath = [proPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", Id]];
                NSString *infoPath = [productPath stringByAppendingPathComponent:@"info.plist"];
                if (![fm fileExistsAtPath:productPath]) {
                    [fm createDirectoryAtPath:productPath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                BOOL b = [dict2 writeToFile:infoPath atomically:YES];
                if (!b) {
                    //                NSLog(@"%@的信息中含有NULL，用字符串\"NULL\"替换.", Id);
                    NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                    [mDict writeToFile:infoPath atomically:YES];
                }
            }
            else if ([tableName isEqualToString:TABLE_NAME_FILE])
            {
                NSNumber *Id = dict2[@"id"];
                NSNumber *proId = dict2[@"product_id"];
                // 两种方法判断
                if ([Id isKindOfClass:[NSNull class]] || !Id)
                {
                    continue;
                }
                NSString *productPath = [proPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", proId]];
                NSString *infoPath = nil;
                NSString *fileName = dict2[@"file_name"];
                if (fileName)
                {
                    NSString *sub = [fileName substringToIndex:4];
                    if ([sub isEqualToString:@"icon"])  // icon
                    {
                        infoPath = [productPath stringByAppendingPathComponent:@"icon.plist"];
                        
                        NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                        NSArray *keys = [mDict allKeys];
                        UNUSED(keys);
                        [mDict writeToFile:infoPath atomically:YES];
                    }
                    else if ([sub isEqualToString:@"deta"]) //detail
                    {
                        infoPath = [productPath stringByAppendingPathComponent:@"detail.plist"];
                        NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                        [mDict writeToFile:infoPath atomically:YES];
                    }
                    else    // movie
                    {
                        infoPath = [productPath stringByAppendingPathComponent:@"movie.plist"];
                        NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                        [mDict writeToFile:infoPath atomically:YES];
                    }
                }
            }
            else if ([tableName isEqualToString:TABLE_NAME_KEYWORD])
            {
                // NSDictonary里不能有null
                NSNumber *Id = dict2[@"id"];
                if (!Id || [Id isKindOfClass:[NSNull class]])
                {
                    continue;
                }
                NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                NSString *strID = [NSString stringWithFormat:@"%@", Id];
                [keywordDict setObject:mDict forKey:strID];
            }
            else if ([tableName isEqualToString:TABLE_NAME_KEYWORD_TYPE])
            {
                // nsnumber不能当key
                NSNumber *Id = dict2[@"id"];
                if (!Id || [Id isKindOfClass:[NSNull class]])
                {
                    continue;
                }
                NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                NSString *strID = [NSString stringWithFormat:@"%@", Id];
                [keywordTypeDict setObject:mDict forKey:strID];
            }
            else if ([tableName isEqualToString:TABLE_NAME_KEYWORD_MAPPING])
            {
                NSNumber *Id = dict2[@"id"];
                if (!Id || [Id isKindOfClass:[NSNull class]])
                {
                    continue;
                }
                NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                NSString *strID = [NSString stringWithFormat:@"%@", Id];
                [keywordmapDict setObject:mDict forKey:strID];
            }
            else if ([tableName isEqualToString:TABLE_NAME_CAROUSEL_IMAGE])
            {
                NSString *imgTurnPath = [docPath stringByAppendingPathComponent:@"ImgTurn"];
                NSString *fileName = [dict2 objectForKey:@"file_name"];
                if (fileName && [fileName hasPrefix:@"img"])
                {
                    NSString *name = [fileName componentsSeparatedByString:@"."][0];
                    NSString *path = [imgTurnPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
                    NSMutableDictionary *mDict = [self changeDictionaryIfNull:dict2];
                    [mDict writeToFile:path atomically:YES];
                }
            }
        }
        // save keyword
        BOOL b = [keywordDict writeToFile:keywordPath atomically:YES];
        if (!b) {
            NSLog(@"keyword save fail.");
            NSLog(@"keywordpath is %@", keywordPath);
        }
        NSLog(@"prokeyword:%@", keywordTypeDict);
        b = [keywordTypeDict writeToFile:keywordTypePath atomically:YES];
        if (!b) {
            NSLog(@"prokeyword save fail.");
        }
        b = [keywordmapDict writeToFile:keywordMapPath atomically:YES];
        if (!b) {
            NSLog(@"keyword map save fail.");
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadIcon) name:kNotiDownloadIconOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadDetail) name:kNotiDownloadDetailOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadMovie) name:kNotiDownloadMovieOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadImgTurn) name:kNotiDownloadImgOver object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:kNotiDownloadAllIconOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:kNotiDownloadAllDetailOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:kNotiDownloadAllMovieOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downLoadFinish:) name:kNotiDownloadAllImgOver object:nil];
    if ([self.version integerValue] > [self.tmpVersion integerValue])
    {
        [self updateSetting];
    }
    
    [self initNeedDownloadFile];
    self.receivedData = nil;
}
- (void)updateSetting
{
    [self updateProSetting];
    [self updateImgTurnSetting];
}
- (void)updateVersion
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [docPath stringByAppendingPathComponent:@"version.plist"];
    NSFileManager *fm = [NSFileManager defaultManager];
    UNUSED(fm);
//    if (![fm fileExistsAtPath:path])
//    {
//        NSDictionary *dict = @{@"version": @(0), @"hasLoadImg": @(NO), @"hasLoadMovie": @(NO)};
//        BOOL b = [dict writeToFile:path atomically:YES];
//        if (!b) {
//            NSLog(@"创建版本文件失败...");
//        }
//    }
//    else
//    {
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
//        [dict setObject:self.version forKey:@"version"];
//        BOOL b = [dict writeToFile:path atomically:YES];
//        if (!b) {
//            NSLog(@"写入版本文件失败...");
//        }
//    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    self.version = self.version ? self.version : @(0);
    [dict setObject:self.version forKey:@"version"];
    BOOL b = [dict writeToFile:path atomically:YES];
    if (!b) {
        NSLog(@"写入版本文件失败...");
    }
}
// ProductInfo中的setting文件，包括keyword，displayItem
- (void)updateProSetting
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *keywordMapPath = [docPath stringByAppendingPathComponent:@"keywordmap.plist"];
    NSDictionary *keywordMapDict = [NSDictionary dictionaryWithContentsOfFile:keywordMapPath];
    NSArray *keywordMapArray = [keywordMapDict allValues];
    
    // udkeyword.plist
    NSString *udkeywordPath = [docPath stringByAppendingPathComponent:@"udkeyword.plist"];
    NSDictionary *udkeywordDict = [NSDictionary dictionaryWithContentsOfFile:udkeywordPath];
    NSMutableArray *categoryArrays = [NSMutableArray array];
    NSArray *udkeywords = [udkeywordDict allValues];
    for (NSDictionary *dict in udkeywords) {
        NSString *type_code = [dict objectForKey:kKeywordTypeCode];
        BOOL isValid = [[dict objectForKey:kKeywordValid] boolValue];
        if ([type_code isEqualToString:kKeywordTypeProductLargeCategory] && isValid) {
            NSNumber *numID = [dict objectForKey:kKeywordId];
            [categoryArrays addObject:numID];
        }
    }
    
    NSString *settingPath = [docPath stringByAppendingPathComponent:@"ProductInfo/setting.plist"];
    NSMutableDictionary *setting = [NSMutableDictionary dictionaryWithContentsOfFile:settingPath];
    NSMutableArray *map = nil;
    if (!setting)
    {
        setting = [[NSMutableDictionary alloc] init];
        map = [[NSMutableArray alloc] init];
        
        NSDictionary *displayItems = @{@"cn": @"名称,品牌,编号,价格,特点", @"en": [NSString stringWithFormat:@"%@,%@,%@,%@,%@", kInfoName, kInfoBand, kInfoCode, kInfoPrice, kInfoFeature]};
        [setting setObject:displayItems forKey:@"displayItems"];
    }
    else
    {
        map = [setting objectForKey:@"keyword"];
    }
    // Changed 限制数组，限制产品的显示 如惠通项目、正通项目
    NSMutableArray *limitObjectIds = [NSMutableArray array];
    for (NSDictionary *dict in keywordMapArray) {
        NSNumber *keywordId = [dict objectForKey:@"keyword_id"];
        NSNumber *productId = [dict objectForKey:@"object_id"];
        if (LimitKeywordId == LimitKeywordIdNo) {
            [limitObjectIds addObject:productId];
        } else if ([keywordId intValue] == LimitKeywordId) {
            [limitObjectIds addObject:productId];
        }
    }
    [[gdiSingleton getInstance] setLimitObjectIds:[limitObjectIds copy]];
    for (NSDictionary *dict in keywordMapArray)
    {
        NSString *keywordName = [dict objectForKey:@"keyword_name"];
        NSNumber *keywordId = [dict objectForKey:@"keyword_id"];
        NSNumber *productId = [dict objectForKey:@"object_id"];
        if (![categoryArrays containsObject:keywordId]) {
            continue;
        }
        BOOL has = NO;
        for (int i=0; i<map.count; i++)
        {
            NSMutableDictionary *mapDict = map[i];
            if ([[mapDict objectForKey:@"name"] isEqualToString:keywordName])
            {
                NSString *pro = [mapDict objectForKey:@"products"];
                if (pro)
                {
                    if ([pro rangeOfString:[NSString stringWithFormat:@"%@", productId]].location == NSNotFound)
                    {
                        pro = [NSString stringWithFormat:@"%@,%@", pro, productId];
                    }
                }
                else
                {
                    pro = [NSString stringWithFormat:@"%@", productId];
                }
                [mapDict setObject:pro forKey:@"products"];
                
                has = YES;
            }
        }
        if (!has)
        {
            if (![limitObjectIds containsObject:productId]) {
                continue;
            }
            NSMutableDictionary *mapDict = [[NSMutableDictionary alloc] init];
            [mapDict setObject:keywordName forKey:@"name"];
            [mapDict setObject:[NSString stringWithFormat:@"%@", productId] forKey:@"products"];
            [map addObject:mapDict];
        }
    }
    [setting setObject:map forKey:@"keyword"];
    [setting writeToFile:settingPath atomically:YES];
}
// 更新图片轮播配置
- (void)updateImgTurnSetting
{
    NSString *imgTurnPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImgTurn"];
    NSString *settingPath = [imgTurnPath stringByAppendingPathComponent:@"setting.plist"];
    NSMutableArray *setting = [[NSMutableArray alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fm contentsOfDirectoryAtPath:imgTurnPath error:&error];
    if (!files || error)
    {
        NSLog(@"更新图片轮播配置出错:%@", error);
    }
    for (int i=0; i<files.count; i++)
    {
        NSString *fileName = [files objectAtIndex:i];
        if ([fileName hasSuffix:@"plist"])
        {
            NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", imgTurnPath, fileName]];
            NSString *mapping_id = [NSString stringWithFormat:@"%@", dict[@"mapping_id"]];
            NSString *mapping_type = dict[@"mapping_type"];
            if (!mapping_type) {
                continue;
            }
            
            NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] init];
            [settingDict setObject:mapping_type forKey:@"mapping_type"];
            [settingDict setObject:mapping_id forKey:@"mapping_id"];
            [setting addObject:settingDict];
        }
    }
    [setting writeToFile:settingPath atomically:YES];
}

- (void)initNeedDownloadFile
{
    self.needDownloadIcons = [[NSMutableArray alloc] init];
    self.needDownloadDetails = [[NSMutableArray alloc] init];
    self.needDownloadMovies = [[NSMutableArray alloc] init];
    NSString *proPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ProductInfo"];
    NSString *path = proPath;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *array = [fm contentsOfDirectoryAtPath:proPath error:&error];
    if (!array || error)
    {
        NSLog(@"查看产品目录失败：%@", error);
    }
    NSUInteger count = array.count;
    for (int i=0; i<count; i++)
    {
        NSString *subPath = [array objectAtIndex:i];
        path = [NSString stringWithFormat:@"%@/%@", proPath, subPath];
        error = nil;
        NSDictionary *attr = [fm attributesOfItemAtPath:path error:&error];
        NSString *type = [attr objectForKey:NSFileType];
        if ([type isEqualToString:NSFileTypeDirectory])
        {
            error = nil;
            NSArray *subArray = [fm contentsOfDirectoryAtPath:path error:&error];
            if (!subArray || error)
            {
                NSLog(@"产看产品子目录%@失败：%@", subPath, error);
            }
            NSUInteger subCount = subArray.count;
            for (int j=0; j<subCount; j++)
            {
                NSString *filePath = [subArray objectAtIndex:j];
                if ([filePath hasSuffix:@"plist"])
                {
                    if ([filePath isEqualToString:@"icon.plist"])
                    {
                        if ([subArray containsObject:@"icon.jpg"])
                        {
                            continue;
                        }
                        [self.needDownloadIcons addObject:subPath];
                    }
                    else if ([filePath isEqualToString:@"detail.plist"])
                    {
                        if ([subArray containsObject:@"detail.jpg"])
                        {
                            continue;
                        }
                        [self.needDownloadDetails addObject:subPath];
                    }
                    else if ([filePath isEqualToString:@"movie.plist"])
                    {
                        if ([subArray containsObject:@"movie.jpg"])
                        {
                            continue;
                        }
                        [self.needDownloadMovies addObject:subPath];
                    }
                }
            }
        }
    }
    self.needDownloadImgTurns = [[NSMutableArray alloc] init];
    NSString *imgTurnPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImgTurn"];
    error = nil;
    NSArray *imgTurnArray = [fm contentsOfDirectoryAtPath:imgTurnPath error:&error];
    if (!array || error)
    {
        NSLog(@"查看图片轮播目录失败：%@", error);
    }
    count = imgTurnArray.count;
    for (int i=0; i<count; i++)
    {
        NSString *subPath = [imgTurnArray objectAtIndex:i];
        if ([subPath hasSuffix:@"plist"] && [subPath hasPrefix:@"img"])
        {
            NSString *name = [subPath componentsSeparatedByString:@"."][0];
            if ([imgTurnArray containsObject:[NSString stringWithFormat:@"%@.jpg", name]] || [imgTurnArray containsObject:[NSString stringWithFormat:@"%@.png", name]])
            {
                continue;
            }
            [self.needDownloadIcons addObject:subPath];
            [self.needDownloadImgTurns addObject:[NSString stringWithFormat:@"%@/%@", imgTurnPath, subPath]];
        }
    }
    [self updateVersion];
    [self initResourceCount];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiInitNeedDownloadOver object:nil];
    [self downLoadAll];
}

- (void)initResourceCount
{
    self.imgCount = self.needDownloadImgTurns.count;
    self.iconCount = self.needDownloadIcons.count;
    self.detailCount = self.needDownloadDetails.count;
    self.movieCount = self.needDownloadMovies.count;
}

- (void)downLoadAll
{
//    [self downLoadIcon];
//    [self downLoadDetail];
//    [self downLoadMovie];
    // 分批下载，图片轮播->icon
    [self downLoadImgTurn];
}
- (void)downLoadIcon
{
    if (self.needDownloadIcons.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadAllIconOver object:nil];
    }
    else
    {
        NSString *proPath = [self.needDownloadIcons firstObject];
        gdiDownloadIcon *icon = [[gdiDownloadIcon alloc] init];
        [icon downLoadIconWithProId:@([proPath intValue])];
        [self.needDownloadIcons removeObject:proPath];
    }
}

- (void)downLoadDetail
{
    // 后台下载
    if (![gdiSingleton getEnableBgDownload]) return;
    if (self.needDownloadDetails.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadAllDetailOver object:nil];
    }
    else
    {
        NSString *proPath = [self.needDownloadDetails firstObject];
        gdiDownloadDetail *detail = [[gdiDownloadDetail alloc] init];
        [detail downLoadDetailWithProId:@([proPath intValue])];
        [self.needDownloadDetails removeObject:proPath];
    }
}
- (void)downLoadMovie
{
    if (![gdiSingleton getEnableBgDownload]) return;
    if (self.needDownloadMovies.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadAllMovieOver object:nil];
    }
    else
    {
        NSString *proPath = [self.needDownloadMovies firstObject];
        gdiDownloadMovie *detail = [[gdiDownloadMovie alloc] init];
        [detail downLoadMovieWithProId:@([proPath intValue])];
        [self.needDownloadMovies removeObject:proPath];
    }
}
- (void)downLoadImgTurn
{
    if (self.needDownloadImgTurns.count == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadAllImgOver object:nil];
    }
    else
    {
        NSString *imgPath = [self.needDownloadImgTurns firstObject];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:imgPath];
        NSNumber *Id = [dict objectForKey:@"id"];
        NSString *name = [dict objectForKey:@"file_name"];
        gdiDownloadImgTurn *detail = [[gdiDownloadImgTurn alloc] init];
        [detail downLoadImgTurnWithId:Id name:name];
        [self.needDownloadImgTurns removeObject:imgPath];
    }
}

- (void)downLoadFinish:(NSNotification *)noti
{
    int num = 2;
    static int count = 0;
    count++;
    if (count >= num) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadDataOver object:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载数据失败，请检查网络..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }
    if ([noti.name isEqualToString:kNotiDownloadAllImgOver])
    {
        [self downLoadIcon];
    }
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"下载失败，请确定网络连接之后重新打开"];
    [tip showAndAutoRemove];
    self.receivedData = nil;
    NSLog(@"Connection failed: %@", error);
    [self getProductInfoWithVersion:self.tmpVersion];
}

- (NSMutableDictionary *)changeDictionaryIfNull:(NSDictionary *)dict
{
    NSMutableDictionary *ret = [dict mutableCopy];
    NSArray *keys = [ret allKeys];
    for (int i=0; i<keys.count; i++)
    {
        NSObject *key = [keys objectAtIndex:i];
        NSObject *value = [ret objectForKey:key];
        if (!value || [value isKindOfClass:[NSNull class]])
        {
            [ret setObject:@"NULL" forKey:(id<NSCopying>)key];
        }
    }
    return ret;
}

@end

@interface gdiDownloadIcon()
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *fileName;
@end
@implementation gdiDownloadIcon

- (void)downLoadIconWithProId:(NSNumber *)Id
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *proPath = [docPath stringByAppendingPathComponent:@"ProductInfo"];
    self.path = [proPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", Id]];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/icon.plist", self.path]];
    self.fileName = [dict objectForKey:@"file_name"];
    self.path = [NSString stringWithFormat:@"%@/%@", self.path, self.fileName];
    NSNumber *imgId = [dict objectForKey:@"id"];
    
    NSString *urlString = nil;
    gdiDownloadHelper *instance = [gdiDownloadHelper getInstance];
    NSString *token = instance.token;
    urlString = [NSString stringWithFormat:@"http://114.113.113.60:8080/aagpm/rpc/Synchronize/download_file?token=%@&id=%@", token, imgId];
    
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:5.0]; // 设置超时
    
    self.receivedData = [[NSMutableData alloc] init];
    
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.conn == nil) {
        // 创建失败
        NSLog(@"创建链接失败...");
    }
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"receive the response");
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"allHeaderFields: %@",dictionary);
    }
    [self.receivedData setLength:0];
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"get some data");
    [self.receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.receivedData writeToFile:self.path atomically:YES];
    self.receivedData = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadIconOver object:nil];
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"下载图标失败..."];
    [tip showAndAutoRemove];
    self.receivedData = nil;
    NSLog(@"Connection failed: %@", error);
}

@end

@interface gdiDownloadDetail()
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSNumber *Id;
@property BOOL hasEnd;
@property int count;
@end
@implementation gdiDownloadDetail

- (void)setHasEnd
{
    self.hasEnd = YES;
    [self.conn cancel];
}

- (void)downLoadDetailWithProId:(NSNumber *)Id
{
    self.Id = Id;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *proPath = [docPath stringByAppendingPathComponent:@"ProductInfo"];
    self.path = [proPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", Id]];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/detail.plist", self.path]];
    self.fileName = [dict objectForKey:@"file_name"];
    self.path = [NSString stringWithFormat:@"%@/%@", self.path, self.fileName];
    NSNumber *imgId = [dict objectForKey:@"id"];
    
    NSString *urlString = nil;
    gdiDownloadHelper *instance = [gdiDownloadHelper getInstance];
    NSString *token = instance.token;
    urlString = [NSString stringWithFormat:@"http://114.113.113.60:8080/aagpm/rpc/Synchronize/download_file?token=%@&id=%@", token, imgId];
    
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:5.0]; // 设置超时
    
    self.receivedData = [[NSMutableData alloc] init];
    
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.conn == nil) {
        // 创建失败
        NSLog(@"创建链接失败...");
    }
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.count = 0;
    NSLog(@"receive the response");
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"allHeaderFields: %@",dictionary);
    }
    [self.receivedData setLength:0];
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.hasEnd) {
        self.receivedData = nil;
        return;
    }
    [self.receivedData appendData:data];
    self.count++;
    if (self.count > 100)
    {
        NSLog(@"正在下载%@的图片", self.Id);
        self.count = 0;
        // 边下载边显示
        [self.receivedData writeToFile:self.path atomically:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadSomeDetailOver object:self.Id];
    }
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.receivedData writeToFile:self.path atomically:YES];
    self.receivedData = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadDetailOver object:self.Id];
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"下载详细图片失败..."];
    [tip showAndAutoRemove];
    self.receivedData = nil;
    NSLog(@"Connection failed: %@", error);
}

@end

@interface gdiDownloadMovie()
@property (strong, nonatomic) NSURLConnection *conn;
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSNumber *Id;
@property BOOL hasEnd;
@property int count;
@end
@implementation gdiDownloadMovie

- (void)setHasEnd
{
    self.hasEnd = YES;
    [self.conn cancel];
}

- (void)downLoadMovieWithProId:(NSNumber *)Id
{
    self.hasEnd = NO;
    self.Id = Id;
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *proPath = [docPath stringByAppendingPathComponent:@"ProductInfo"];
    self.path = [proPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", Id]];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/movie.plist", self.path]];
    self.fileName = [dict objectForKey:@"file_name"];
    self.path = [NSString stringWithFormat:@"%@/%@", self.path, self.fileName];
    NSNumber *imgId = [dict objectForKey:@"id"];
    
    NSString *urlString = nil;
    gdiDownloadHelper *instance = [gdiDownloadHelper getInstance];
    NSString *token = instance.token;
    urlString = [NSString stringWithFormat:@"http://114.113.113.60:8080/aagpm/rpc/Synchronize/download_file?token=%@&id=%@", token, imgId];
    
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:5.0]; // 设置超时
    
    self.receivedData = [[NSMutableData alloc] init];
    
    self.conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (self.conn == nil) {
        // 创建失败
        NSLog(@"创建链接失败...");
    }
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.count = 0;
    NSLog(@"receive the response");
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"allHeaderFields: %@",dictionary);
    }
    [self.receivedData setLength:0];
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.hasEnd) {
        self.receivedData = nil;
        return;
    }
    [self.receivedData appendData:data];
    self.count++;
    if (self.count > 100)
    {
        NSLog(@"正在下载%@的视频", self.Id);
        self.count = 0;
        [self.receivedData writeToFile:self.path atomically:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadSomeMovieOver object:self.Id];
    }
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.receivedData writeToFile:self.path atomically:YES];
    self.receivedData = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadMovieOver object:self.Id];
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"下载视频失败..."];
    [tip showAndAutoRemove];
    NSLog(@"Connection failed: %@", error);
    self.receivedData = nil;
}

@end

@interface gdiDownloadImgTurn()
@property (strong, nonatomic) NSMutableData *receivedData;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSString *fileName;
@end
@implementation gdiDownloadImgTurn

- (void)downLoadImgTurnWithId:(NSNumber *)Id name:(NSString *)name
{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imgTurnPath = [docPath stringByAppendingPathComponent:@"ImgTurn"];
    self.path = [NSString stringWithFormat:@"%@/%@", imgTurnPath, name];
    self.fileName = name;
    NSString *urlString = nil;
    gdiDownloadHelper *instance = [gdiDownloadHelper getInstance];
    NSString *token = instance.token;
    urlString = [NSString stringWithFormat:@"http://114.113.113.60:8080/aagpm/rpc/Synchronize/download_carousel_image?token=%@&id=%@", token, Id];
    
    // 初始化请求
    NSMutableURLRequest  *request = [[NSMutableURLRequest alloc] init];
    
    // 设置
    [request setURL:[NSURL URLWithString:urlString]];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy]; // 设置缓存策略
    [request setTimeoutInterval:5.0]; // 设置超时
    
    self.receivedData = [[NSMutableData alloc] init];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection == nil) {
        // 创建失败
        NSLog(@"创建链接失败...");
    }
}

// 收到回应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"receive the response");
    // 注意这里将NSURLResponse对象转换成NSHTTPURLResponse对象才能去
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [httpResponse allHeaderFields];
        NSLog(@"allHeaderFields: %@",dictionary);
    }
    [self.receivedData setLength:0];
}

// 接收数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSLog(@"get some data");
    [self.receivedData appendData:data];
}

// 数据接收完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.receivedData writeToFile:self.path atomically:YES];
    self.receivedData = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotiDownloadImgOver object:nil];
}

// 返回错误
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    gdiQuickTipView *tip = [[gdiQuickTipView alloc] initWithMessage:@"下载轮播图片失败..."];
    [tip showAndAutoRemove];
    self.receivedData = nil;
    NSLog(@"Connection failed: %@", error);
}

@end
