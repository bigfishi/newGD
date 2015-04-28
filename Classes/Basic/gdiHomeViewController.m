//
//  gdiHomeViewController.m
//  GDiPhone
//
//  Created by YuDa on 14-9-21.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiHomeViewController.h"
#import "gdiAddImgTurn.h"
#import "gdiAddHScrollView.h"
#import "gdiAddHScrollViewByImg.h"
#import "gdiListViewController.h"
#import "gdiSettingTableViewController.h"

@interface gdiHomeViewController ()
@property (strong, nonatomic) gdiAddImgTurn *imgTurn;
@property (strong, nonatomic) NSMutableArray *categoryTips;
@property (strong, nonatomic) NSMutableArray *subScrolls;
@property (strong, nonatomic) UIBarButtonItem *btnSearch;
@property (strong, nonatomic) UIBarButtonItem *btnSetting;
@property (strong, nonatomic) NSArray *barbtns;

@property (strong, nonatomic) gdiAddHScrollView *sc;
@end

static CGPoint origin = {0, 0};

@implementation gdiHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].keyWindow.rootViewController = self.tabBarController.navigationController;
    
    gdiSingleton *instance = [gdiSingleton getInstance];
    // 改变位置到loading页面中
//    [instance initInfo];
    
    self.subScrolls = [NSMutableArray array];
    self.categoryTips = [NSMutableArray array];
    //    self.view.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
    self.imgTurn = [[gdiAddImgTurn alloc] init];
    origin = CGPointMake(0, [gdiHelper captionHeight]);
    if ([gdiHelper isiOS7])
    {
        origin.y += 20;
    }
    // 搜索按钮
    self.btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    UIImage *setImg = [UIImage imageNamed:@"setting_small3"];
    self.btnSetting = [[UIBarButtonItem alloc] initWithImage:setImg style:UIBarButtonItemStylePlain target:self action:@selector(setting:)];
    self.barbtns = @[self.btnSetting, self.btnSearch];
//    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    self.tabBarController.navigationItem.rightBarButtonItems = self.barbtns;
    // 添加图片轮播，并把图片轮播的高度加上
//    origin.y += [self.imgTurn addImgTurnToView:self.baseScroll origin:origin];
//    origin.y += 10;
//    origin.y += [self initOneCategory:origin];
//    origin.y += 5;
//    self.shScroll = [[gdiAddHScrollView alloc] init];
//    origin.y += [self.shScroll addHScrollView:self.baseScroll origin:origin type:kHScrollViewTypeSmartHome];
//    origin.y += 10;
//    origin.y += [self initTwoCategory:origin];
//    origin.y += 5;
//    self.fScroll = [[gdiAddHScrollView alloc] init];
//    origin.y += [self.fScroll addHScrollView:self.baseScroll origin:origin type:kHScrollViewTypeFeatured];
//    origin.y += 10;
    
    origin.y += [self.imgTurn addImgTurnToView:self.baseScroll origin:origin];
    NSArray *cateBySetting = instance.categoryBySetting;
    NSUInteger categoryCount = instance.categoryBySetting.count;
    categoryCount = categoryCount > 5 ? 5 : categoryCount;
    for (int i=0; i<categoryCount; i++)
    {
        NSDictionary *dict = [cateBySetting objectAtIndex:i];
        NSString *category = [dict objectForKey:@"name"];
        NSString *productsStr = [dict objectForKey:@"products"];
        NSArray *nos = [productsStr componentsSeparatedByString:@","];
        // 限制个数 5个
        if (nos.count > 5)
        {
            nos = [NSArray arrayWithObjects:nos[0], nos[1], nos[2], nos[3], nos[4], nil];
        }
        NSArray *info = [instance getInfoWithNos:nos];
        origin.y += 10;
        origin.y += [self initOneCategory:category];
        origin.y += 5;
        gdiAddHScrollView *scroll = [[gdiAddHScrollView alloc] init];
        origin.y += [scroll addHScrollView:self.baseScroll origin:origin info:info];
        [self.subScrolls addObject:scroll];
    }
    {
        CGSize scrollSize = self.baseScroll.contentSize;
        scrollSize.height = origin.y+60; // 40是下面的tabbar
        self.baseScroll.contentSize = scrollSize;
    }
}

- (CGFloat)initOneCategory:(NSString *)category
{
    CGFloat fRet = 30.0f;
    CGFloat leftStickWidth = 10;
    CGFloat margin = 10;
    CGFloat leftPadding = 10;
    CGFloat offsetX = 0;
    // 初始化
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x+margin, origin.y, SCREEN_WIDTH-margin*2, fRet)];
    //    view.backgroundColor = [UIColor whiteColor];
    [self.baseScroll addSubview:view];
    // 左边竖线
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, leftStickWidth, fRet);
    // #82c92f
    UIColor *color = colorWithRGBA(130, 192, 47, 255);
    layer.backgroundColor = color.CGColor;
    [view.layer addSublayer:layer];
    UIButton *cnBtn = nil;
    // 左边文字
    {
        cnBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cnBtn.backgroundColor = [UIColor clearColor];
        [cnBtn setTitle:category forState:UIControlStateNormal];
        [cnBtn setTitleColor:color forState:UIControlStateNormal];
        [cnBtn setTitleColor:color forState:UIControlStateHighlighted];
        [cnBtn sizeToFit];
        CGRect frame = cnBtn.frame;
        frame.origin = CGPointMake(leftStickWidth + leftPadding, 0);
        frame.size.height = fRet;
        cnBtn.frame = frame;
        [view addSubview:cnBtn];
        offsetX += cnBtn.frame.origin.x + cnBtn.frame.size.width + margin;
        
        [cnBtn setTitle:category forState:UIControlStateDisabled];
        [cnBtn addTarget:self action:@selector(jumpToCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    // 对应的英文
    {
//        UIButton *enBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        enBtn.backgroundColor = [UIColor clearColor];
//        [enBtn setTitle:@"Featured" forState:UIControlStateNormal];
//        [enBtn setTitleColor:colorWithRGBA(134, 132, 132, 255) forState:UIControlStateNormal];
//        [enBtn setTitleColor:colorWithRGBA(134, 132, 132, 255) forState:UIControlStateHighlighted];
//        [enBtn sizeToFit];
//        CGRect frame = enBtn.frame;
//        frame.origin = CGPointMake(offsetX, 0);
//        frame.size.height = fRet;
//        enBtn.frame = frame;
//        [view addSubview:enBtn];
    }
    // 右边文字
    UIButton *moreBtn = nil;
    {
        moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        moreBtn.backgroundColor = [UIColor clearColor];
        [moreBtn setTitle:@"更多>>" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#868484"] forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#FF9000"] forState:UIControlStateHighlighted];
        CGFloat width = 80;
        CGRect frame = CGRectMake(SCREEN_WIDTH-width-margin, 0, width, fRet);
        moreBtn.frame = frame;
        [view addSubview:moreBtn];
        [moreBtn setTitle:category forState:UIControlStateDisabled];
        [moreBtn addTarget:self action:@selector(jumpToCategory:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.categoryTips addObject:@{@"tip":cnBtn, @"more":moreBtn}];
    return fRet;
}
- (void)jumpToCategory:(UIButton *)btn
{
    NSString *category = [btn titleForState:UIControlStateDisabled];
    gdiListViewController *list = [[gdiListViewController alloc] initWithCategory:category];
    [self.tabBarController.navigationController pushViewController:list animated:YES];
}

- (CGFloat)initTwoCategory:(CGPoint)origin
{
    CGFloat fRet = 30.0f;
    CGFloat leftStickWidth = 10;
    CGFloat margin = 10;
    CGFloat leftPadding = 10;
    CGFloat offsetX = 0;
    // 初始化
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(origin.x+margin, origin.y, SCREEN_WIDTH-margin*2, fRet)];
    //    view.backgroundColor = [UIColor whiteColor];
    [self.baseScroll addSubview:view];
    // 左边竖线
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, leftStickWidth, fRet);
    // #82c92f
    UIColor *color = colorWithRGBA(130, 192, 47, 255);
    layer.backgroundColor = color.CGColor;
    [view.layer addSublayer:layer];
    // 左边文字
    {
        UIButton *cnBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cnBtn.backgroundColor = [UIColor clearColor];
        [cnBtn setTitle:@"机器精选" forState:UIControlStateNormal];
        [cnBtn setTitleColor:color forState:UIControlStateNormal];
        [cnBtn setTitleColor:color forState:UIControlStateHighlighted];
        [cnBtn sizeToFit];
        CGRect frame = cnBtn.frame;
        frame.origin = CGPointMake(leftStickWidth + leftPadding, 0);
        frame.size.height = fRet;
        cnBtn.frame = frame;
        [view addSubview:cnBtn];
        offsetX += cnBtn.frame.origin.x + cnBtn.frame.size.width + margin;
    }
    {
        UIButton *enBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        enBtn.backgroundColor = [UIColor clearColor];
        [enBtn setTitle:@"Featured" forState:UIControlStateNormal];
        [enBtn setTitleColor:colorWithRGBA(134, 132, 132, 255) forState:UIControlStateNormal];
        [enBtn setTitleColor:colorWithRGBA(134, 132, 132, 255) forState:UIControlStateHighlighted];
        [enBtn sizeToFit];
        CGRect frame = enBtn.frame;
        frame.origin = CGPointMake(offsetX, 0);
        frame.size.height = fRet;
        enBtn.frame = frame;
        [view addSubview:enBtn];
    }
    // 右边文字
    {
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        moreBtn.backgroundColor = [UIColor clearColor];
        [moreBtn setTitle:@"更多>>" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#868484"] forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"#FF9000"] forState:UIControlStateHighlighted];
        CGFloat width = 80;
        CGRect frame = CGRectMake(SCREEN_WIDTH-width-margin, 0, width, fRet);
        moreBtn.frame = frame;
        [view addSubview:moreBtn];
    }
    return fRet;
}

- (CGFloat)initThreeCategory:(CGPoint)origin
{
    CGFloat fRet = 200;
    
    return fRet;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.title = @"主页";
    // 去掉list页面的价格
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    self.tabBarController.navigationItem.rightBarButtonItems = self.barbtns;
    [self reloadCategoryView];
    [self reloadCategoryTips];
}
- (void)reloadCategoryView
{
    gdiSingleton *instance = [gdiSingleton getInstance];
    NSArray *cateBySetting = instance.categoryBySetting;
    int count = (int)cateBySetting.count;
    for (int i=0; i<5 && i<count; i++) {
        
        NSDictionary *dict = [cateBySetting objectAtIndex:i];
        NSString *category = [dict objectForKey:@"name"];
        UNUSED(category);
        NSString *productsStr = [dict objectForKey:@"products"];
        NSArray *nos = [productsStr componentsSeparatedByString:@","];
        // 限制个数 5个
        if (nos.count > 5)
        {
            nos = [NSArray arrayWithObjects:nos[0], nos[1], nos[2], nos[3], nos[4], nil];
        }
        NSArray *info = [instance getInfoWithNos:nos];

        gdiAddHScrollView *scroll = (gdiAddHScrollView *)[self.subScrolls objectAtIndex:i];
        [scroll changeByInfo:info];
    }
}
- (void)reloadCategoryTips
{
    gdiSingleton *instance = [gdiSingleton getInstance];
    int count = (int)instance.categoryBySetting.count;
    for (int i=0; i<5 && i<count; i++) {
        NSDictionary *dict = [instance.categoryBySetting objectAtIndex:i];
        NSDictionary *btnDict = [self.categoryTips objectAtIndex:i];
        NSString *tip = [dict objectForKey:@"name"];
        UIButton *tipBtn = [btnDict objectForKey:@"tip"];
        [tipBtn setTitle:tip forState:UIControlStateNormal];
        [tipBtn setTitle:tip forState:UIControlStateDisabled];
        UIButton *moreBtn = [btnDict objectForKey:@"more"];
        [moreBtn setTitle:tip forState:UIControlStateDisabled];
    }
}

- (void)search:(UIButton *)btn
{
    gdiListViewController *list = [[gdiListViewController alloc] initWithCategory:nil];
    [self.tabBarController.navigationController pushViewController:list animated:YES];
    NSLog(@"搜索");
}

- (void)setting:(UIButton *)btn
{
    gdiSettingTableViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"setting"];
//    gdiSettingTableViewController *set = [[gdiSettingTableViewController alloc] init];
    [self.tabBarController.navigationController pushViewController:set animated:YES];
    NSLog(@"设置");
}

- (void)list:(UIButton *)btn
{
//    gdiDetailViewController *detail = [[gdiDetailViewController alloc] initWithInfo:nil];
    gdiSingleton *instance = [gdiSingleton getInstance];
    gdiDetailViewController *detail = instance.detailController;
    [detail changeInfo:nil];
    //    [self presentViewController:detail animated:YES completion:^{}];
    [self.tabBarController.navigationController pushViewController:detail animated:YES];
    NSLog(@"显示子页面");
}

@end
