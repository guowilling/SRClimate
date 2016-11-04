//
//  SearchCityController.m
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "AddCityController.h"
#import "ZYPinYinSearch.h"
#import "ChineseStringTool.h"
#import "SRUserDefaults.h"
#import "SRWeatherDataTool.h"
#import "SRWeatherCityTool.h"

static const CGFloat    hotCitiesHeaderLabelH  = 44;
static const CGFloat    HotCitiesViewInset     = 20;
static const CGFloat    HotCityItemHMargin     = 10;
static const CGFloat    HotCityItemVMargin     = 20;
static const NSInteger  HotCitiesViewMaxColumn = 4;

@interface AddCityController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *hotCities;
@property (nonatomic, strong) NSArray *allCities;
@property (nonatomic, strong) NSMutableArray *searchCities;
@property (nonatomic, strong) NSMutableArray *commonCities;

@property (nonatomic, strong) UIView      *hotCitiesContanier;
@property (nonatomic, weak  ) UITableView *searchCitiesTableView;

@end

@implementation AddCityController

#pragma mark - Life circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = COLOR_BACKGROUND_GRAY;
    
    [self initData];
    
    [self setupNavBar];
    
    [self setupHotCitiesContanier];
    
    [self setupTableView];
}

#pragma mark - Init setting

- (void)initData {
    
    _hotCities    = [SRWeatherCityTool hotCities];
    _allCities    = [SRWeatherCityTool allCities];
    _searchCities = [NSMutableArray array];
    _commonCities = [NSMutableArray arrayWithArray:[SRWeatherCityTool commonCities]];
}

- (void)setupNavBar {
    
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                          target:self
                                                                                          action:@selector(dismissAction)];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"请输入城市名";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void)dismissAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupHotCitiesContanier {
    
    _hotCitiesContanier = [[UIView alloc] init];
    _hotCitiesContanier.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_hotCitiesContanier];
    
    UILabel *hotCitiesLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, hotCitiesHeaderLabelH)];
    hotCitiesLable.text = @"热门城市";
    hotCitiesLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
    [_hotCitiesContanier addSubview:hotCitiesLable];
    
    NSString *title = self.hotCities[0];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:SCREEN_ADJUST(15)]}
                                      context:nil];
    CGFloat hotCityItemH = rect.size.height + 20;
    CGFloat hotCityItemW = (SCREEN_WIDTH - 2 * HotCitiesViewInset - (HotCitiesViewMaxColumn - 1) * HotCityItemHMargin) / HotCitiesViewMaxColumn;
    NSInteger maxRow = self.hotCities.count / HotCitiesViewMaxColumn;
    CGFloat hotCitiesViewH = maxRow * hotCityItemH + HotCityItemVMargin * (maxRow - 1) + 2 * HotCitiesViewInset;
    UIView *hotCitiesView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(hotCitiesLable.frame), SCREEN_WIDTH, hotCitiesViewH)];
    hotCitiesView.backgroundColor = [UIColor whiteColor];
    [_hotCitiesContanier addSubview:hotCitiesView];
    
    for (int i = 0; i < self.hotCities.count; i++) {
        UIButton *hotCityItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [hotCityItem setTitle:self.hotCities[i] forState:UIControlStateNormal];
        [hotCityItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        hotCityItem.frame = CGRectMake(HotCitiesViewInset + i % HotCitiesViewMaxColumn * (hotCityItemW + HotCityItemHMargin),
                                  HotCitiesViewInset + i / HotCitiesViewMaxColumn * (hotCityItemH + HotCityItemVMargin),
                                  hotCityItemW, hotCityItemH);
        hotCityItem.titleLabel.font = [UIFont systemFontOfSize:SCREEN_ADJUST(15)];
        hotCityItem.tag = i;
        hotCityItem.layer.cornerRadius = 20;
        hotCityItem.layer.masksToBounds = YES;
        hotCityItem.layer.borderColor = COLOR_RGBA(220, 220, 220, 1.0).CGColor;
        hotCityItem.layer.borderWidth = 1;
        [hotCityItem addTarget:self action:@selector(hotCityBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [hotCitiesView addSubview:hotCityItem];
    }
    _hotCitiesContanier.frame = CGRectMake(0, 64, SCREEN_WIDTH, hotCitiesHeaderLabelH + hotCitiesViewH);
}

- (void)hotCityBtnAction:(UIButton *)sender {
    
    NSString *city = self.hotCities[sender.tag];
    if ([self.delegate respondsToSelector:@selector(searchCityControllerDidAddCity:)]) {
        [self.delegate searchCityControllerDidAddCity:city];
    }

    [self.navigationItem.titleView resignFirstResponder];
    [self dismissAction];
}

- (void)setupTableView {
    
    UITableView *tableView   = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.dataSource     = self;
    tableView.delegate       = self;
    tableView.contentInset   = UIEdgeInsetsMake(10, 0, 0, 0);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.rowHeight      = 54;
    [self.view addSubview:tableView];
    _searchCitiesTableView        = tableView;
    _searchCitiesTableView.hidden = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 54 - 1, SCREEN_WIDTH, 1)];
        divider.backgroundColor = COLOR_DIVIDERLIN;
        [cell addSubview:divider];
    }
    cell.textLabel.text = self.searchCities[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *city = self.searchCities[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(searchCityControllerDidAddCity:)]) {
        [self.delegate searchCityControllerDidAddCity:city];
    }
    
    [self.navigationItem.titleView resignFirstResponder];
    [self dismissAction];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([self.navigationItem.titleView isFirstResponder]) {
        [self.navigationItem.titleView resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length > 0) {
        _hotCitiesContanier.hidden = YES;
        _searchCitiesTableView.hidden = NO;
        [_searchCities removeAllObjects];
        [_searchCities addObjectsFromArray:[ZYPinYinSearch searchWithOriginalArray:_allCities
                                                                        searchText:searchText
                                                              searchByPropertyName:@"name"]];
    } else {
        _hotCitiesContanier.hidden = NO;
        _searchCitiesTableView.hidden = YES;
    }
    [self.searchCitiesTableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar setText:nil];
    _hotCitiesContanier.hidden = NO;
    _searchCitiesTableView.hidden = YES;
    [self.searchCitiesTableView reloadData];
}

@end
