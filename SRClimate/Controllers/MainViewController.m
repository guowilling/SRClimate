//
//  WeatherMainViewController.m
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "MainViewController.h"
#import "CommonCityController.h"
#import "SearchCityController.h"
#import "WeatherLineChart.h"
#import "WeatherToolBar.h"
#import "WeatherGeneralInfoView.h"
#import "WeatherDetailInfoView.h"
#import "SRUserDefaults.h"
#import "SRLocationTool.h"
#import "SRWeatherDataTool.h"

#define kWeatherGeneralH    135.0f
#define kWeatherGeneralW    SCREEN_WIDTH - 2 * SCREEN_ADJUST(15)

@interface MainViewController () <UIScrollViewDelegate, CommonCityControllerDelegate, WeatherToolBarDelegate, SRLocationToolDelegate, SearchCityControllerDelegate>

@property (nonatomic, copy) NSDictionary *weatherData;

@property (nonatomic, weak) UIImageView    *backgroundImageView;
@property (nonatomic, weak) WeatherToolBar *weatherToolBar;

@property (nonatomic, strong) NSMutableArray       *commonCities;
@property (nonatomic, strong) NSArray              *weatherList;
@property (nonatomic, strong) NSMutableDictionary  *cachedWeatherDatas;

@property (nonatomic, strong) WeatherGeneralInfoView *weatherGeneralInfoView;
@property (nonatomic, strong) WeatherDetailInfoView  *weatherDetailInfoView;
@property (nonatomic, assign, getter = isShowDetailWeather) BOOL showDetailWeather;

@property (nonatomic, strong) UISwipeGestureRecognizer *swipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRight;

@property (nonatomic, strong) UIView *errorTipsView;

@property (nonatomic, strong) CommonCityController *commonCityController;

@end

@implementation MainViewController

- (NSArray *)commonCities {
    
    if (!_commonCities) {
        _commonCities = [NSMutableArray arrayWithArray:[SRWeatherDataTool commonCities]];
    }
    return _commonCities;
}

#pragma mark - Lazy load

- (NSMutableDictionary *)cachedWeatherDatas {
    
    if (!_cachedWeatherDatas) {
        _cachedWeatherDatas = [NSMutableDictionary dictionaryWithDictionary:[SRWeatherDataTool cachedWeatherDatas]];
    }
    return _cachedWeatherDatas;
}

- (UISwipeGestureRecognizer *)swipeUP {
    
    if (!_swipeUp) {
        _swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(swipeGeneralInfoViewUP)];
        _swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    }
    return _swipeUp;
}

- (UISwipeGestureRecognizer *)swipeDown {
    
    if (!_swipeDown) {
        _swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(swipeGeneralInfoViewDown)];
        _swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    }
    return _swipeDown;
}

- (UISwipeGestureRecognizer *)swipeLeft {
    
    if (!_swipeLeft) {
        _swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                               action:@selector(swipeGeneralInfoViewLeft)];
        _swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    }
    return _swipeLeft;
}

- (UISwipeGestureRecognizer *)swipeRight {
    
    if (!_swipeRight) {
        _swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(swipeGeneralInfoViewRight)];
        _swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    }
    return _swipeRight;
}

#pragma mark - Life circle

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupBackgroundImageView];

    [self setupErrorTipsView];
    
    [self setupWeatherToolBar];
    
    [self setupWeatherGeneralInfoView];
    
    [self setupWeatherDetailInfoView];
    
    [SRLocationTool sharedInstance].delegate = self;
    
    if ([SRUserDefaults boolForKey:@"hasRequestLocationAuthorization"]) {
        if ([SRLocationTool sharedInstance].isAutoLocation) {
            NSString *cityname = [SRLocationTool sharedInstance].currentLocationCity;
            if (cityname) {
                NSString *cityid = [SRWeatherDataTool cityidOfCityname:cityname];
                [self loadWeatherDataOfCityname:cityname cityid:cityid];
            }
        }
    } else {
        [SRUserDefaults setBool:YES forKey:@"hasRequestLocationAuthorization"];
        [[SRLocationTool sharedInstance] requestAuthorization];
    }
}

- (void)setupBackgroundImageView {
    
    UIImageView *imageView   = [[UIImageView alloc] init];
    imageView.frame          = self.view.bounds;
    [self.view addSubview:imageView];
    _backgroundImageView = imageView;
}

- (void)setupErrorTipsView {
    
    _errorTipsView = [[UIView alloc] init];
    _errorTipsView.frame = CGRectMake(SCREEN_ADJUST(40), (SCREEN_HEIGHT - SCREEN_ADJUST(100)) * 0.5,
                                      SCREEN_WIDTH - 2 * SCREEN_ADJUST(40), SCREEN_ADJUST(100));
    _errorTipsView.layer.cornerRadius = 5;
    _errorTipsView.layer.masksToBounds = YES;
    _errorTipsView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleTipsLable = [[UILabel alloc] init];
    titleTipsLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(18)];
    titleTipsLable.textAlignment = NSTextAlignmentCenter;
    titleTipsLable.adjustsFontSizeToFitWidth = YES;
    titleTipsLable.text = @"没有天气数据";
    [_errorTipsView addSubview:titleTipsLable];
    
    UILabel *introTipsLable = [[UILabel alloc] init];
    introTipsLable.font = [UIFont systemFontOfSize:SCREEN_ADJUST(16)];
    introTipsLable.textColor = [UIColor lightGrayColor];
    introTipsLable.text = @"请检查网络或稍后再试";
    introTipsLable.textAlignment = NSTextAlignmentCenter;
    introTipsLable.adjustsFontSizeToFitWidth = YES;
    [_errorTipsView addSubview:introTipsLable];

    titleTipsLable.frame = CGRectMake(0, 20, _errorTipsView.sr_width, 20);
    introTipsLable.frame = CGRectMake(5, CGRectGetMaxY(titleTipsLable.frame) + 10, _errorTipsView.sr_width - 10, 15);

    [self.view addSubview:_errorTipsView];
    _errorTipsView.hidden = YES;
}

#pragma mark - Setup UI

- (void)setupWeatherToolBar {
    
    WeatherToolBar *weatherToolBar = [[WeatherToolBar alloc] initWithLocationCity:[[SRLocationTool sharedInstance] currentLocationCity]
                                                                     commonCities:self.commonCities];
    weatherToolBar.frame           = CGRectMake(0, SCREEN_HEIGHT - 49 - 20, SCREEN_WIDTH, 49);
    weatherToolBar.delegate        = self;
    [self.view addSubview:weatherToolBar];
    _weatherToolBar = weatherToolBar;
}

- (void)setupWeatherGeneralInfoView {
    
    WeatherGeneralInfoView *weatherGeneralInfoView = [[WeatherGeneralInfoView alloc] init];
    weatherGeneralInfoView.frame = CGRectMake(SCREEN_ADJUST(15), SCREEN_HEIGHT - kWeatherGeneralH - 175, kWeatherGeneralW, kWeatherGeneralH);
    [self.view addSubview:weatherGeneralInfoView];
    _weatherGeneralInfoView = weatherGeneralInfoView;
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
    _weatherGeneralInfoView.hidden = YES;
}

- (void)setupWeatherDetailInfoView {
    
    CGFloat weatherDetailInfoViewY     = 20 + kWeatherGeneralH;
    CGFloat weatherDetailInfoViewH     = SCREEN_HEIGHT - weatherDetailInfoViewY - kButtomContainerH;
    _weatherDetailInfoView             = [[WeatherDetailInfoView alloc] init];
    _weatherDetailInfoView.frame       = CGRectMake(0, weatherDetailInfoViewY, SCREEN_WIDTH, weatherDetailInfoViewH);
    _weatherDetailInfoView.delegate    = self;
    _weatherDetailInfoView.transform   = CGAffineTransformMakeScale(0, 0);
    _weatherDetailInfoView.contentSize = CGSizeMake(0, kHourlyWeatherInfoViewH + kDailyWeatherInfoViewH);
    _weatherDetailInfoView.alwaysBounceVertical = YES;
    _weatherDetailInfoView.showsVerticalScrollIndicator = NO;
    _weatherDetailInfoView.alpha       = 0;
    [self.view addSubview:_weatherDetailInfoView];
}

#pragma mark - Monitor method

- (void)swipeGeneralInfoViewUP {

    self.showDetailWeather = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.frame = CGRectMake(SCREEN_ADJUST(15), 20, kWeatherGeneralW, kWeatherGeneralH);
    } completion:^(BOOL finished) {
        _weatherGeneralInfoView.indicatorIcon.image = [UIImage imageNamed:@"wea_indicator_down"];
        [_weatherGeneralInfoView addGestureRecognizer:self.swipeDown];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeUP];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeLeft];
        [_weatherGeneralInfoView removeGestureRecognizer:self.swipeRight];
    }];
    
    [self updateWeatherDetailInfoView:self.weatherData];
    [UIView animateWithDuration:0.75 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _weatherDetailInfoView.alpha = 1.0;
        _weatherDetailInfoView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (void)swipeGeneralInfoViewDown {
    
    if (!self.isShowDetailWeather) {
        return;
    }

    self.showDetailWeather = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.sr_y = SCREEN_HEIGHT - 175 - kWeatherGeneralH;
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
    
    WeatherGeneralInfoView *weatherGeneralInfoView = [[WeatherGeneralInfoView alloc] init];
    weatherGeneralInfoView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - 175 - kWeatherGeneralH,
                                              kWeatherGeneralW, kWeatherGeneralH);
    [self.view addSubview:weatherGeneralInfoView];
    _weatherGeneralInfoView = weatherGeneralInfoView;
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
    _weatherGeneralInfoView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.sr_x  = SCREEN_ADJUST(15);
        _weatherGeneralInfoView.alpha = 1.0;
    }];
    [self prepareForLoadWeatherDataOfCity:self.weatherToolBar.cityPageControl.currentPage];
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
    
    WeatherGeneralInfoView *weatherGeneralInfoView = [[WeatherGeneralInfoView alloc] init];
    weatherGeneralInfoView.frame = CGRectMake(-kWeatherGeneralW, SCREEN_HEIGHT - 175 - kWeatherGeneralH,
                                              kWeatherGeneralW, kWeatherGeneralH);
    [self.view addSubview:weatherGeneralInfoView];
    _weatherGeneralInfoView = weatherGeneralInfoView;
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeUP];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeLeft];
    [_weatherGeneralInfoView addGestureRecognizer:self.swipeRight];
    _weatherGeneralInfoView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        _weatherGeneralInfoView.sr_x  = SCREEN_ADJUST(15);
        _weatherGeneralInfoView.alpha = 1.0;
    }];
    [self prepareForLoadWeatherDataOfCity:self.weatherToolBar.cityPageControl.currentPage];
}

#pragma mark - Tool method

- (void)updateWeatherGeneralInfoView:(NSDictionary *)weatherData {
    
    _errorTipsView.hidden          = YES;
    _weatherGeneralInfoView.hidden = NO;
    _weatherDetailInfoView.hidden  = NO;
    NSDictionary *nowWeatherInfo = weatherData[@"HeWeather data service 3.0"][0][@"now"];
    NSDictionary *cityWeatherInfo = weatherData[@"HeWeather data service 3.0"][0][@"aqi"][@"city"];
    if (!nowWeatherInfo && !cityWeatherInfo) {
        _errorTipsView.hidden          = NO;
        _weatherGeneralInfoView.hidden = YES;
        _weatherDetailInfoView.hidden  = YES;
        return;
    }
    
    [self.weatherGeneralInfoView updateWeatherInfoWithNowWeatherInfo:nowWeatherInfo cityWeatherInfo:cityWeatherInfo];
    
    [self updateBackgroundImageView:[nowWeatherInfo[@"cond"][@"code"] integerValue]];
}

- (void)updateBackgroundImageView:(NSInteger)weatherCode {
    
    switch (weatherCode) {
        case 100:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"background_sunny.jpeg"];
        }
            break;
        case 101:
        case 102:
        case 103:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"background_cloudy.jpeg"];
        }
            break;
        case 104:
        case 300:
        case 301:
        case 302:
        case 303:
        case 304:
        case 305:
        case 306:
        case 307:
        case 308:
        case 309:
        case 310:
        case 311:
        case 312:
        case 313:
        case 400:
        case 401:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"background_rainy.jpeg"];
        }
            break;
        case 402:
        case 403:
        case 404:
        case 405:
        case 406:
        case 407:
        {
            _backgroundImageView.image = [UIImage imageNamed:@"background_snowy.jpeg"];
        }
            break;
        default:
            _backgroundImageView.image = [UIImage imageNamed:@"background_cloudy.jpeg"];
            break;
    }
}

- (void)updateWeatherDetailInfoView:(NSDictionary *)weatherData {
    
    if (!_weatherDetailInfoView) {
        return;
    }
    [_weatherDetailInfoView setWeatherData:weatherData];
}

- (void)updateContent:(NSDictionary *)weatherData {
    
    [self updateWeatherGeneralInfoView:weatherData];
    
    [self updateWeatherDetailInfoView:weatherData];
}

- (void)reloadWeatherData {
    
    NSString *locationCity = [SRLocationTool sharedInstance].currentLocationCity;
    [self.weatherToolBar updateWithCityname:locationCity commonCities:self.commonCities];
    
    NSString *cityname = locationCity;
    if (!cityname) {
        if (self.commonCities && self.commonCities.count > 0) {
            cityname = self.commonCities[0];
        } else {
            cityname = @"北京";
        }
    }
    
    [self loadWeatherDataOfCityname:cityname cityid:[SRWeatherDataTool cityidOfCityname:cityname]];
}

- (void)prepareForLoadWeatherDataOfCity:(NSInteger)index {
    
    NSString *cityname;
    if ([[SRLocationTool sharedInstance] currentLocationCity]) {
        if (index == 0) {
            cityname = [[SRLocationTool sharedInstance] currentLocationCity];
        } else {
            cityname = self.commonCities[index - 1];
        }
    } else {
        cityname = self.commonCities[index];
    }
    
    [self loadWeatherDataOfCityname:cityname cityid:[SRWeatherDataTool cityidOfCityname:cityname]];
}

#pragma mark - CommonCityControllerDelegate

- (void)commonCityControllerDidOpenAutoLocation {
    
    [[SRLocationTool sharedInstance] beginLocation];
}

- (void)commonCityControllerDidCloseAutoLocation {
    
    if (_commonCityController) {
        [self.commonCityController deleteTableViewRow];
    }
    
    [self reloadWeatherData];
}

- (void)commonCityControllerDidDeleteCity {
    
    [self reloadWeatherData];
}

- (void)commonCityControllerDidReorderCity {
    
    [self reloadWeatherData];
}

- (void)commonCityControllerDidSelectCity:(NSString *)cityname isLocationCity:(BOOL)isLocationCity {
    
    if (self.isShowDetailWeather) {
        [self swipeGeneralInfoViewDown];
    }
    
    if (isLocationCity) {
        if (self.weatherToolBar.cityPageControl.currentPage == 0) {
            return;
        }
        self.weatherToolBar.cityPageControl.currentPage = 0;
        [self.weatherToolBar.cityScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self loadWeatherDataOfCityname:cityname cityid:[SRWeatherDataTool cityidOfCityname:cityname]];
    } else {
        NSInteger currentIndex = [self.commonCities indexOfObject:cityname];
        if ([SRLocationTool sharedInstance].currentLocationCity) {
            currentIndex += 1;
        }
        if (self.weatherToolBar.cityPageControl.currentPage == currentIndex) {
            return;
        }
        [self.weatherToolBar.cityPageControl setCurrentPage:currentIndex];
        [self.weatherToolBar.cityScrollView setContentOffset:CGPointMake(self.weatherToolBar.cityScrollView.sr_width * currentIndex, 0) animated:NO];
        [self loadWeatherDataOfCityname:cityname cityid:[SRWeatherDataTool cityidOfCityname:cityname]];
    }
}

#pragma mark - SearchCityControllerDelegate

- (void)searchCityControllerDidAddCity:(NSString *)city {
    
    if (![self.commonCities containsObject:city]) {
        if (self.commonCities.count == 12) {
            [MBProgressHUD sr_showInfoWithMessage:@"最多只能添加12个常用城市" onView:self.view];
        } else {
            [self.commonCities addObject:city];
            [SRWeatherDataTool saveCommonCities:[self.commonCities copy]];
            [self reloadWeatherData];
        }
    } else {
        [MBProgressHUD sr_showInfoWithMessage:@"该城市已添加" onView:self.view];
    }
}

#pragma mark - WeatherToolBarDelegate

- (void)weatherToolBarDidClickCommonCityBtnAction {
    
    CommonCityController *commonCityC = [[CommonCityController alloc] init];
    commonCityC.delegate = self;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:commonCityC];
    [self presentViewController:navC animated:YES completion:nil];
    _commonCityController = commonCityC;
}

- (void)weatherToolBarDidClickSearchCityBtnAction {
    
    
    SearchCityController *searchCityC = [[SearchCityController alloc] init];
    searchCityC.delegate = self;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:searchCityC];
    [self presentViewController:navC animated:YES completion:nil];
}

- (void)weatherToolBarDidScrollToIndex:(NSInteger)index {
    
    [self prepareForLoadWeatherDataOfCity:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.isShowDetailWeather) {
        return;
    }
    
    if (scrollView == self.weatherDetailInfoView) {
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
}

#pragma mark - LocationToolDelegate

- (void)locationToolLocationServicesDisabled {
    
    [self loadWeatherDataOfCommonCity];
    
    [MBProgressHUD sr_showInfoWithMessage:@"请打开系统定位服务" onView:self.view];
    
    if (self.commonCityController) {
        [self.commonCityController reloadTableView];
    }
}

- (void)locationToolLocationServicesAuthorizationStatusDidChange { }

- (void)locationToolLocationServicesAuthorizationStatusDenied {
    
    [self loadWeatherDataOfCommonCity];
    
    if (self.commonCityController) {
        [self.commonCityController reloadTableView];
    }
}

- (void)locationToolLocationServicesAuthorizationStatusAuthorized {
    
    if ([SRLocationTool sharedInstance].isAutoLocation) {
        NSString *locationCity = [SRLocationTool sharedInstance].currentLocationCity;
        if (locationCity) {
            [self loadWeatherDataOfCityname:locationCity cityid:[SRWeatherDataTool cityidOfCityname:locationCity]];
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
    
    [MBProgressHUD sr_hideHUDForView:nil];
    NSString *cityname = [SRLocationTool sharedInstance].currentLocationCity;
    NSString *cityid   = [SRWeatherDataTool cityidOfCityname:cityname];
    
    [self loadWeatherDataOfCityname:cityname cityid:cityid];
    [self.weatherToolBar updateWithCityname:cityname commonCities:self.commonCities];
    [MBProgressHUD sr_hideHUDForView:self.view];
    
    if (self.commonCityController) {
        [self.commonCityController insertTableViewRow];
    }
}

- (void)locationToolLocationFailed {
    
    [MBProgressHUD sr_hideHUDForView:nil];
    [MBProgressHUD sr_showInfoWithMessage:@"定位失败已显示默认城市天气信息" onView:self.view];
    
    if (self.commonCityController) {
        [self.commonCityController reloadTableView];
    }
}

#pragma mark - Load Weatehr Data

- (void)loadWeatherDataOfCommonCity {
    
    [SRWeatherDataTool loadWeatherDataCityname:[SRWeatherDataTool defaultCityname]
                                        cityid:[SRWeatherDataTool defaultCityid]
                                       success:^(NSDictionary *weatherData) {
                                           [self setWeatherData:weatherData];
                                           [self updateContent:self.weatherData];
                                       }
                                       failure:^(NSError *error) {
                                           if (error) {
                                               _errorTipsView.hidden          = NO;
                                               _weatherGeneralInfoView.hidden = YES;
                                               _weatherDetailInfoView.hidden  = YES;
                                           } else {
                                               [MBProgressHUD sr_showErrorWithMessage:@"网络错误更新天气信息失败"
                                                                               onView:self.view];
                                           }
                                       }];
}

- (void)loadWeatherDataOfCityname:(NSString *)cityname cityid:(NSString *)cityid {
    
    [SRWeatherDataTool loadWeatherDataCityname:cityid
                                        cityid:cityid
                                       success:^(NSDictionary *weatherData) {
                                           [self setWeatherData:weatherData];
                                           [self updateContent:self.weatherData];
                                       }
                                       failure:^(NSError *error) {
                                           if (error) {
                                               _errorTipsView.hidden          = NO;
                                               _weatherGeneralInfoView.hidden = YES;
                                               _weatherDetailInfoView.hidden  = YES;
                                           } else {
                                               [MBProgressHUD sr_showErrorWithMessage:@"网络错误更新天气信息失败"
                                                                               onView:self.view];
                                           }
                                       }];
}

@end
