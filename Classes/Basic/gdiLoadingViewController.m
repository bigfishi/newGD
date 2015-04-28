//
//  gdiLoadingViewController.m
//  GDiPhone
//
//  Created by yuda on 14-12-8.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiLoadingViewController.h"

@interface gdiLoadingViewController ()
@property (nonatomic) int imgCount;
@property (nonatomic) int iconCount;
@property (nonatomic) int singleImgCount;
@property (nonatomic) int singleIconCount;
@property (nonatomic, weak) gdiDownloadHelper *instance;
@property (nonatomic, strong) NSDictionary *tips;
@end

@implementation gdiLoadingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.instance = [gdiDownloadHelper getInstance];
    NSString *tipsPath = [[NSBundle mainBundle] pathForResource:@"LoadingTip" ofType:@"plist"];
    self.tips = [NSDictionary dictionaryWithContentsOfFile:tipsPath];
    self.progressLabel.text = [self.tips objectForKey:@"loadbegin"];
    [self.juhua startAnimating];
    
    CGAffineTransform newTransform =
    CGAffineTransformScale(self.juhua.transform, 2.0, 2.0);
    [self.juhua setTransform:newTransform];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingOver:) name:kNotiInitDataOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressLabel:) name:kNotiInitNeedDownloadOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressLabel:) name:kNotiDownloadImgOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressLabel:) name:kNotiDownloadAllImgOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressLabel:) name:kNotiDownloadIconOver object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressLabel:) name:kNotiDownloadAllIconOver object:nil];
    // 这个线程中调用NSConnection的异步请求，必须要主线程，其他子线程下，不响应
//    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(initInfo) object:nil];
//    [thread start];
    [self initInfo];
    // 测试通知
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"initFileOver" object:nil];
}

- (void)changeProgressLabel:(NSNotification *)noti
{
    NSString *notiName = noti.name;
    if ([notiName isEqualToString:kNotiInitNeedDownloadOver])
    {
        self.imgCount = self.instance.imgCount;
        self.iconCount = self.instance.iconCount;
        self.singleIconCount = self.singleImgCount = 1;
        self.progressLabel.text = [NSString stringWithFormat:@"%@%d/%d", [self.tips objectForKey:@"loadimgturn"], self.singleImgCount, self.imgCount];
    }
    else if ([notiName isEqualToString:kNotiDownloadImgOver])
    {
        self.singleImgCount++;
        self.progressLabel.text = [NSString stringWithFormat:@"%@%d/%d", [self.tips objectForKey:@"loadimgturn"], self.singleImgCount, self.imgCount];
    }
    else if ([notiName isEqualToString:kNotiDownloadIconOver])
    {
        self.singleIconCount++;
        self.progressLabel.text = [NSString stringWithFormat:@"%@%d/%d", [self.tips objectForKey:@"loadicon"], self.singleIconCount, self.iconCount];
    }
    else if ([notiName isEqualToString:kNotiDownloadAllImgOver])
    {
        self.progressLabel.text = [NSString stringWithFormat:@"%@%d/%d", [self.tips objectForKey:@"loadicon"], self.singleIconCount, self.iconCount];
    }
    else if ([notiName isEqualToString:kNotiDownloadAllIconOver])
    {
        self.progressLabel.text = [self.tips objectForKey:@"loadend"];
    }
}

- (void)initInfo
{
    gdiSingleton *instance = [gdiSingleton getInstance];
    [instance initInfo];
}

- (void)popHomeCtrl
{
    [self.juhua stopAnimating];
    [self.juhua removeFromSuperview];
    UIStoryboard *story = self.storyboard;
    UIViewController* homeCtrl = [story instantiateViewControllerWithIdentifier:@"homeCtrl"];  //test2为viewcontroller的StoryboardId
    [self presentViewController:homeCtrl animated:YES completion:^{
        
    }];
}

- (void)loadingOver:(NSNotification *)noti
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(popHomeCtrl) userInfo:nil repeats:NO];
    // 只是为了赶走那愚蠢的警告
    [timer fireDate];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiInitDataOver object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiInitNeedDownloadOver object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadAllImgOver object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadImgOver object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadIconOver object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadAllIconOver object:nil];
}

@end
