//
//  gdiProductView.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiProductView.h"

@implementation gdiProductView

// 根据图片自适应的，所以frame的height没用
- (id)initWidthInfo:(NSDictionary *)info frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.info = info;
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.height = 0;
    
    self.no = [self.info objectForKey:kInfoNo];
    self.strProductName = [self.info objectForKey:kInfoName];
    self.strProductRecommandWord = [NSString stringWithFormat:@"%@", [self.info objectForKey:kInfoRecomandWord]];
    self.strProductPrice = [NSString stringWithFormat:@"￥%@.00", [self.info objectForKey:kInfoPrice]];
    UIImage *img = [UIImage imageWithContentsOfFile:[self.info objectForKey:kInfoIconName]];
    if (!img) {
        img = [UIImage imageNamed:@"icon_default"];
    }
    self.icon = [[UIImageView alloc] initWithImage:img];
    {
        CGFloat iconWidth = self.frame.size.width;
        [self.icon fitAndScale:iconWidth];
        CGRect frame = self.icon.frame;
        frame.origin = CGPointMake(0, 0);
        self.icon.frame = frame;
        [self addSubview:self.icon];
        // 手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.icon addGestureRecognizer:tap];
    }
    // 名称
    {
        self.productName = [[UILabel alloc] init];
        self.productName.text = self.strProductName;
        self.productName.font = [UIFont systemFontOfSize:16];
        [self.productName sizeToFit];
        if (self.productName.frame.size.width > self.frame.size.width - 20)
        {
            CGRect frame = self.productName.frame;
            frame.size.width = self.frame.size.width;
            self.productName.frame = frame;
        }
        CGRect frame = self.productName.frame;
//        frame.origin = CGPointMake((self.frame.size.width-self.productName.frame.size.width)/2, self.icon.frame.origin.y+self.icon.frame.size.height+5);
        frame.origin = CGPointMake(5, self.icon.frame.origin.y+self.icon.frame.size.height+5);
        self.productName.frame = frame;
        [self addSubview:self.productName];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.productName addGestureRecognizer:tap];
    }
    // 价格
    {
        self.productPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.icon.frame.size.width, 30)];
        self.productPrice.text = self.strProductPrice;
        self.productPrice.font = [UIFont systemFontOfSize:14];
        self.productPrice.textColor = [UIColor redColor];
        [self.productPrice sizeToFit];
        if (self.productPrice.frame.size.width > self.frame.size.width - 20)
        {
            CGRect frame = self.productPrice.frame;
            frame.size.width = self.frame.size.width;
            self.productPrice.frame = frame;
        }
        CGRect frame = self.productPrice.frame;
//        frame.origin = CGPointMake((self.frame.size.width-self.productPrice.frame.size.width)/2, self.productName.frame.origin.y+self.productName.frame.size.height+5);
        frame.origin = CGPointMake(5, self.productName.frame.origin.y+self.productName.frame.size.height+5);
        self.productPrice.frame = frame;
        [self addSubview:self.productPrice];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.productPrice addGestureRecognizer:tap];
    }
    // 推荐词
    {
        self.productRecommandWord = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.icon.frame.size.width, 30)];
        self.productRecommandWord.text = self.strProductRecommandWord;
        self.productRecommandWord.font = [UIFont systemFontOfSize:12];
        self.productRecommandWord.textColor = [UIColor colorWithHexString:@"#999999"];
        [self.productRecommandWord sizeToFit];
        if (self.productRecommandWord.frame.size.width > self.frame.size.width - 20)
        {
            CGRect frame = self.productRecommandWord.frame;
            frame.size.width = self.frame.size.width;
            self.productRecommandWord.frame = frame;
        }
        CGRect frame = self.productRecommandWord.frame;
//        frame.origin = CGPointMake((self.frame.size.width-self.productRecommandWord.frame.size.width)/2, self.productPrice.frame.origin.y+self.productPrice.frame.size.height+5);
        frame.origin = CGPointMake(5, self.productPrice.frame.origin.y+self.productPrice.frame.size.height+5);
        self.productRecommandWord.frame = frame;
        [self addSubview:self.productRecommandWord];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.productRecommandWord addGestureRecognizer:tap];
    }
    {
        self.height += self.productRecommandWord.frame.origin.y+self.productRecommandWord.frame.size.height + 5;
        CGRect frame = self.frame;
        frame.size.height = self.height;
        self.frame = frame;
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = self.bounds;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"点击了%@产品", self.name);
//    gdiDetailViewController *detail = [[gdiDetailViewController alloc] initWithInfo:self.info];
    gdiSingleton *instance = [gdiSingleton getInstance];
    gdiDetailViewController *detail = instance.detailController;
    [detail changeInfo:self.info];
    //    [self presentViewController:detail animated:YES completion:^{}];
    UINavigationController * cnl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [cnl pushViewController:detail animated:YES];
}

- (void)click:(UIButton *)btn
{
//    gdiDetailViewController *detail = [[gdiDetailViewController alloc] initWithInfo:self.info];
    gdiSingleton *instance = [gdiSingleton getInstance];
    gdiDetailViewController *detail = instance.detailController;
    [detail changeInfo:self.info];
    //    [self presentViewController:detail animated:YES completion:^{}];
    UINavigationController * cnl = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [cnl pushViewController:detail animated:YES];
    NSLog(@"点击按钮了");
}

@end
