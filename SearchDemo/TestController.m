//
//  TestController.m
//  SearchDemo
//
//  Created by xfq on 2020/12/8.
//  Copyright © 2020 xfq. All rights reserved.
//

#import "TestController.h"
#import "Masonry.h"
#import "UIImage+ZLResizableImage.h"
#import "ResultViewController.h"
#define ZLSwitchCitySourceName(x)  x

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define Is_Iphone (([[UIDevice currentDevice] userInterfaceIdiom]) == UIUserInterfaceIdiomPhone)
#define Is_IPhoneX (kScreenWidth >=375.0f && kScreenHeight >=812.0f && Is_Iphone)
#define kSpaceW(W) W * (kScreenWidth / 375.0)
#define kSpaceH(H) H * (kScreenWidth / 375.0)


#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#define StatusBar_Height    (Is_IPhoneX ? (44.0):(20.0))
#define TabBar_Height       (Is_IPhoneX ? (49.0 + 34.0):(49.0))
#define NavBar_Height       (44)
#define NavBarAndStatusBar   (StatusBar_Height + NavBar_Height)
#define SearchBar_Height    (55)
#define Bottom_SafeHeight   (Is_IPhoneX ? (34.0):(0))


@interface TestController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, weak) UIView *topNavView;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UIView *bottomView;

//@property (nonatomic, strong) NSArray *cityGroup;
@property (nonatomic, strong) ResultViewController *searchResult;

@end

@implementation TestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTopView];
    [self setupContentView];
    [self _initBottomView];
}

- (void)coverButtonDidClick{
    [self.searchBar resignFirstResponder];
}
- (void)cancelButtonDidClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)_initBottomView{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    _bottomView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_bottomView];
}

static const NSTimeInterval animationDuration = 0.3f;

#pragma mark - searchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:animationDuration animations:^{
        [self.topNavView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(- self.topNavView.bounds.size.height + StatusBar_Height );
        }];
        self.coverButton.alpha = 0.5f;
        [self.view layoutIfNeeded];
    }];
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [UIView animateWithDuration:animationDuration animations:^{
        [self.topNavView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
        self.coverButton.alpha = 0.f;
        [self.view layoutIfNeeded];
    }];
  
    [searchBar setShowsCancelButton:NO animated:YES];
    
    self.searchResult.view.hidden = YES;
    searchBar.text = nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length) {
        self.searchResult.view.hidden = NO;
//        [self.searchResult setSearchText:searchText];
        [self.searchResult ssssssss:searchText];
//        self.searchResult.searchText = searchText;
    } else {
        self.searchResult.view.hidden = YES;
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    ZLCityGroups *cityGroups = self.cityGroup[section];
    return 3;//cityGroups.cities.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *cellID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
//    ZLCityGroups *cityGoups = self.cityGroup[indexPath.section];
    cell.textLabel.text = @"1";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ZLCityGroups *cityGroup = self.cityGroup[indexPath.section];
//    // 发出通知
//    [NS_NOTIFICATION_CENTER postNotificationName:ZLCityDidChangeNotification object:nil userInfo:@{ZLSelectCityName : cityGroup.cities[indexPath.row]}];
//    [self dismiss];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
//    ZLCityGroups *cityGroups = self.cityGroup[section];
    return @"2";//cityGroups.title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"3"];//[self.cityGroup valueForKey:@"title"];
}



- (void)setupTopView
{
    UIView *topNavView = ({
        UIView *view = [[UIView alloc] init];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor redColor];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.mas_equalTo(44 + StatusBar_Height);
        }];
        view;
    });
    self.topNavView = topNavView;
    
    UIImageView *topBackImageView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        [topNavView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(topNavView);
        }];
        imageView;
    });
    topBackImageView.image = [UIImage imageNamed:@"bg_navigationBar_normal"];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topNavView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(topNavView);
        make.width.height.equalTo(@30);
        make.left.equalTo(@8);
    }];
    [cancelButton setImage:[UIImage imageNamed:ZLSwitchCitySourceName(@"btn_navigation_close")] forState:UIControlStateNormal];
    [cancelButton setImage:[UIImage imageNamed:ZLSwitchCitySourceName(@"btn_navigation_close_hl")] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [topNavView addSubview:titleLabel];
    titleLabel.text = @"切换城市";
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(topNavView);
    }];
}

- (void)setupContentView
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:searchBar];
//    searchBar.backgroundColor = [UIColor orangeColor];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.topNavView.mas_bottom).offset(15);
        make.height.equalTo(@35);
    }];
    searchBar.delegate = self;
    [searchBar setBackgroundImage:[UIImage new]];
    ///并不是搜索框的颜色
//    searchBar.backgroundColor = [UIColor cyanColor];
    if (@available(iOS 13.0, *)) {
        searchBar.searchTextField.backgroundColor = [UIColor cyanColor];
    } else {
         UITextField *searchField = [searchBar valueForKey:@"searchField"];
        searchField.backgroundColor = [UIColor cyanColor];
    }
    searchBar.placeholder = @"请输入城市名或拼音";
    searchBar.tintColor = UIColorWithRGBA(32, 191, 179, 1.f);
    self.searchBar = searchBar;
    

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49-Bottom_SafeHeight);
        make.top.equalTo(searchBar.mas_bottom).offset(15);
    }];
    tableView.sectionIndexColor = UIColorWithRGBA(32, 191, 179, 1.f);
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    
    UIButton *coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:coverButton];
    [coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableView);
    }];
    coverButton.backgroundColor = [UIColor redColor];
    coverButton.alpha = 0.f;
    [coverButton addTarget:self action:@selector(coverButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    self.coverButton = coverButton;
    
    ResultViewController *searchResult = [[ResultViewController alloc] init];
    [self.view addSubview:searchResult.view];
    [searchResult.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coverButton);
    }];
    searchResult.view.hidden = YES;
//    [searchResult.view setupDidSelectedCityHandler:^{
//        [self dismiss];
//    }];
    self.searchResult = searchResult;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)keyboardWillHide:(NSNotification *)notify{
    
}
- (void)keyboardWillShow:(NSNotification *)notify{
    
}
- (void)keyboardChangeFrame:(NSNotification *)notify{
    CGRect keyboardFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect f =   _bottomView.frame;
    f.origin.y = keyboardFrame.origin.y - 49;
    
    _bottomView.frame = f;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

@end
