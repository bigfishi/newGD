//
//  LGPlayerViewController.m
//  LGPlayer
//
//  Created by Jinxiang on 13-10-12.
//  Copyright (c) 2013年 Jinxiang. All rights reserved.
//

#import "LGPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "gdiDataOperation.h"

#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7 NLSystemVersionGreaterOrEqualThan(7.0)

@interface LGPlayerViewController ()
@property (nonatomic, retain) AVPlayerLayer *avPlayer;
@property (nonatomic, assign) NSThread *thread;
@end

@implementation LGPlayerViewController
@synthesize movieUrl = _movieUrl,movieName = _movieName,movieDownUrl = _movieDownUrl;
@synthesize isPlaying;
@synthesize frameChange;
@synthesize progressView = _progressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 刚开始就播放
//    [_LGCustomMoviePlayerController.player play];
    
    //转换成CMTime才能给player来控制播放进度
//    CGFloat newTime = 0;
//    CMTime dragedCMTime = CMTimeMake(newTime, 1);
//    [_LGCustomMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
//     ^(BOOL finish)
//     {
//         
//     }];
    
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotiDownloadMovieOver object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backBtn.hidden = YES;
    self.udcaptionView.hidden = YES;
    self.btn1.hidden = YES;
    self.btn2.hidden = YES;
    self.btn3.hidden = YES;
    self.btn4.hidden = YES;
    self.btn5.hidden = YES;
    self.btn6.hidden = YES;
    self.rightView.hidden = YES;
    self.rightView.clipsToBounds = YES;
    self.rightLittleView.hidden = YES;
    self.text1.hidden = YES;
    self.label1.hidden = YES;
    self.CommentView.hidden = YES;
    self.btnVolumnes.hidden = YES;
    
    
    
    // 标题
    NSString *tmpStr = @"JSJP";
    if ([self.movieName rangeOfString:tmpStr].location != NSNotFound)
    {
        self.movieName = @"视频";
    }
    movieNameLabel.text = self.movieName;
    movieNameLabel.textAlignment = NSTextAlignmentCenter;
//    CGRect frame = movieNameLabel.frame;
//    frame.size.width += 100;
//    movieNameLabel.frame = frame;
    _movieProgressSlider.value = 0;
    
    [self monitorMovieProgress];
    self.reminderView.hidden = YES;
    self.reminderView.userInteractionEnabled = NO;
    CALayer *lay  = self.reminderView.layer;//获取层
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:10];     //值越大，角度越圆
    
    self.CommentView.frame = CGRectMake(755 + 269, 20, 269, 664);
    isComment = NO;
    // 缩小
    CGFloat padding = 10;
    CGFloat widthScale = (SCREEN_WIDTH-padding*2)/1028;
    CGAffineTransform newTransform = CGAffineTransformScale(self.view.transform, widthScale, widthScale);
    [self.view setTransform:newTransform];

    if (self.hasDownloaded)
    {
        [self loadMovieCallBack:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMovieCallBack:) name:kNotiDownloadMovieOver object:nil];
    }
//    [self performSelectorInBackground:@selector(loadMovie) withObject:nil];
}
- (void)loadMovieCallBack:(NSNotification *)noti
{
    NSNumber *movieProId = noti.object;
    NSLog(@"noti %@", movieProId);
    NSLog(@"proId %@", self.movieProId);
    // 不是当前视频
    if (movieProId && [movieProId intValue] != [self.movieProId intValue])
    {
        return;
    }
    //使用playerItem获取视频的信息，当前播放时间，总时间等
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:self.movieUrl]];
    //player是视频播放的控制器，可以用来快进播放，暂停等
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    //    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_LGCustomMoviePlayerController.player];
    //    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.avPlayer = [AVPlayerLayer playerLayerWithPlayer:_LGCustomMoviePlayerController.player];
    self.avPlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [_LGCustomMoviePlayerController setPlayer:player];
//    _LGCustomMoviePlayerController.player.allowsAirPlayVideo = YES;
    _LGCustomMoviePlayerController.delegate = self;
    isPlaying = YES;
    if (!IOS7)
    {
        //计算视频总时间
        CMTime totalTime = playerItem.duration;
        //因为slider的值是小数，要转成float，当前时间和总时间相除才能得到小数,因为5/10=0
        totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:totalMovieDuration];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (totalMovieDuration/3600 >= 1) {
            [formatter setDateFormat:@"HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"mm:ss"];
        }
        NSString *showtimeNew = [formatter stringFromDate:d];
        NSLog(@"totalMovieDuration:%@",showtimeNew);
        //在totalTimeLabel上显示总时间
        self.durationLabel.text = showtimeNew;
        [formatter release];
    }
    // 添加定时器，改变status
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
    timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
    //检测视频加载状态，加载完成隐藏风火轮
    [_LGCustomMoviePlayerController.player.currentItem addObserver:self forKeyPath:@"status"
                                                           options:NSKeyValueObservingOptionNew
                                                           context:nil];
    [_LGCustomMoviePlayerController.player.currentItem  addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //添加视频播放完成的notifation
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_LGCustomMoviePlayerController.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
    
//    [self monitorMovieProgress];
    [_LGCustomMoviePlayerController.player play];
    //使用movieProgressSlider反应视频播放的进度
    //第一个参数反应了检测的频率
    [_LGCustomMoviePlayerController.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
        //获取当前时间
        CMTime currentTime = _LGCustomMoviePlayerController.player.currentItem.currentTime;
        //转成秒数
        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
        _movieProgressSlider.value = currentPlayTime/totalMovieDuration;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (currentPlayTime/3600 >= 1) {
            [formatter setDateFormat:@"HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"mm:ss"];
        }
        NSString *showtime = [formatter stringFromDate:d];
        self.currentTimeLabel.text = showtime;
        [formatter release];
    }];
    
    [self.movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
    [self.movieProgressSlider addTarget:self action:@selector(scrubberIsScrolling) forControlEvents:UIControlEventValueChanged];
    [self.movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
    
//    self.reminderView.hidden = YES;
//    CALayer *lay  = self.reminderView.layer;//获取层
//    [lay setMasksToBounds:YES];
//    [lay setCornerRadius:10];     //值越大，角度越圆
//    
//    self.CommentView.frame = CGRectMake(755 + 269, 20, 269, 664);
//    isComment = NO;
    
    
    /*
     视频播放时，控制手势，双击放大缩小播放比例
     双指缩放播放比例
     */
    //轻触手势（单击，双击）
    UITapGestureRecognizer *oneTap=nil;
    oneTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired = 1;
    [_LGCustomMoviePlayerController addGestureRecognizer:oneTap];
    [oneTap release];
    
    UITapGestureRecognizer *tapCgr=nil;
    tapCgr=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TwoTap:)];
    tapCgr.numberOfTapsRequired = 2;
    [_LGCustomMoviePlayerController addGestureRecognizer:tapCgr];
    [tapCgr release];
    
    [oneTap requireGestureRecognizerToFail:tapCgr]; //防止：双击被单击拦截
    //    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    //    [_LGCustomMoviePlayerController addGestureRecognizer:pinchGestureRecognizer];
    
//    // 缩小
//    CGFloat padding = 10;
//    CGFloat widthScale = (SCREEN_WIDTH-padding*2)/1028;
//    CGAffineTransform newTransform = CGAffineTransformScale(self.view.transform, widthScale, widthScale);
//    [self.view setTransform:newTransform];
//    [_LGCustomMoviePlayerController.player play];
}
- (void)timerFired:(NSTimer *)timer
{
#if 0
    AVPlayerItem *playerItem = _LGCustomMoviePlayerController.player.currentItem;
    [self.Moviebuffer stopAnimating];
    self.Moviebuffer.hidden = YES;
    if (IOS7)
    {
        //计算视频总时间
        CMTime totalTime = playerItem.duration;
        totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:totalMovieDuration];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (totalMovieDuration/3600 >= 1) {
            [formatter setDateFormat:@"HH:mm:ss"];
        }
        else
        {
            [formatter setDateFormat:@"mm:ss"];
        }
        NSString *showtimeNew = [formatter stringFromDate:d];
        self.durationLabel.text = showtimeNew;
    }
#endif
}
- (void) oneTap:(UITapGestureRecognizer *)sender
{
    if (isPlaying == YES)
    {
        isPlaying = NO;
        
        self.reminderView.hidden = NO;
        // 这里显示标签
        self.reminderLabel.text = @"暂停";
        PlayStyeimageView.image = [UIImage imageNamed:@"pause.png"];
        [_LGCustomMoviePlayerController.player pause];
    }
    else
    {
        isPlaying = YES;
        
        self.reminderView.hidden = NO;
        // 这里显示标签
        self.reminderLabel.text = @"播放";
        PlayStyeimageView.image = [UIImage imageNamed:@"play2.png"];
        [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
        [_LGCustomMoviePlayerController.player play];
    }
}

//双击放大或缩小播放比例
- (void) TwoTap:(UITapGestureRecognizer *)sender
{
    if (frameChange == NO)
    {
        _LGCustomMoviePlayerController.frame = CGRectMake(-290.5, -117.025, 1024*1.5, 615*1.5);
        frameChange = YES;
    }
    else
    {
        _LGCustomMoviePlayerController.frame = CGRectMake(0, 69, 1024, 615);
        frameChange = NO;
    }
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    frameChange = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)downBtn:(id)sender {
    
}

- (IBAction)BackBtn:(id)sender
{
    [_LGCustomMoviePlayerController.player pause];
    isPlaying = NO;
}

- (IBAction)PlayAndStopBtn:(id)sender {
    if (isPlaying == YES)
    {
        self.reminderView.hidden = NO;
        // 这里显示标签
        self.reminderLabel.text = @"暂停";
        PlayStyeimageView.image = [UIImage imageNamed:@"pause.png"];
        [_LGCustomMoviePlayerController.player pause];
        isPlaying = NO;
    }
    else
    {
        self.reminderView.hidden = NO;
        // 这里显示标签
        self.reminderLabel.text = @"播放";
        PlayStyeimageView.image = [UIImage imageNamed:@"play2.png"];
        [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
        [_LGCustomMoviePlayerController.player play];
        isPlaying = YES;
    }
}


- (IBAction)speedDownBtn:(id)sender
{
    [_LGCustomMoviePlayerController.player pause];
    //获取当前时间
    CMTime currentTime = _LGCustomMoviePlayerController.player.currentItem.currentTime;
    //转成秒数
    currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
}
- (IBAction)retreatDownBtn:(id)sender
{
    [_LGCustomMoviePlayerController.player pause];
    CMTime currentTime = _LGCustomMoviePlayerController.player.currentItem.currentTime;
    //转成秒数
    currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
}

- (IBAction)speedBtn:(id)sender
{
    self.reminderView.hidden = NO;
    // 这里显示标签
    self.reminderLabel.text = @"快进5秒";
    PlayStyeimageView.image = [UIImage imageNamed:@"speed.png"];
    [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
    float bufferTime = [self availableDuration];
    float durationTime = CMTimeGetSeconds([[self.LGCustomMoviePlayerController.player currentItem] duration]);
    [self.progressView setProgress:bufferTime/durationTime animated:YES];
    [self speed];
}

- (IBAction)retreatBtn:(id)sender
{
    self.reminderView.hidden = NO;
    self.reminderLabel.text = @"快退5秒";
    PlayStyeimageView.image = [UIImage imageNamed:@"retreat.png"];
    [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
    float bufferTime = [self availableDuration];
    float durationTime = CMTimeGetSeconds([[self.LGCustomMoviePlayerController.player currentItem] duration]);
    [self.progressView setProgress:bufferTime/durationTime animated:YES];
    [self retreat];
}

- (IBAction)CommentBtn:(id)sender
{
    if (isComment == YES)
    {
        isComment = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.CommentView.frame = CGRectMake(755 + 269, 20, 269, 664);
        [UIView commitAnimations];
    }
    else
    {
        isComment = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.CommentView.frame = CGRectMake(755, 20, 269, 664);
        [UIView commitAnimations];
    }
}

- (void) speed
{
    int interval = 5;
    CGFloat newTime = currentDuration + interval;
    if (newTime >= totalMovieDuration)
    {
        if (isPlaying == YES)
        {
            [_LGCustomMoviePlayerController.player play];
        }
        return;
    }
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(newTime, 1);
    [self.Moviebuffer startAnimating];
    self.Moviebuffer.hidden = NO;
    [_LGCustomMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         [_LGCustomMoviePlayerController.player play];
         [self.Moviebuffer stopAnimating];
         self.Moviebuffer.hidden = YES;
     }];
    isPlaying = YES;
}

- (void)endMovie
{
    [_LGCustomMoviePlayerController.player pause];
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(totalMovieDuration, 1);
    [self.Moviebuffer startAnimating];
    self.Moviebuffer.hidden = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:MOVIE_HAS_STOPPED object:nil];
    [_LGCustomMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         // 这里不需要，dealloc中有
//         [_LGCustomMoviePlayerController.player.currentItem removeObserver:self forKeyPath:@"status"];
//         [_LGCustomMoviePlayerController.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
//         [_LGCustomMoviePlayerController.player play];
//         [self.Moviebuffer stopAnimating];
//         self.Moviebuffer.hidden = YES;
         // !!!
//         _LGCustomMoviePlayerController.player = nil;
//         NSError *error = nil;
//         NSString *path = [gdiSingleton getAppPath];
//         path = [NSString stringWithFormat:@"%@/jiemi%@.mp4", path, self.movieName];
//         [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
     }];
    isPlaying = YES;
}

- (void) retreat
{
    int interval = 5;
    CGFloat newTime = currentDuration - interval;
    if (newTime <= 0.0)
    {
        if (isPlaying == YES)
        {
            [_LGCustomMoviePlayerController.player play];
        }
        return;
    }
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(newTime, 1);
    [self.Moviebuffer startAnimating];
    self.Moviebuffer.hidden = NO;
    [_LGCustomMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
         [_LGCustomMoviePlayerController.player play];
         [self.Moviebuffer stopAnimating];
         self.Moviebuffer.hidden = YES;
     }];
    isPlaying = YES;
}

-(void)monitorMovieProgress{
    [self.Moviebuffer startAnimating];
//    //使用movieProgressSlider反应视频播放的进度
//    //第一个参数反应了检测的频率
//    [_LGCustomMoviePlayerController.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time){
//        //获取当前时间
//        CMTime currentTime = _LGCustomMoviePlayerController.player.currentItem.currentTime;
//        //转成秒数
//        CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
//        _movieProgressSlider.value = currentPlayTime/totalMovieDuration;
//        NSDate *d = [NSDate dateWithTimeIntervalSince1970:currentPlayTime];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        if (currentPlayTime/3600 >= 1) {
//            [formatter setDateFormat:@"HH:mm:ss"];
//        }
//        else
//        {
//            [formatter setDateFormat:@"mm:ss"];
//        }
//        NSString *showtime = [formatter stringFromDate:d];
//        self.currentTimeLabel.text = showtime;
//    }];
    
    //左右轨的图片
    UIImage *stetchLeftTrack = [[UIImage imageNamed:@"播放器_13.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    UIImage *stetchRightTrack = [[UIImage imageNamed:@"rigth.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    //滑块图片
    UIImage *thumbImage = [UIImage imageNamed:@"slider-metal-handle.png"];
    
    if (IOS7)
    {
        UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(6, 673, 1015.5, 12)];
        self.movieProgressSlider = slider;
        [slider release];
        UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(6, 688.5, 1015.5, 15)];
        self.progressView = pro;
        [pro release];
    }
    else
    {
        UISlider *slider = [[UISlider alloc]initWithFrame:CGRectMake(6, 678.5, 1015.5, 12)];
        self.movieProgressSlider = slider;
        [slider release];
        UIProgressView *pro = [[UIProgressView alloc] initWithFrame:CGRectMake(6.5, 686.5, 1015.5, 3)];
        self.progressView = pro;
        [pro release];
    }

    _progressView.progressTintColor = [UIColor blackColor];
    _progressView.trackTintColor = [UIColor clearColor];
    [self.progressView setProgress:0 animated:NO];
    [self.view addSubview:_progressView];

    [self.view addSubview:self.movieProgressSlider];
    [self.movieProgressSlider setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self.movieProgressSlider setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    self.movieProgressSlider.backgroundColor = [UIColor clearColor];
    //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
    [self.movieProgressSlider setThumbImage:thumbImage forState:UIControlStateHighlighted];
    [self.movieProgressSlider setThumbImage:thumbImage forState:UIControlStateNormal];
//    [self.movieProgressSlider addTarget:self action:@selector(scrubbingDidBegin) forControlEvents:UIControlEventTouchDown];
//    [self.movieProgressSlider addTarget:self action:@selector(scrubberIsScrolling) forControlEvents:UIControlEventValueChanged];
//    [self.movieProgressSlider addTarget:self action:@selector(scrubbingDidEnd) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchCancel)];
}

//按动滑块
-(void)scrubbingDidBegin
{
    [_LGCustomMoviePlayerController.player pause];
}

//快进
-(void)scrubberIsScrolling
{
    double currentTime = floor(totalMovieDuration *self.movieProgressSlider.value);
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(currentTime, 1);
    [_LGCustomMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
    {
        if (isPlaying == YES)
        {
            [_LGCustomMoviePlayerController.player play];
        }
        [self.Moviebuffer stopAnimating];
        self.Moviebuffer.hidden = YES;
    }];
}

-(void)scrubbingDidEnd
{
    self.Moviebuffer.hidden = NO;
    [_Moviebuffer startAnimating];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItem *playerItem = (AVPlayerItem*)object;
        if (playerItem.status==AVPlayerStatusReadyToPlay) {
            //视频加载完成
            [self.Moviebuffer stopAnimating];
            self.Moviebuffer.hidden = YES;
            if (IOS7)
            {
                //计算视频总时间
                CMTime totalTime = playerItem.duration;
                totalMovieDuration = (CGFloat)totalTime.value/totalTime.timescale;
                NSDate *d = [NSDate dateWithTimeIntervalSince1970:totalMovieDuration];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                if (totalMovieDuration/3600 >= 1) {
                    [formatter setDateFormat:@"HH:mm:ss"];
                }
                else
                {
                    [formatter setDateFormat:@"mm:ss"];
                }
                NSString *showtimeNew = [formatter stringFromDate:d];
                self.durationLabel.text = showtimeNew;
                [formatter release];
            }
         }
    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        float bufferTime = [self availableDuration];
        NSLog(@"缓冲进度%f",bufferTime);
        float durationTime = CMTimeGetSeconds([[self.LGCustomMoviePlayerController.player currentItem] duration]);
        [self.progressView setProgress:bufferTime/durationTime animated:YES];
    }

}

//加载进度
- (float)availableDuration
{
    NSArray *loadedTimeRanges = [[self.LGCustomMoviePlayerController.player currentItem] loadedTimeRanges];
    if ([loadedTimeRanges count] > 0) {
        CMTimeRange timeRange = [[loadedTimeRanges objectAtIndex:0] CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        return (startSeconds + durationSeconds);
    } else {
        return 0.0f;
    }
}

-(void)moviePlayDidEnd:(NSNotification*)notification{
    //视频播放完成
    NSLog(@"播放完成 加入广告");
    
    
    [_LGCustomMoviePlayerController.player pause];
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(0, 1);
    [self.Moviebuffer startAnimating];
    self.Moviebuffer.hidden = NO;
    [_LGCustomMoviePlayerController.player seekToTime:dragedCMTime completionHandler:
     ^(BOOL finish)
     {
//         [_LGCustomMoviePlayerController.player play];
         [self.Moviebuffer stopAnimating];
         self.Moviebuffer.hidden = YES;
         self.reminderView.hidden = NO;
         // 这里显示标签
         self.reminderLabel.text = @"重新播放";
         PlayStyeimageView.image = [UIImage imageNamed:@"play2.png"];
//         [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
     }];
    isPlaying = NO;
}

-(void)applicationWillResignActive:(NSNotification *)notification
{
    isPlaying = NO;
    NSLog(@"进入后台");
}
// 手势快进
- (void) Touchspeed
{
    //获取当前时间
    CMTime currentTime = _LGCustomMoviePlayerController.player.currentItem.currentTime;
    //转成秒数
    currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
    CGFloat newTime = currentDuration + 5;
    if (newTime >= totalMovieDuration)
    {
        return;
    }
    self.reminderView.hidden = NO;
    self.reminderLabel.text = @"快进5秒";
    PlayStyeimageView.image = [UIImage imageNamed:@"speed.png"];
    [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
    [self speed];
}

- (void) Touchretreat
{
    //获取当前时间
    CMTime currentTime = _LGCustomMoviePlayerController.player.currentItem.currentTime;
    //转成秒数
    currentDuration = (CGFloat)currentTime.value/currentTime.timescale;
    CGFloat newTime = currentDuration - 5;
    if (newTime <= 0.0)
    {
        return;
    }
    self.reminderView.hidden = NO;
    self.reminderLabel.text = @"快退5秒";
    PlayStyeimageView.image = [UIImage imageNamed:@"retreat.png"];
    [self performSelector:@selector(hideReminderView) withObject:self afterDelay:0.5];
    [self retreat];
}

- (void) hideReminderView
{
    self.reminderView.hidden = YES;
}

- (void)dealloc {
    [_currentTimeLabel release];
    [_durationLabel    release];
    [_movieUrl         release];
    [_movieDownUrl     release];
    [_movieName        release];
    [_LGCustomMoviePlayerController release];
    [_movieProgressSlider release];
    [_Moviebuffer release];
    [_reminderView release];
    [_reminderLabel release];
    [_CommentView release];
    [_progressView release];
    
    //释放对视频播放完成的监测
    [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_LGCustomMoviePlayerController.player.currentItem];
    //释放掉对playItem的观察
    [_LGCustomMoviePlayerController.player.currentItem removeObserver:self
                                                           forKeyPath:@"status"
                                                              context:nil];
    [_LGCustomMoviePlayerController.player.currentItem removeObserver:self
                                                           forKeyPath:@"loadedTimeRanges"
                                                              context:nil];

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [PlayStyeimageView release];
    [movieNameLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setCurrentTimeLabel:nil];
    [self setDurationLabel:nil];
    [self setLGCustomMoviePlayerController:nil];
    [self setMovieProgressSlider:nil];
    [self setMoviebuffer:nil];
    [self setReminderView:nil];
    [self setReminderLabel:nil];
    [self setCommentView:nil];
    [PlayStyeimageView release];
    PlayStyeimageView = nil;
    [movieNameLabel release];
    movieNameLabel = nil;
    [super viewDidUnload];
}
@end
