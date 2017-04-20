//
//  WeatherMainViewController.m
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "MainViewController.h"
#import "SettingCityController.h"
#import "AddCityController.h"
#import "WeatherLineChart.h"
#import "WeatherToolBar.h"
#import "WeatherGeneralInfoView.h"
#import "WeatherDetailInfoView.h"
#import "SRUserDefaults.h"
#import "SRLocationTool.h"
#import "SRWeatherDataTool.h"
#import "SRWeatherCityTool.h"
#import "MJExtension.h"
#import "NowWeatherData.h"
#import "CityWeatherData.h"
#import "SRWeatherAssist.h"

#define kWeatherGeneralH  SCREEN_ADJUST(150)
#define kWeatherGeneralW  SCREEN_WIDTH - SCREEN_ADJUST(20)
#define kWeatherGeneralY  SCREEN_HEIGHT - kWeatherGeneralH - SCREEN_ADJUST(150)

@interface MainViewController () <UIScrollViewDelegate, SettingCityControllerDelegate, WeatherToolBarDelegate, SRLocationToolDelegate, AddCityControllerDelegate>

@property (nonatomic, copy) NSDictionary   *weatherData;

@property (nonatomic, weak) UIImageView    *backgroundImageView;
@property (nonatomic, weak) WeatherToolBar *weatherToolBar;

@property (nonatomic, strong) NSMutableArray       *commonCities;
@property (nonatomic, strong) NSMutableDictionary  *cachedWeatherDatas;

@property (nonatomic, strong) WeatherGeneralInfoView *weatherGeneralInfoView;
@property (nonatomic, strong) WeatherDetailInfoView  *weatherDetailInfoView;
@property (nonatomic, assign, getter = isShowDetailWeather) BOOL showDetailWeather;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRight;

@property (nonatomic, strong) UIView *errorTipsView;

@property (nonatomic, strong) SettingCityController *settingCityC;

@end

@implementation MainViewController

#pragma mark - Lazy load

- (NSArray *)commonCities {
    
    if (!_commonCities) {
        _commonCities = [NSMutableArray arrayWithArray:[SRWeatherCityTool commonCities]];
    }
    return _commonCities;
}

- (NSMutableDictionary *)cachedWeatherDatas {
    
    if (!_cachedWeatherDatas) {
        _cachedWeatherDatas = [NSMutableDictionary dictionaryWithDictionary:[SRWeatherDataTool cachedWeatherDatas]];
    }
    return _cachedWeatherDatas;
}

- (UISwipeGestureRecognizer *)swipeUP {
    
    if (!_swipeUp) {
        _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGeneralInfoViewUP)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUp;
}

- (UISwipeGestureRecognizer *)swipeDown {
    
    if (!_swipeDown) {
        _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGeneralInfoViewDown)];
        _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swipeDown;
}

- (UISwipeGestureRecognizer *)swipeLeft {
    
    if (!_swipeLeft) {
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGeneralInfoViewLeft)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _swipeLeft;
}

- (UISwipeGestureRecognizer *)swipeRight {
    
    if (!_swipeRight) {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGeneralInfoViewRight)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _swipeRight;
}

- (UIView *)errorTipsView {
    
    if (!_errorTipsView) {
        _errorTipsView = [[UIView alloc] init];
        CGFloat frameX = SCREEN_ADJUST(40);
        CGFloat frameW = SCREEN_WIDTH - 2 * frameX;
        CGFloat frameH = SCREEN_ADJUST(100);
        CGFloat frameY = (SCREEN_HEIGHT - frameH) * 0.5;
        _errorTipsView.frame = CGRectMake(frameX, frameH, frameW, frameY);
        _errorTipsView.layer.cornerRadius = 5;
        _errorTipsView.layer.masksToBounds = YES;
        _errorTipsView.backgroundColor = [UIColor clearColor];
        
        UILabel *titleTipsLable = [[UILabel alloc] init];
        titleTipsLable.frame = CGRectMake(0, SCREEN_ADJUST(10), _errorTipsView.sr_width, SCREEN_ADJUST(20));
        titleTipsLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(18)];
        titleTipsLable.textColor = [UIColor whiteColor];
        titleTipsLable.textAlignment = NSTextAlignmentCenter;
        titleTipsLable.adjustsFontSizeToFitWidth = YES;
        titleTipsLable.text = @"没有天气数据";
        [_errorTipsView addSubview:titleTipsLable];
        
        UILabel *introTipsLable = [[UILabel alloc] init];
        introTipsLable.frame = CGRectMake(0, titleTipsLable.sr_bottom + SCREEN_ADJUST(10), _errorTipsView.sr_width, SCREEN_ADJUST(20));
        introTipsLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(16)];
        introTipsLable.textColor = [UIColor whiteColor];
        introTipsLable.text = @"请检查您的网络或稍后再试";
        introTipsLable.textAlignment = NSTextAlignmentCenter;
        introTipsLable.adjustsFontSizeToFitWidth = YES;
        [_errorTipsView addSubview:introTipsLable];
        
        [self.view addSubview:_errorTipsView];
        frameH = SCREEN_ADJUST(introTipsLable.sr_bottom - titleTipsLable.sr_y + SCREEN_ADJUST(20));
        frameY = (SCREEN_HEIGHT - frameH) * 0.5;
        _errorTipsView.frame = CGRectMake(frameX, frameY, frameW, frameH);

        _errorTipsView.hidden = YES;
    }
    return _errorTipsView;
}

#pragma mark - Life circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupBackgroundImageView];
    
    [self setupWeatherToolBar];
    
    [self setupWeatherGeneralInfoView];
    
    [self setupWeatherDetailInfoView];
    
    [self beginLocation];
}

- (void)beginLocation {
    
    [SRLocationTool sharedInstance].delegate = self;
    
    if ([SRUserDefaults boolForKey:kHasRequestLocationAuthorization]) {
        if ([SRLocationTool sharedInstance].isAutoLocation) {
            [[SRLocationTool sharedInstance] beginLocation];
            
            NSString *city = [SRLocationTool sharedInstance].currentLocationCity;
            NSString *cityid = [SRWeatherCityTool cityidOfCityname:city];
            if (city && cityid) {
                [self loadWeatherDataOfCity:city cityid:cityid];
            } else {
                [self loadWeatherDataOfCommonCity];
            }
        } else {
            [self loadWeatherDataOfCommonCity];
        }
    } else {
        [SRUserDefaults setBool:YES forKey:kHasRequestLocationAuthorization];
        [[SRLocationTool sharedInstance] requestAuthorization];
    }
}

#pragma mark - Setup UI

- (void)setupBackgroundImageView {
    
    [self.view addSubview:({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.view.bounds;
        _backgroundImageView = imageView;
    })];
}

- (void)setupWeatherToolBar {
    
    [self.view addSubview:({
        WeatherToolBar *weatherToolBar = nil;
        if ([SRLocationTool sharedInstance].isAutoLocation && [SRLocationTool sharedInstance].currentLocationCity) {
            weatherToolBar = [[WeatherToolBar alloc] initWithLocationCity:[SRLocationTool sharedInstance].currentLocationCity
                                                             commonCities:self.commonCities];
        } else {
            weatherToolBar = [[WeatherToolBar alloc] initWithLocationCity:nil commonCities:self.commonCities];
        }
        weatherToolBar.frame = CGRectMake(0, SCREEN_HEIGHT - SCREEN_ADJUST(49) - SCREEN_ADJUST(20), SCREEN_WIDTH, SCREEN_ADJUST(49));
        weatherToolBar.delegate = self;
        _weatherToolBar = weatherToolBar;
    })];
}

- (void)setupWeatherGeneralInfoView {
    
    [self.view addSubview:({
        WeatherGeneralInfoView *weatherGeneralInfoView = [[WeatherGeneralInfoView alloc] init];
        weatherGeneralInfoView.frame = CGRectMake(SCREEN_ADJUST(20), kWeatherGeneralY, kWeatherGeneralW, kWeatherGeneralH);
        weatherGeneralInfoView.hidden = YES;
        [weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
        [weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
        [weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
        _weatherGeneralInfoView = weatherGeneralInfoView;
    })];
}

- (void)setupWeatherDetailInfoView {
    
    [self.view addSubview:({
        CGFloat weatherDetailInfoViewY     = kWeatherGeneralH + SCREEN_ADJUST(20);
        CGFloat weatherDetailInfoViewH     = SCREEN_HEIGHT - weatherDetailInfoViewY - kButtomContainerH;
        _weatherDetailInfoView             = [[WeatherDetailInfoView alloc] init];
        _weatherDetailInfoView.frame       = CGRectMake(0, weatherDetailInfoViewY, SCREEN_WIDTH, weatherDetailInfoViewH);
        _weatherDetailInfoView.delegate    = self;
        _weatherDetailInfoView.transform   = CGAffineTransformMakeScale(0, 0);
        _weatherDetailInfoView.contentSize = CGSizeMake(0, kHourlyWeatherInfoViewH + kDailyWeatherInfoViewH);
        _weatherDetailInfoView.alwaysBounceVertical = YES;
        _weatherDetailInfoView.showsVerticalScrollIndicator = NO;
        _weatherDetailInfoView.alpha = 0;
        _weatherDetailInfoView;
    })];
}

#pragma mark - Monitor method

- (void)swipeGeneralInfoViewUP {

    self.showDetailWeather = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.frame = CGRectMake(SCREEN_ADJUST(20), SCREEN_ADJUST(20), kWeatherGeneralW, kWeatherGeneralH);
    } completion:^(BOOL finished) {
        _weatherGeneralInfoView.indicatorIcon.image = [UIImage imageNamed:@"wea_indicator_down"];
        [_weatherGeneralInfoView addGestureRecognizer:self.swipeDown];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeUP];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeLeft];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeRight];
    }];
    
    [self updateWeatherDetailInfoView:self.weatherData];
    [UIView animateWithDuration:0.75 animations:^{
        _weatherDetailInfoView.alpha = 1.0;
        _weatherDetailInfoView.transform = CGAffineTransformIdentity;
    }];
}

- (void)swipeGeneralInfoViewDown {
    
    if (!self.isShowDetailWeather) {
        return;
    }

    self.showDetailWeather = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.sr_y = kWeatherGeneralY;
    } completion:^(BOOL finished) {
        _weatherGeneralInfoView.indicatorIcon.image = [UIImage imageNamed:@"wea_indicator_up"];
        [_weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
        [_weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
        [_weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeDown];
    }];
    
    _weatherDetailInfoView.alpha = 0;
    _weatherDetailInfoView.transform = CGAffineTransformMakeScale(0, 0);
}

- (void)swipeGeneralInfoViewLeft {
    
    if (self.weatherToolBar.cityPageControl.currentPage == self.weatherToolBar.cityPageControl.numberOfPages - 1) {
        return;
    }
    
    [self.weatherToolBar updateForward];
    
    WeatherGeneralInfoView *weatherGeneralInfoViewOld = _weatherGeneralInfoView;
    [UIView animateWithDuration:0.4 animations:^{
        weatherGeneralInfoViewOld.sr_x  = - kWeatherGeneralW;
        weatherGeneralInfoViewOld.alpha = 0;
    } completion:^(BOOL finished) {
        [weatherGeneralInfoViewOld removeFromSuperview];
    }];
    
    _weatherGeneralInfoView = [[WeatherGeneralInfoView alloc] init];
    _weatherGeneralInfoView.frame = CGRectMake(kWeatherGeneralW, kWeatherGeneralY, kWeatherGeneralW, kWeatherGeneralH);
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
    [self.view addSubview:_weatherGeneralInfoView];
    
    _weatherGeneralInfoView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.sr_x  = SCREEN_ADJUST(20);
        _weatherGeneralInfoView.alpha = 1.0;
    }];
    
    [self loadWeatherDataWithIndex:self.weatherToolBar.cityPageControl.currentPage];
}

- (void)swipeGeneralInfoViewRight {
    
    if (self.weatherToolBar.cityPageControl.currentPage == 0) {
        return;
    }

    [self.weatherToolBar updateBackward];
    
    WeatherGeneralInfoView *weatherGeneralInfoViewOld = _weatherGeneralInfoView;
    [UIView animateWithDuration:0.4 animations:^{
        weatherGeneralInfoViewOld.sr_x  = SCREEN_WIDTH;
        weatherGeneralInfoViewOld.alpha = 0;
    } completion:^(BOOL finished) {
        [weatherGeneralInfoViewOld removeFromSuperview];
    }];
    
    _weatherGeneralInfoView = [[WeatherGeneralInfoView alloc] init];
    _weatherGeneralInfoView.frame = CGRectMake(-kWeatherGeneralW, kWeatherGeneralY, kWeatherGeneralW, kWeatherGeneralH);
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
    [self.view addSubview:_weatherGeneralInfoView];
    
    _weatherGeneralInfoView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.sr_x  = SCREEN_ADJUST(15);
        _weatherGeneralInfoView.alpha = 1.0;
    }];
    
    [self loadWeatherDataWithIndex:self.weatherToolBar.cityPageControl.currentPage];
}

#pragma mark - Tool method

- (void)updateContent:(NSDictionary *)weatherData {
    
    self.errorTipsView.hidden = YES;
    self.weatherGeneralInfoView.hidden = NO;
    self.weatherDetailInfoView.hidden = NO;
    
    [self updateWeatherGeneralInfoView:weatherData];
    [self updateWeatherDetailInfoView:weatherData];
}

- (void)updateWeatherGeneralInfoView:(NSDictionary *)weatherData {
    
    NSDictionary *nowWeatherInfo = weatherData[@"HeWeather data service 3.0"][0][@"now"];
    NSDictionary *cityWeatherInfo = weatherData[@"HeWeather data service 3.0"][0][@"aqi"][@"city"];
    if (!nowWeatherInfo || !cityWeatherInfo) {
        _errorTipsView.hidden = NO;
        _weatherGeneralInfoView.hidden = YES;
        _weatherDetailInfoView.hidden = YES;
        return;
    }
    
    NowWeatherData *nowWeatherData = [NowWeatherData mj_objectWithKeyValues:nowWeatherInfo];
    CityWeatherData *cityWeatherData = [CityWeatherData mj_objectWithKeyValues:cityWeatherInfo];
    [self.weatherGeneralInfoView updateWeatherInfoWithNowWeatherInfo:nowWeatherData cityWeatherInfo:cityWeatherData];

    NSInteger weatherCode = [nowWeatherData.code integerValue];
    _backgroundImageView.image = [UIImage imageNamed:[SRWeatherAssist getBackgroundImageNameWithWeatherCode:weatherCode]];
}

- (void)updateWeatherDetailInfoView:(NSDictionary *)weatherData {
    
    [_weatherDetailInfoView setWeatherData:weatherData];
}

#pragma mark - SettingCityControllerDelegate

- (void)settingCityControllerDidOpenAutoLocation {
    
    [[SRLocationTool sharedInstance] beginLocation];
}

- (void)settingCityControllerDidCloseAutoLocation {
    
    if (_settingCityC) {
        [_settingCityC reloadCommonCityTableViewIsInsert:NO];
    }
    
    [self reloadWeatherData];
}

- (void)settingCityControllerDidSelectCity:(NSString *)city isLocationCity:(BOOL)isLocationCity {
    
    if (self.isShowDetailWeather) {
        [self swipeGeneralInfoViewDown];
    }
    
    if (isLocationCity) {
        if (self.weatherToolBar.cityPageControl.currentPage == 0) {
            return;
        }
        [self.weatherToolBar.cityPageControl setCurrentPage:0];
        [self.weatherToolBar.cityScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self loadWeatherDataOfCity:city cityid:[SRWeatherCityTool cityidOfCityname:city]];
    } else {
        NSInteger currentIndex = [self.commonCities indexOfObject:city];
        if ([SRLocationTool sharedInstance].isAutoLocation) {
            if ([SRLocationTool sharedInstance].currentLocationCity) {
                currentIndex += 1;
            }
        }
        if (self.weatherToolBar.cityPageControl.currentPage == currentIndex) {
            return;
        }
        [self.weatherToolBar.cityPageControl setCurrentPage:currentIndex];
        [self.weatherToolBar.cityScrollView setContentOffset:CGPointMake(self.weatherToolBar.cityScrollView.sr_width * currentIndex, 0) animated:NO];
        [self loadWeatherDataOfCity:city cityid:[SRWeatherCityTool cityidOfCityname:city]];
    }
}

- (void)settingCityControllerDidDeleteCommonCity:(NSString *)city {
    
    [self.commonCities removeObject:city];
    [SRWeatherCityTool saveCommonCities:[self.commonCities copy]];
    
    [self reloadWeatherData];
}

- (void)settingCityControllerDidReorderCommonCity {
    
    self.commonCities = [NSMutableArray arrayWithArray:[SRWeatherCityTool commonCities]];
    
    [self reloadWeatherData];
}

#pragma mark - SearchCityControllerDelegate

- (void)addCityControllerDidAddCity:(NSString *)city {
    
    if (![self.commonCities containsObject:city]) {
        if (self.commonCities.count == 12) {
            [MBProgressHUD sr_showInfoWithMessage:@"最多只能添加12个常用城市" onView:self.view];
        } else {
            [self.commonCities addObject:city];
            [SRWeatherCityTool saveCommonCities:[self.commonCities copy]];
            
            [self reloadWeatherData];
        }
    } else {
        [MBProgressHUD sr_showInfoWithMessage:@"该城市已添加" onView:self.view];
    }
}

#pragma mark - WeatherToolBarDelegate

- (void)weatherToolBarDidClickCommonCityBtnAction {
    
    _settingCityC = [[SettingCityController alloc] init];
    _settingCityC.delegate = self;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:_settingCityC];
    [self presentViewController:navC animated:YES completion:nil];
}

- (void)weatherToolBarDidClickSearchCityBtnAction {
    
    AddCityController *addCityC = [[AddCityController alloc] init];
    addCityC.delegate = self;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:addCityC];
    [self presentViewController:navC animated:YES completion:nil];
}

- (void)weatherToolBarDidScrollToIndex:(NSInteger)index {
    
    [self loadWeatherDataWithIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.isShowDetailWeather) {
        return;
    }
    
    if (scrollView != self.weatherDetailInfoView) {
        return;
    }
    if (scrollView.contentOffset.y < 0) {
        CGFloat contentOffsetY = -scrollView.contentOffset.y;
        CGFloat alpha = 1 - (CGFloat)contentOffsetY / 75;
        CGFloat scale = 1 - (CGFloat)contentOffsetY / 300;
        self.weatherDetailInfoView.alpha = alpha;
        self.weatherDetailInfoView.transform = CGAffineTransformMakeScale(scale, scale);
        if (contentOffsetY >= 75) {
            [self swipeGeneralInfoViewDown];
        }
    }
}

#pragma mark - LocationToolDelegate

- (void)locationToolLocationServicesDisabled {
    
    [_settingCityC reloadCommonCityTableViewIsInsert:NO];
    
    [MBProgressHUD sr_showInfoWithMessage:@"请打开定位服务" onView:self.view];
    
    [self loadWeatherDataOfCommonCity];
}

- (void)locationToolLocationServicesAuthorizationStatusDidChange { }

- (void)locationToolLocationServicesAuthorizationStatusDenied {
    
    [_settingCityC reloadCommonCityTableViewIsInsert:NO];
    
    [MBProgressHUD sr_showInfoWithMessage:@"请打开定位服务\n设置->隐私->定位服务->SRClimate" onView:self.view];
    
    [self loadWeatherDataOfCommonCity];
}

- (void)locationToolLocationServicesAuthorizationStatusAuthorized {
    
    if ([SRLocationTool sharedInstance].isAutoLocation) {
        NSString *locationCity = [SRLocationTool sharedInstance].currentLocationCity;
        NSString *cityid = [SRWeatherCityTool cityidOfCityname:locationCity];
        if (cityid) {
            [self loadWeatherDataOfCity:locationCity cityid:cityid];
        } else {
            [self loadWeatherDataOfCommonCity];
        }
    } else {
        [self loadWeatherDataOfCommonCity];
    }
}

- (void)locationToolLocationServicesLocating {
    
    [MBProgressHUD sr_showIndeterminateWithMessage:@"正在定位..."];
}

- (void)locationToolLocationSuccess {
    
    if ([SRLocationTool sharedInstance].isAutoLocation) {
        [_settingCityC reloadCommonCityTableViewIsInsert:YES];
    }
    
    [MBProgressHUD sr_hideHUDForView:nil];
    
    NSString *city = [SRLocationTool sharedInstance].currentLocationCity;
    NSString *cityid = [SRWeatherCityTool cityidOfCityname:city];
    [self loadWeatherDataOfCity:city cityid:cityid];
    [self.weatherToolBar updateWithCityname:city commonCities:self.commonCities];
}

- (void)locationToolLocationFailed {
    
    if (![SRLocationTool sharedInstance].isAutoLocation) {
        [_settingCityC reloadCommonCityTableViewIsInsert:NO];
    }
    
    [MBProgressHUD sr_hideHUDForView:nil];
    [MBProgressHUD sr_showInfoWithMessage:@"定位失败" onView:self.view];
}

#pragma mark - Load Weatehr Data

- (void)loadWeatherDataOfCommonCity {
    
    [self loadWeatherDataOfCity:[SRWeatherCityTool defaultCity] cityid:[SRWeatherCityTool defaultCityid]];
}

- (void)reloadWeatherData {
    
    NSString *city = nil;
    if ([SRLocationTool sharedInstance].isAutoLocation && [SRLocationTool sharedInstance].currentLocationCity) {
        city = [SRLocationTool sharedInstance].currentLocationCity;
        [self.weatherToolBar updateWithCityname:city commonCities:self.commonCities];
    } else {
        city = nil;
        [self.weatherToolBar updateWithCityname:nil commonCities:self.commonCities];
        if (self.commonCities && self.commonCities.count > 0) {
            city = self.commonCities[0];
        } else {
            city = @"北京";
        }
    }
    [self loadWeatherDataOfCity:city cityid:[SRWeatherCityTool cityidOfCityname:city]];
}

- (void)loadWeatherDataWithIndex:(NSInteger)index {
    
    NSString *city = nil;
    if ([SRLocationTool sharedInstance].isAutoLocation && [SRLocationTool sharedInstance].currentLocationCity) {
        if (index == 0) {
            city = [SRLocationTool sharedInstance].currentLocationCity;
        } else {
            city = self.commonCities[index - 1];
        }
    } else {
        city = self.commonCities[index];
    }
    [self loadWeatherDataOfCity:city cityid:[SRWeatherCityTool cityidOfCityname:city]];
}

- (void)loadWeatherDataOfCity:(NSString *)city cityid:(NSString *)cityid {
    
    [SRWeatherDataTool loadWeatherDataCity:city cityid:cityid success:^(NSDictionary *weatherData) {
        [self setWeatherData:weatherData];
        [self updateContent:self.weatherData];
    } failure:^(NSError *error) {
        [self handleFailure:error];
    }];
}

- (void)handleFailure:(NSError *)error {
    
    if (error) {
        self.errorTipsView.hidden = NO;
        self.weatherGeneralInfoView.hidden = YES;
        self.weatherDetailInfoView.hidden = YES;
    } else {
        [MBProgressHUD sr_showErrorWithMessage:@"网络错误更新天气信息失败" onView:self.view];
    }
}

@end
