//
//  gdiListViewController.m
//  GDiPhone
//
//  Created by YuDa on 14-9-24.
//  Copyright (c) 2014年 YuDa. All rights reserved.
//

#import "gdiListViewController.h"
#import "gdiProductView.h"
#import "gdiCategoryTableViewController.h"
#import "gdiPriceTableViewController.h"

@interface gdiListViewController ()<UISearchBarDelegate>
@property (nonatomic, strong) UIBarButtonItem *btnList;
@property (nonatomic, strong) UIBarButtonItem *btnListPrice;
@property (nonatomic, strong) UIView *priceView; // 放在btnListPrice上面的view
@property (nonatomic, strong) UIBarButtonItem *btnListRefresh;
@property (nonatomic, strong) NSMutableArray *productViewArray;
@property (nonatomic, strong) UISearchBar * search;
// 通过navigation push的不需要考虑状态栏和导航栏
@property (nonatomic) BOOL byPush;
@property (nonatomic) CGPoint origin;
@property (strong, nonatomic) NSString *searchKey;
@property (strong, nonatomic) NSString *currentPrice;
@property (strong, nonatomic) NSString *currentCategory;

@property (strong, nonatomic) NSString *oldPrice;
@property (strong, nonatomic) NSString *oldCategory;

@property (nonatomic) BOOL isReversedOrder;  // 是否是倒序
@end

static NSString *identifier = @"cell";
@implementation gdiListViewController

static bool changeTitle = false;

- (id)initWithCategory:(NSString *)category
{
    self = [super init];
    if (self)
    {
        self.byPush = YES;
        if (category == nil)
        {
            self.currentCategory = @"所有";
        }
        else
        {
            self.currentCategory = category;
        }
        self.oldCategory = self.currentCategory;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.strTitle == nil && (self.currentCategory == nil || self.currentCategory.length == 0))
    {
        self.strTitle = @"所有";
    }
    if (self.currentCategory == nil)
    {
        self.oldCategory = @"所有";
        self.currentCategory = @"所有";
    }
    if (self.byPush)
    {
        self.searchKey = kInfoCategory;
    }
    else
    {
        self.searchKey = kInfoBand;
    }
    self.isReversedOrder = NO;
    self.currentPrice = @"所有";
    self.oldPrice = @"所有";
    [self changeTitle];
    gdiSingleton *instance = [gdiSingleton getInstance];
    self.array = [[instance getArrayWithKey:self.searchKey andTypeValues:@[self.currentCategory] enablePart:YES] mutableCopy];
    
    self.origin = CGPointMake(0, 0);
    if (!self.byPush)
    {
        _origin.y += [gdiHelper captionHeight];
        if ([gdiHelper isiOS7])
        {
            _origin.y += 20;
        }
    }
    // 添加priceView
    self.priceView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-98-20, 0, 20+40, 40)];
//    self.priceView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    self.priceView.backgroundColor = [UIColor clearColor];
    // 为价格添加触摸事件
    {
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [self.priceView addGestureRecognizer:singleTapGestureRecognizer];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [self.priceView addGestureRecognizer:doubleTapGestureRecognizer];
        
        //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    }
    
    self.productViewArray = [NSMutableArray array];
    
    // 初始化搜索
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.search.delegate = self;
    CGRect frame = self.search.frame;
    frame.origin = CGPointMake(0, _origin.y);
    self.search.frame = frame;
    self.search.showsCancelButton = YES;
    self.search.placeholder = @"输入商品名或类别";
    [self.baseScroll addSubview:self.search];
    _origin.y += self.search.frame.size.height;
    {
        CGFloat tabbarHeight = 0;
        if (self.byPush) {
            tabbarHeight = 40;
        }
        self.listScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _origin.y, SCREEN_WIDTH, SCREEN_HEIGHT-_origin.y-tabbarHeight)];
        self.listScroll.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        self.listScroll.contentSize = self.listScroll.frame.size;
        [self.baseScroll addSubview:self.listScroll];
        self.listScroll.alwaysBounceVertical = YES;
        // 这个是让子视图能接收触摸事件
        self.listScroll.userInteractionEnabled = YES;
    }
    [self updateListView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.search resignFirstResponder];
    [self.priceView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.search resignFirstResponder];
    self.tabBarController.title = self.strTitle;
    self.navigationController.title = self.strTitle;
    // 这个修改tabbar底下的标签
    if (self.byPush)
    {
        self.title = self.strTitle;
    }
    [self.baseScroll scrollsToTop];
    [self.listScroll scrollsToTop];
    
    // 搜索按钮
//    self.btnList = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"list_bullets"] style:UIBarButtonItemStylePlain target:self action:@selector(list:)];
    NSString *title = nil;
    if ([self.searchKey isEqualToString:kInfoCategory])
    {
        title = @"分类";
    }
    else
    {
        title = @"品牌";
    }
    self.btnList = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(list:)];
    NSString *priceStr = @"价格⬆️";
    if (self.isReversedOrder) {
        priceStr = @"价格⬇️";
    }
    self.btnListPrice = [[UIBarButtonItem alloc] initWithTitle:priceStr style:UIBarButtonItemStylePlain target:self action:@selector(doNothing:)];
//    self.btnListPrice.enabled = NO;
//    self.btnListPrice.tintColor = [UIColor blueColor];
    self.btnListRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    
    NSArray *btns = @[self.btnList, self.btnListPrice, self.btnListRefresh];
//    self.tabBarController.navigationItem.rightBarButtonItem = self.btnList;
//    self.navigationItem.rightBarButtonItem = self.btnList;
    
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    nav.topViewController.navigationItem.rightBarButtonItem = self.btnList;
    nav.topViewController.navigationItem.rightBarButtonItems = btns;
    
    if (self.byPush)
    {
        [self.navigationController.navigationBar addSubview:self.priceView];
        [self.navigationController.navigationBar bringSubviewToFront:self.priceView];
    }
    else
    {
        [self.tabBarController.navigationController.navigationBar addSubview:self.priceView];
        [self.tabBarController.navigationController.navigationBar bringSubviewToFront:self.priceView];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"singleTap");
    [self listPrice:self.btnListPrice];
}
- (void)doubleTap:(UITapGestureRecognizer *)tap
{
    NSLog(@"doubleTap");
    if ([self.btnListPrice.title isEqualToString:@"价格⬆️"])
    {
        self.btnListPrice.title = @"价格⬇️";
        self.isReversedOrder = YES;
    }
    else
    {
        self.btnListPrice.title = @"价格⬆️";
        self.isReversedOrder = NO;
    }
    [self changePrice:self.currentPrice];
}

- (void)list:(UIBarButtonItem *)bar
{
    [self.search resignFirstResponder];
    gdiCategoryTableViewController * ctv = [[gdiCategoryTableViewController alloc] initWithKey:self.searchKey];
    ctv.currentCategory = self.currentCategory;
    ctv.uddelegate = self;
//    [self.tabBarController.navigationController pushViewController:ctv animated:YES];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:ctv animated:YES];
}

- (void)doNothing:(UIBarButtonItem *)bar
{
    
}


- (void)listPrice:(UIBarButtonItem *)bar
{
    [self.search resignFirstResponder];
    gdiPriceTableViewController * ctv = [[gdiPriceTableViewController alloc] init];
    ctv.currentPrice = self.currentPrice;
    ctv.uddelegate = self;
    //    [self.tabBarController.navigationController pushViewController:ctv animated:YES];
    UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [nav pushViewController:ctv animated:YES];
}

- (void)refresh:(UIBarButtonItem *)bar
{
    self.currentCategory = self.oldCategory;
    self.currentPrice = self.oldPrice;
    [self changeTitle];
    gdiSingleton *instance = [gdiSingleton getInstance];
    NSArray *array = [instance getArrayWithKey:self.searchKey andTypeValues:@[self.currentCategory] enablePart:YES];
    NSArray *tmp = [instance getArrayWithPrice:self.currentPrice];
    self.array = [[self getArray:array andArray:tmp] mutableCopy];
    [self updateListView];
}

- (void)reloadArray
{
    gdiSingleton *instance = [gdiSingleton getInstance];
    self.array = [instance.productArray mutableCopy];
}

- (void)updateListView
{
    NSUInteger viewcount = self.productViewArray.count;
    for (int i=0; i<viewcount; i++)
    {
        UIView *view = [self.productViewArray objectAtIndex:i];
        [view removeFromSuperview];
    }
    [self.productViewArray removeAllObjects];
    CGFloat productPadding = 10;
    CGFloat productWidth = (SCREEN_WIDTH-productPadding*5)/4;
    // 默认是200，根据ProductView自适应
    CGFloat productHeight = 200;
    
    NSUInteger num = self.array.count;
    for (int i=0; i<num; i++)
    {
        CGFloat x = (i%4)*(productWidth+productPadding)+productPadding;
        CGFloat y = (i/4)*productHeight;
//        gdiProductView *productView = [[gdiProductView alloc] initWidthName:[NSString stringWithFormat:@"product%d", i+1] frame:CGRectMake(x, y, productWidth, productHeight)];
        gdiProductView *productView = [[gdiProductView alloc] initWidthInfo:[self.array objectAtIndex:i] frame:CGRectMake(x, y, productWidth, productHeight)];
        NSLog(@"productHeigth %.2f", productHeight);
        productHeight = productHeight < productView.frame.size.height ? productView.frame.size.height : productHeight;
        
        NSLog(@"productHeigth %.2f", productHeight);
        CGRect frame = productView.frame;
        frame.origin = CGPointMake(productView.frame.origin.x, (i/4)*(productHeight+10));
        productView.frame = frame;
        
        [self.listScroll addSubview:productView];
        [self.productViewArray addObject:productView];
        
    }
    // !!!
    // 这里加了100，所有商品的list页面变的正常，没搞懂
    CGFloat height = (num/4+1)*productHeight+_origin.y+100;
    if (self.listScroll.contentSize.height < height)
    {
        CGSize size = self.listScroll.contentSize;
        size.height = height;
        self.listScroll.contentSize = size;
    }
}

#pragma mark - UISearchBarDelegate Method
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *str = searchBar.text;
    if (str.length > 0)
    {
        gdiSingleton *instance = [gdiSingleton getInstance];
//        self.array = [[instance getCategoryArray:str] mutableCopy];
//        [self.array addObjectsFromArray:[instance getCategoryArrayWithPartCategory:str]];
//        [self.array addObjectsFromArray:[instance getArrayWithPartName:str]];
        self.array = [[instance getArrayWithKey:self.searchKey andStr:str andTypes:@[kInfoName, kInfoBand, kInfoCategory, kInfoDependency] enablePart:YES] mutableCopy];
        
    }
    else
    {
        [self reloadArray];
    }
    [self updateListView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    
}

- (void)changeCategory:(NSString *)category
{
    self.currentCategory = category;
    [self changeTitle];
    gdiSingleton *instance = [gdiSingleton getInstance];
    NSArray *array = [instance getArrayWithKey:self.searchKey andTypeValues:@[self.currentCategory] enablePart:YES];
    NSArray *tmp = [instance getArrayWithPrice:self.currentPrice];
    self.array = [[self getArray:array andArray:tmp] mutableCopy];
    [self sort];
    [self updateListView];
}

- (void)changePrice:(NSString *)price
{
    self.currentPrice = price;
    [self changeTitle];
    gdiSingleton *instance = [gdiSingleton getInstance];
    NSArray *array = [instance getArrayWithKey:self.searchKey andTypeValues:@[self.currentCategory] enablePart:YES];
    NSArray *tmp = [instance getArrayWithPrice:price];
    self.array = [[self getArray:array andArray:tmp] mutableCopy];
    [self sort];
    [self updateListView];
}
- (void)sort
{
    self.array = [self.array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
    {
        int a = [[obj1 objectForKey:kInfoPrice] intValue];
        int b = [[obj2 objectForKey:kInfoPrice] intValue];
        if (a > b)
        {
            if (self.isReversedOrder)
            {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }
        else if (a < b)
        {
            if (self.isReversedOrder) {
                return NSOrderedDescending;
            }
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (NSArray *)getArray:(NSArray *)arr1 andArray:(NSArray *)arr2
{
    NSUInteger count1 = arr1.count;
    NSUInteger count2 = arr2.count;
    NSMutableArray *result = [NSMutableArray array];
    for (int i=0; i<count1; i++)
    {
        NSDictionary *info1 = [arr1 objectAtIndex:i];
        for (int j=0; j<count2; j++)
        {
            NSDictionary *info2 = [arr2 objectAtIndex:j];
            if ([info1 isEqual:info2])
            {
                [result addObject:info1];
            }
        }
    }
    return result;
}

- (void)changeTitle
{
    NSString *priceSort = @"升序";
    if (self.isReversedOrder)
    {
        priceSort = @"降序";
    }
    if ([self.currentCategory isEqualToString:@"所有"] && [self.currentPrice isEqualToString:@"所有"])
    {
        if (changeTitle)
        {
            self.strTitle = [NSString stringWithFormat:@"所有(价格%@)", priceSort];
        }
    }
    else
    {
        NSString *tmpStr = nil;
        if ([self.searchKey isEqualToString:kInfoBand])
        {
            tmpStr = @"品牌";
        }
        else
        {
            tmpStr = @"分类";
        }
        if (changeTitle)
        {
            self.strTitle = [NSString stringWithFormat:@"价格(%@):%@, %@:%@", priceSort, self.currentPrice, tmpStr, self.currentCategory];
        }
    }
    if (changeTitle)
    {
        self.tabBarController.title = self.strTitle;
        self.navigationController.title = self.strTitle;
        // 这个修改tabbar底下的标签
        if (self.byPush)
        {
            self.title = self.strTitle;
        }
    }
}



@end
