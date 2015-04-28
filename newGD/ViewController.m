//
//  ViewController.m
//  newGD
//
//  Created by DaYu on 15/4/27.
//  Copyright (c) 2015年 DaYu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"Goods" owner:nil options:nil];
    UIView *goodsView = [views lastObject];
    views = [[NSBundle mainBundle] loadNibNamed:@"CategoryTop" owner:nil options:nil];
    UIView *categoryView = [views lastObject];
    [self.view addSubview:goodsView];
    CGRect frame = goodsView.frame;
    frame.origin = CGPointMake(300, 300);
    goodsView.frame = frame;
    [self.view addSubview:categoryView];
    frame = categoryView.frame;
    frame.origin = CGPointMake(0, 100);
    
//    self.title = @"self.title";
//    self.navigationController.title = @"navicnl.title";
//    self.navigationItem.title = @"navItem.title";
//    self.tabBarController.title = @"tabCnl.title";
//    self.tabBarItem.title = @"tabItem.title";
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
