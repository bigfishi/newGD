//
//  gdiDetailViewController.m
//  GDiPhone
//
//  Created by YuDa on 14-9-21.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "gdiInfoViewController.h"
#import "LGPlayerViewController.h"
#import "gdiDownloadHelper.h"
#import "FileMD5Hash.h"
#import "LargeImageContainer.h"

@interface gdiDetailViewController ()
@property (nonatomic, strong) UIScrollView * sv;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) BOOL hasMovie;
@property (nonatomic) BOOL movieHasLoad;
@property (nonatomic, strong) UIView *showIfMovieHasLoad;
@property (nonatomic, strong) gdiDownloadDetail *dd;
@property (nonatomic, strong) gdiDownloadMovie *dm;


@property (nonatomic, strong) UIActivityIndicatorView *detailImgJuhua;
@property (nonatomic, strong) LargeImageContainer *largeImage;
@property float detailTmpHeight;

@property BOOL hasEnd;
@end

static CGPoint origin = {0, 0};
@implementation gdiDetailViewController

- (id)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.info = info;
        NSString *movieName = [self.info objectForKey:kInfoMovieName];
        if (movieName != nil)
        {
            self.hasMovie = YES;
        }
    }
    return self;
}

- (void)changeInfo:(NSDictionary *)info
{
    self.info = info;
    self.hasEnd = NO;
    NSString *movieName = [self.info objectForKey:kInfoMovieName];
    if (movieName != nil)
    {
        self.hasMovie = YES;
        // !!
//        [self.fuckPlayer.view removeFromSuperview];
        self.fuckPlayer = [[LGPlayerViewController alloc] init];
    }
    else
    {
        self.hasMovie = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    CGPoint offset = self.baseScroll.contentOffset;
    offset.y = 0;
    self.hasEnd = YES;
    [self.baseScroll setContentOffset:offset animated:NO];
    [self.upView removeFromSuperview];
//    self.upView = nil;
    [self.downView removeFromSuperview];
//    self.downView = nil;
//    [self.largeImage removeFromSuperview];
//    self.largeImage = nil;
    if (self.hasMovie)
    {
        [self.fuckPlayer endMovie];
//        [self.fuckPlayer.view removeFromSuperview];
        // !!!
//        [self.fuckPlayer removeFromParentViewController];
        self.fuckPlayer = nil;
    }
    // 删除detail文件
    NSError *error = nil;
    NSString *path = [gdiSingleton getAppPath];
    NSString *tmpStr = [[self.detailPath componentsSeparatedByString:@"/"] lastObject];
    path = [NSString stringWithFormat:@"%@/jiemi%@", path, tmpStr];
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    if (error)
    {
        NSLog(@"error in function %s: %@", __FUNCTION__, error);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadSomeDetailOver object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadDetailOver object:nil];
    [self.dm setHasEnd];
    self.dm = nil;
    [self.dd setHasEnd];
    self.dd = nil;
    NSLog(@"%s end", __FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}
// Changed 之前这段代码是在viewDidAppear中的，因为会造成没有movie的页面刚开始也会有movie显示出来，之后才隐藏，所以放到viewWillAppear中了。
// 可能会造成卡顿
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [self.info objectForKey:kInfoName];
    self.iconPath = [self.info objectForKey:kInfoIconName];
    self.detailPath = [self.info objectForKey:kInfoDetailName];
    self.name = [self.info objectForKey:kInfoName];
    
    CGFloat padding = 10;
    origin.y = padding;
    origin.y += [self addUpView:self.baseScroll origin:origin];
    if (self.hasMovie)
    {
        origin.y += padding;
        origin.y += [self addMovieView:self.baseScroll origin:origin];
    }
    origin.y += padding;
    origin.y += [self addDownView:self.baseScroll origin:origin];
    origin.y += padding;
    {
        CGSize size = self.baseScroll.contentSize;
        size.height = origin.y;
        self.baseScroll.contentSize = size;
    }
}
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    self.title = [self.info objectForKey:kInfoName];
//    self.iconPath = [self.info objectForKey:kInfoIconName];
//    self.detailPath = [self.info objectForKey:kInfoDetailName];
//    self.name = [self.info objectForKey:kInfoName];
//    
//    CGFloat padding = 10;
//    origin.y = padding;
//    origin.y += [self addUpView:self.baseScroll origin:origin];
//    if (self.hasMovie)
//    {
//        origin.y += padding;
//        origin.y += [self addMovieView:self.baseScroll origin:origin];
//    }
//    origin.y += padding;
//    origin.y += [self addDownView:self.baseScroll origin:origin];
//    origin.y += padding;
//    {
//        CGSize size = self.baseScroll.contentSize;
//        size.height = origin.y;
//        self.baseScroll.contentSize = size;
//    }
//}

- (CGFloat)addUpView:(UIView *)parentView origin:(CGPoint)origin
{
    CGFloat fRet = 0;
    CGFloat padding = 10;
    self.upView = [[UIView alloc] initWithFrame:CGRectMake(padding, origin.y, SCREEN_WIDTH-padding*2, 200+20+padding)];
    self.upView.clipsToBounds = YES;
    self.upView.backgroundColor = [UIColor whiteColor];
    [parentView addSubview:self.upView];
    UIImageView *iconImg = nil;
    
    // 左边图标
    {
        UIImage *img = [UIImage imageWithContentsOfFile:self.iconPath];
        if (!img) {
            img = [UIImage imageNamed:@"icon_default"];
        }
        iconImg = [[UIImageView alloc] initWithImage:img];
        [iconImg fitAndScale:200];
        CGRect frame = iconImg.frame;
        frame.origin = CGPointMake(padding, padding);
        iconImg.frame = frame;
        [self.upView addSubview:iconImg];
    }
    {
        self.infoCnl = [[gdiInfoViewController alloc] init];
        [self.infoCnl changeInfo:self.info];
        self.infoCnl.view.frame = CGRectMake(iconImg.frame.origin.x+iconImg.frame.size.width, padding, self.upView.frame.size.width - iconImg.frame.size.width, iconImg.frame.size.height);
        [self.upView addSubview:self.infoCnl.view];
    }
    fRet = self.upView.frame.size.height;
    return fRet;
}

- (CGFloat)addMovieView:(UIView *)parentView origin:(CGPoint)origin
{
    // 测试，不再如视频
//    return 0;
    CGFloat widthScale = (SCREEN_WIDTH-10*2)*1.0/SCREEN_HEIGHT;
    CGFloat fRet = widthScale*SCREEN_WIDTH;
    CGFloat padding = 10;

    // 在这里初始化，每次都会造成前一个fuckPlayer内存泄露
//    self.fuckPlayer = [[LGPlayerViewController alloc] init];
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/ProductInfo/%@", self.info[kInfoNo]]];
    NSString *path = [homePath stringByAppendingPathComponent:@"movie.plist"];
    NSDictionary *movieInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *movieName = [movieInfo objectForKey:@"file_name"];
    NSString *movieURL = [homePath stringByAppendingPathComponent:movieName];
    NSNumber *movieProId = [movieInfo objectForKey:@"product_id"];
    
    _fuckPlayer.hasDownloaded = YES;
    if ([self checkMovie])  // 未下载或者需要更新
    {
        self.dm = [[gdiDownloadMovie alloc] init];
        [self.dm downLoadMovieWithProId:[self.info objectForKey:kInfoNo]];
        _fuckPlayer.hasDownloaded = NO;
    }
    _fuckPlayer.movieUrl = movieURL;
    _fuckPlayer.movieName = movieName;
    _fuckPlayer.movieProId = movieProId;
    // viewDidLoad在添加view之前调用
    [self.baseScroll addSubview:_fuckPlayer.view];
    
    // 死亡区域，在返回按钮上方
//    self.movieHasLoad = NO;
//    self.showIfMovieHasLoad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    self.showIfMovieHasLoad.backgroundColor = [UIColor clearColor];
//    UIWindow *rootWindow = [UIApplication sharedApplication].keyWindow;
//    [rootWindow addSubview:self.showIfMovieHasLoad];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doNothing)];
//    [self.showIfMovieHasLoad addGestureRecognizer:tap];
    
    
    // 缩小
    _fuckPlayer.view.frame = CGRectMake(padding, origin.y, SCREEN_WIDTH-padding*2, fRet);
    {
        CGRect frame = _fuckPlayer.view.frame;
//        frame.origin = CGPointMake(padding, padding);
//        frame.size = CGSizeMake(100, 100);
        _fuckPlayer.view.frame = frame;
    }
    return fRet;
}

- (void)doNothing
{
}

- (void)removeDeathAreaView
{
    [self.showIfMovieHasLoad removeFromSuperview];
    self.showIfMovieHasLoad = nil;
}

- (CGFloat)addDownView:(UIView *)parentView origin:(CGPoint)origin
{
    CGFloat fRet = 0;
    CGFloat padding = 10;
    self.detailTmpHeight = 1000;
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(padding, origin.y, SCREEN_WIDTH-padding*2, 1000)];
    [parentView addSubview:self.downView];
    {
        if ([self.detailPath isEqualToString:@"暂无图片"])
        {
            self.detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.downView.frame.size.width, 1000)];
            self.detailImg.backgroundColor = self.baseScroll.backgroundColor;
            UILabel *label = [[UILabel alloc] init];
            label.text = @"暂无图片";
            [label sizeToFit];
            [self.detailImg addSubview:label];
            CGRect frame = label.frame;
            frame.origin = CGPointMake(self.detailImg.frame.size.width/2-label.frame.size.width/2, 100);
            label.frame = frame;
            [self.downView addSubview:self.detailImg];
        }
        else
        {
            if ([self checkDetailImg])
            {
                self.dd = [[gdiDownloadDetail alloc] init];
                [self.dd downLoadDetailWithProId:[self.info objectForKey:kInfoNo]];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetail:) name:kNotiDownloadSomeDetailOver object:nil];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDetail:) name:kNotiDownloadDetailOver object:nil];
            }
            else
            {
                [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(loadDetailImgCallBack) userInfo:nil repeats:NO];
            }
            
//            gdiDataOperation *dataOperation = [gdiDataOperation getInstance];
//            [dataOperation encodeDetail:self.detailPath];
//            NSThread *thread = [[NSThread alloc] initWithTarget:dataOperation selector:@selector(encodeDetail:) object:self.detailPath];
//            [thread start];
            self.detailImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.downView.frame.size.width, self.detailTmpHeight)];
            self.detailImg.backgroundColor = [UIColor whiteColor];
            self.detailImgJuhua = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.detailImgJuhua startAnimating];
            [self.detailImg addSubview:self.detailImgJuhua];
            CGRect frame = self.detailImgJuhua.frame;
            frame.origin.x = self.detailImg.frame.size.width/2;
            frame.origin.y = self.detailImg.frame.size.height/2;
            self.detailImgJuhua.frame = frame;
            [self.downView addSubview:self.detailImg];
        }
    }
    CGRect frame = self.downView.frame;
    frame.size.height = self.detailImg.frame.size.height;
    self.downView.frame = frame;
    fRet = self.downView.frame.size.height;
    return fRet;
}

- (void)loadDetailImgCallBack
{
    if (self.hasEnd)
    {
        return;
    }
    [self.detailImgJuhua stopAnimating];
    [self.detailImgJuhua removeFromSuperview];
    NSString *trueDetailPath = [[self.iconPath substringToIndex:self.iconPath.length - 8] stringByAppendingString:@"detail.jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:trueDetailPath];
    
    if (img)
    {
        // 小于4M的图片
        self.detailImg.image = img;
        [self.detailImg fitAndScale:self.downView.frame.size.width];
        CGRect frame = self.downView.frame;
        frame.size.height = frame.size.height - self.detailTmpHeight + self.detailImg.frame.size.height;
        self.downView.frame = frame;
        CGSize size = self.baseScroll.contentSize;
        size.height = size.height - self.detailTmpHeight + self.detailImg.frame.size.height;
        self.baseScroll.contentSize = size;
        
        NSFileManager *fm = [NSFileManager defaultManager];
        float sizeByM = [[fm attributesOfItemAtPath:trueDetailPath error:nil] fileSize]/(1000.0*1000);
        NSLog(@"size by MB is %.2f", sizeByM);
        if (sizeByM > 4)
        {
            self.largeImage = [[LargeImageContainer alloc] initWithImgPath:trueDetailPath andParent:self.detailImg];
            [self.detailImg addSubview:self.largeImage];
        }
    }
    else
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"暂无图片";
        [label sizeToFit];
        [self.detailImg addSubview:label];
        CGRect frame = label.frame;
        frame.origin = CGPointMake(self.detailImg.frame.size.width/2-label.frame.size.width/2, 100);
        label.frame = frame;
    }
    
}

- (void)clickMore:(UIButton *)btn
{
    gdiInfoViewController *info = [[gdiInfoViewController alloc] init];
    info.infoDict = self.info;
    [self.navigationController pushViewController:info animated:YES];
}

- (BOOL)checkDetailImg
{
    // 默认返回YES，也就是需要下载图片
    BOOL bRet = YES;
    NSString *detailSettingPath = [[self.iconPath substringToIndex:self.iconPath.length - 8] stringByAppendingString:@"detail.plist"];
    NSString *detailImgPath = [[self.iconPath substringToIndex:self.iconPath.length - 8] stringByAppendingString:@"detail.jpg"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:detailImgPath])
    {
        NSDictionary *detailSetting = [NSDictionary dictionaryWithContentsOfFile:detailSettingPath];
        NSString *hashStringBySetting = [detailSetting objectForKey:@"file_hash"];
        if (!hashStringBySetting || [hashStringBySetting isEqualToString:@""])
        {
            bRet = NO;
        }
        NSString *hashStringByFile = [FileMD5Hash computeMD5HashOfFileInPath:detailImgPath];
        if ([hashStringByFile isEqualToString:hashStringBySetting])
        {
            bRet = NO;
        }
    }
    return bRet;
}

- (BOOL)checkMovie
{
    // 默认返回YES，也就是需要下载图片
    BOOL bRet = YES;
    NSString *movieSettingPath = [[self.iconPath substringToIndex:self.iconPath.length - 8] stringByAppendingString:@"movie.plist"];
    NSDictionary *movieSetting = [NSDictionary dictionaryWithContentsOfFile:movieSettingPath];
    NSString *movieName = [movieSetting objectForKey:@"file_name"];
    NSString *moviePath = [[self.iconPath substringToIndex:self.iconPath.length - 8] stringByAppendingString:movieName];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:moviePath])
    {
        NSString *hashStringBySetting = [movieSetting objectForKey:@"file_hash"];
        if (!hashStringBySetting || [hashStringBySetting isEqualToString:@""])
        {
            bRet = NO;
        }
        NSString *hashStringByFile = [FileMD5Hash computeMD5HashOfFileInPath:moviePath];
        if ([hashStringByFile isEqualToString:hashStringBySetting])
        {
            bRet = NO;
        }
    }
    return bRet;
}

- (void)updateDetail:(NSNotification *)noti
{
    if (self.hasEnd)
    {
        return;
    }
    NSLog(@"noti:%@", noti);
    NSNumber *notiId = noti.object;
    NSString *notiName = noti.name;
    if ( !([notiId isKindOfClass:[NSNumber class]] && [notiId intValue] == [[self.info objectForKey:kInfoNo] intValue]) )
    {
        return;
    }
    NSString *trueDetailPath = [[self.iconPath substringToIndex:self.iconPath.length - 8] stringByAppendingString:@"detail.jpg"];
    UIImage *img = [UIImage imageWithContentsOfFile:trueDetailPath];
    // 当下载速度很慢的时候，第一次进来，很可能img是nil。
    // 所以不能在这里就添加暂无图片
    if (img)
    {
        self.detailImg.image = img;
        [self.detailImg fitAndScale:self.downView.frame.size.width];
        
        // 缓慢增加scroll高度
        self.detailTmpHeight += 500;
        CGRect frame = self.downView.frame;
        frame.size.height = frame.size.height + 500;
        self.downView.frame = frame;
        CGSize size = self.baseScroll.contentSize;
        size.height = size.height + 500;
        self.baseScroll.contentSize = size;
    }

    if ([notiName isEqualToString:kNotiDownloadDetailOver])
    {
        [self.detailImgJuhua stopAnimating];
        [self.detailImgJuhua removeFromSuperview];
        if (!img)
        {
            UILabel *label = [[UILabel alloc] init];
            label.text = @"暂无图片";
            [label sizeToFit];
            [self.detailImg addSubview:label];
            CGRect frame = label.frame;
            frame.origin = CGPointMake(self.detailImg.frame.size.width/2-label.frame.size.width/2, 100);
            label.frame = frame;
        }
        else
        {
            // 这里不需要了，直接在loadDetailImgCallBack中修改scroll的大小
//            CGRect frame = self.downView.frame;
//            frame.size.height = frame.size.height - self.detailTmpHeight + self.detailImg.frame.size.height;
//            self.downView.frame = frame;
//            CGSize size = self.baseScroll.contentSize;
//            size.height = size.height - self.detailTmpHeight + self.detailImg.frame.size.height;
//            self.baseScroll.contentSize = size;
            [self loadDetailImgCallBack];
            NSLog(@"下载完成，开始重整detail图片!");
        }
    }
}

@end
