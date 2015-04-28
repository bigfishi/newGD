//
//  LGPlayerViewController.h
//  LGPlayer
//
//  Created by Jinxiang on 13-10-12.
//  Copyright (c) 2013年 Jinxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayerView.h"

@interface LGPlayerViewController : UIViewController
{
    NSString *_movieUrl;
    NSString *_movieName;
    NSString *_movieDownUrl;
    CGFloat  totalMovieDuration;
    CGFloat  currentDuration;
    UISlider *_movieProgressSlider;
    UIProgressView  *_progressView;
    BOOL     isPlaying;
    BOOL     isComment;
    BOOL     frameChange;
    IBOutlet UIImageView *PlayStyeimageView;
    IBOutlet UILabel *movieNameLabel;
}

@property (assign, nonatomic) IBOutlet CustomPlayerView *LGCustomMoviePlayerController;
@property (assign, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (assign, nonatomic) IBOutlet UILabel *durationLabel;
@property (retain, nonatomic) NSString *movieUrl;
@property (retain, nonatomic) NSString *movieName;
@property (retain, nonatomic) NSString *movieDownUrl;
@property (retain, nonatomic) UISlider *movieProgressSlider;
@property (assign, nonatomic) IBOutlet UIActivityIndicatorView *Moviebuffer;
@property (assign, nonatomic) BOOL     isPlaying;
@property (assign, nonatomic) BOOL     frameChange;
@property (assign, nonatomic) IBOutlet UIView *reminderView;
@property (assign, nonatomic) IBOutlet UILabel *reminderLabel;
@property (assign, nonatomic) IBOutlet UIView *CommentView;
@property (retain, nonatomic) UIProgressView  *progressView;
- (IBAction)downBtn:(id)sender;
- (IBAction)BackBtn:(id)sender;
- (IBAction)PlayAndStopBtn:(id)sender;
- (IBAction)speedBtn:(id)sender;
- (IBAction)speedDownBtn:(id)sender;
- (IBAction)retreatDownBtn:(id)sender;

- (IBAction)retreatBtn:(id)sender;
- (IBAction)CommentBtn:(id)sender;

- (void) speed;
- (void) retreat;





@property (assign, nonatomic) IBOutlet UIButton *backBtn;
@property (assign, nonatomic) IBOutlet UIImageView *udcaptionView;
@property (assign, nonatomic) IBOutlet UIButton *btn1;
@property (assign, nonatomic) IBOutlet UIButton *btn2;
@property (assign, nonatomic) IBOutlet UIButton *btn3;
@property (assign, nonatomic) IBOutlet UIButton *btn4;
@property (assign, nonatomic) IBOutlet UIButton *btn5;
@property (assign, nonatomic) IBOutlet UIButton *btn6;
@property (assign, nonatomic) IBOutlet UIImageView *rightView;
@property (assign, nonatomic) IBOutlet UIImageView *rightLittleView;
@property (assign, nonatomic) IBOutlet UILabel *label1;
@property (assign, nonatomic) IBOutlet UITextView *text1;
@property (assign, nonatomic) IBOutlet UIImageView *img1;
@property (assign, nonatomic) IBOutlet UIButton *btnVolumnes;



- (void)endMovie;
- (void)loadMovieCallBack:(NSNotification *)noti;
@property (retain, nonatomic) NSNumber *movieProId;
@property (assign, nonatomic) BOOL hasDownloaded;

@end
