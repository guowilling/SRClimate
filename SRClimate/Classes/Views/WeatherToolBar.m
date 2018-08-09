//
//  WeatherToolBar.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WeatherToolBar.h"
#import "NSAttributedString+Extension.h"

@interface WeatherToolBar () <UIScrollViewDelegate>

@property (nonatomic, strong) NSString *locationCity;
@property (nonatomic, strong) NSArray  *commonCities;

@property (nonatomic, strong) NSMutableArray *cityLabels;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) UIButton *commonCityBtn;
@property (nonatomic, weak) UIButton *searchCityBtn;

@property (nonatomic, weak) UIButton *cityBtn;
@property (nonatomic, weak) UILabel  *cityLabel;

@end

@implementation WeatherToolBar

- (NSMutableArray *)cityLabels {
    if (!_cityLabels) {
        _cityLabels = [NSMutableArray array];
    }
    return _cityLabels;
}

- (instancetype)initWithLocationCity:(NSString *)locationCity commonCities:(NSArray *)commonCities {
    if (self = [super init]) {
        _locationCity = locationCity;
        _commonCities = commonCities;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    [self addSubview:({
        UIButton *commonCityBtn = [UIButton buttonWithType:UIButtonTypeInfoDark];
        commonCityBtn.tintColor = [UIColor whiteColor];
        commonCityBtn.showsTouchWhenHighlighted = YES;
        [commonCityBtn addTarget:self action:@selector(commonCityBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _commonCityBtn = commonCityBtn;
    })];
    
    [self addSubview:({
        UIButton *searchCityBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
        searchCityBtn.tintColor = [UIColor whiteColor];
        searchCityBtn.showsTouchWhenHighlighted = YES;
        [searchCityBtn addTarget:self action:@selector(searchCityBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _searchCityBtn = searchCityBtn;
    })];
    
    [self addCityScrollView];
    
    [self addCityPageControl];
}

- (void)addCityScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    _cityScrollView = scrollView;
    if (_locationCity) {
        [self creatCityButtonWithLocationCity];
        [self creatCityLabelWithCommonCities];
    } else {
        if (_commonCities.count == 0) {
            [self creatCityLabelWithCityBeiJing];
        } else {
            [self creatCityLabelWithCommonCities];
        }
    }
    [self addSubview:scrollView];
}

- (void)creatCityButtonWithLocationCity {
    UIButton *cityBtn = [[UIButton alloc] init];
    
    NSAttributedString *attrString = [NSAttributedString attributedStringWithString:self.locationCity];
    NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attrString];
    [attrStringM addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attrString.length)];
    [attrStringM addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(20)] range:NSMakeRange(0, attrString.length)];
    [cityBtn setAttributedTitle:attrStringM forState:UIControlStateNormal];
    [cityBtn setImage:[UIImage imageNamed:@"weather_location"] forState:UIControlStateNormal];
    cityBtn.adjustsImageWhenHighlighted = NO;
    cityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [self.cityScrollView addSubview:cityBtn];
    _cityBtn = cityBtn;
}

- (void)creatCityLabelWithCityBeiJing {
    UILabel *cityLabel = [[UILabel alloc] init];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.attributedText = [NSAttributedString attributedStringWithString:@"北京"];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    cityLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(20)];
    [self.cityScrollView addSubview:cityLabel];
    _cityLabel = cityLabel;
}

- (void)creatCityLabelWithCommonCities {
    for (NSInteger i = 0; i < self.commonCities.count; i++) {
        UILabel *cityLabel = [[UILabel alloc] init];
        cityLabel.textColor = [UIColor whiteColor];
        
        cityLabel.attributedText = [NSAttributedString attributedStringWithString:self.commonCities[i]];
        cityLabel.textAlignment = NSTextAlignmentCenter;
        cityLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(20)];
        [self.cityScrollView addSubview:cityLabel];
        [self.cityLabels addObject:cityLabel];
    }
}

- (void)addCityPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    if (_locationCity) {
        pageControl.numberOfPages = _commonCities.count + 1;
    } else {
        if (self.commonCities.count == 0) {
            pageControl.numberOfPages = 1;
        } else {
            pageControl.numberOfPages = _commonCities.count;
        }
    }
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    pageControl.hidesForSinglePage = YES;
    [self addSubview:pageControl];
    _cityPageControl = pageControl;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat margin = SCREEN_ADJUST(20);
    
    self.commonCityBtn.frame = CGRectMake(0, 0, kButtomItemWH, kButtomItemWH);
    self.searchCityBtn.frame = CGRectMake(SCREEN_WIDTH - kButtomItemWH, 0, kButtomItemWH, kButtomItemWH);
    self.cityScrollView.frame = CGRectMake(kButtomItemWH, 0, SCREEN_WIDTH - kButtomItemWH * 2, self.sr_height);
    
    if (self.locationCity) {
        self.cityScrollView.contentSize = CGSizeMake(self.cityScrollView.sr_width * (_commonCities.count + 1), 0);
    } else {
        self.cityScrollView.contentSize = CGSizeMake(self.cityScrollView.sr_width * (_commonCities.count), 0);
    }
    self.cityPageControl.center = CGPointMake(self.sr_width * 0.5, self.sr_height - margin * 0.5);
    
    if (self.cityBtn) {
        self.cityBtn.frame = CGRectMake(kButtomItemWH, 0, self.cityScrollView.sr_width - kButtomItemWH * 2, kButtomItemWH - margin);
    }
    
    if (self.cityLabel) {
        self.cityLabel.frame = CGRectMake(kButtomItemWH, 0, self.cityScrollView.sr_width - kButtomItemWH * 2, kButtomItemWH - margin);
    }
    
    for (NSInteger i = 0; i < self.cityLabels.count; i++) {
        UILabel *label = self.cityLabels[i];
        label.frame = CGRectMake(kButtomItemWH + (i + (_locationCity ? 1 : 0)) * self.cityScrollView.sr_width, 0,
                                 self.cityScrollView.sr_width - kButtomItemWH * 2, kButtomItemWH - margin);
    }
}

- (void)commonCityBtnAction {
    if ([self.delegate respondsToSelector:@selector(weatherToolBarDidClickCommonCityBtnAction)]) {
        [self.delegate weatherToolBarDidClickCommonCityBtnAction];
    }
}

- (void)searchCityBtnAction {
    if ([self.delegate respondsToSelector:@selector(weatherToolBarDidClickSearchCityBtnAction)]) {
        [self.delegate weatherToolBarDidClickSearchCityBtnAction];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.cityScrollView) {
        self.cityPageControl.currentPage = scrollView.contentOffset.x / scrollView.sr_width;
        if (self.currentIndex != self.cityPageControl.currentPage) {
            self.currentIndex = self.cityPageControl.currentPage;
            if ([self.delegate respondsToSelector:@selector(weatherToolBarDidScrollToIndex:)]) {
                [self.delegate weatherToolBarDidScrollToIndex:self.cityPageControl.currentPage];
            }
        }
    }
}

#pragma mark - Public Methods

- (void)updateWithCityname:(NSString *)cityname commonCities:(NSArray *)commonCities {
    _locationCity = cityname;
    _commonCities = commonCities;
    [self.cityLabels removeAllObjects];
    
    [self.cityScrollView removeFromSuperview];
    [self.cityPageControl removeFromSuperview];
    
    [self addCityScrollView];
    [self addCityPageControl];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)updateBackward {
    self.cityPageControl.currentPage -= 1;
    [self.cityScrollView setContentOffset:CGPointMake(self.cityScrollView.sr_width * self.cityPageControl.currentPage, 0) animated:NO];
}

- (void)updateForward {
    self.cityPageControl.currentPage += 1;
    [self.cityScrollView setContentOffset:CGPointMake(self.cityScrollView.sr_width * self.cityPageControl.currentPage, 0) animated:NO];
}

@end
