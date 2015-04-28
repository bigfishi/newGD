//
//  gdiContactViewController.h
//  GDiPhone
//
//  Created by yuda on 14-12-12.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gdiContactViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *send;
- (IBAction)sendEmail:(id)sender;

@end
