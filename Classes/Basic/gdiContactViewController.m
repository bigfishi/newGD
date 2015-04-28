//
//  gdiContactViewController.m
//  GDiPhone
//
//  Created by yuda on 14-12-12.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiContactViewController.h"
#import <MessageUI/MessageUI.h>

@interface gdiContactViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation gdiContactViewController

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
    self.textView.layer.cornerRadius = 10;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmail:(id)sender
{
    if (![MFMailComposeViewController canSendMail])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该设备不支持发邮件或者没有设置邮箱" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init]; //创建视图控制器
    mc.mailComposeDelegate = self;
    
    [mc setToRecipients:[NSArray arrayWithObjects:@"460709921@qq.com",nil]]; //设置收件人，可以设置多人
    [mc setSubject:@"意见或建议"];//设置主题
    [mc setMessageBody:self.textView.text isHTML:NO];
    [self presentViewController:mc animated:YES completion:^{
        ;
    }];
}

- (void)showMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark - delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail sent...");
            [self showMessage:@"发送成功!"];
        }
            break;
        case MFMailComposeResultFailed:
        {
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            [self showMessage:[NSString stringWithFormat:@"发送失败:%@", [error localizedDescription]]];
        }
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}
@end
