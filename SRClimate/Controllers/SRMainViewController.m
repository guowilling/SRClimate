//
//  SRMainViewController.m
//  SRClimate
//
//  Created by 郭伟林 on 16/9/18.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRMainViewController.h"
#import "WeatherMainController.h"
#import "WeatherViewBanner.h"
#import "SRLocationTool.h"
#import "SRWeatherDataTool.h"

@interface SRMainViewController () <SRLocationToolDelegate, WeatherMainControllerDelegate>

@property (nonatomic, weak  ) UIImageView           *backgroundImageView;

@property (nonatomic, copy  ) NSDictionary          *weatherData;
@property (nonatomic, weak  ) WeatherViewBanner     *bannerWeatherView;
@property (nonatomic, strong) WeatherMainController *weatherMainController;

@end

@implementation SRMainViewController

#pragma mark - Life circle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBackgroundImageView];
    
    [self addBannerWeatherView];

    [SRLocationTool sharedInstance].delegate = self;
    [[SRLocationTool sharedInstance] beginLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)addBackgroundImageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    _backgroundImageView = imageView;
}

- (void)addBannerWeatherView {
    
    WeatherViewBanner *bannerWeatherView = [[WeatherViewBanner alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [bannerWeatherView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(weatherViewTap)]];
    [self.view addSubview:bannerWeatherView];
    _bannerWeatherView = bannerWeatherView;
    _bannerWeatherView.userInteractionEnabled = NO;
}

- (void)weatherViewTap {
    
    _weatherMainController = [[WeatherMainController alloc] init];
    _weatherMainController.delegate = self;
    _weatherMainController.weatherData = self.weatherData;
    [self.navigationController pushViewController:_weatherMainController animated:NO];
    [UIView animateWithDuration:0.75 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
    }];
}

#pragma mark - Load Weatehr Data

- (void)loadWeatherDataOfCommonCity {
    
    [SRWeatherDataTool loadWeatherDataCityname:[SRWeatherDataTool defaultCityname]
                                      cityid:[SRWeatherDataTool defaultCityid]
                                     success:^(NSDictionary *weatherData) {
                                         [self updateBannerWeatherViewWithCityname:[SRWeatherDataTool defaultCityname]
                                                                       weatherData:weatherData];
                                     }
                                     failure:^(NSError *error) {
                                         if (error) {
                                             self.bannerWeatherView.loadingWeatherLabel.text = @"获取天气信息失败";
                                             self.bannerWeatherView.userInteractionEnabled = YES;
                                         } else {
                                             [MBProgressHUD sr_showErrorWithMessage:@"更新天气信息失败" onView: self.view];
                                             self.bannerWeatherView.userInteractionEnabled = YES;
                                         }
                                     }];
}

- (void)loadWeatherDataOfCityname:(NSString *)cityname cityid:(NSString *)cityid {
    
    [SRWeatherDataTool loadWeatherDataCityname:cityname
                                      cityid:cityid
                                     success:^(NSDictionary *weatherData) {
                                         [self updateBannerWeatherViewWithCityname:cityname weatherData:weatherData];
                                     }
                                     failure:^(NSError *error) {
                                         if (error) {
                                             self.bannerWeatherView.loadingWeatherLabel.text = @"获取天气信息失败";
                                             self.bannerWeatherView.userInteractionEnabled = YES;
                                         } else {
                                             [MBProgressHUD sr_showErrorWithMessage:@"更新天气信息失败" onView: self.view];
                                             self.bannerWeatherView.userInteractionEnabled = YES;
                                         }
                                     }];
}

#pragma mark - LocationToolDelegate

- (void)locationToolLocationServicesLocating {
    
    if (_weatherMainController) {
        [_weatherMainController showLocatingTips];
    }
}

- (void)locationToolLocationServicesDisabled {
    
    [self loadWeatherDataOfCommonCity];
    
    [MBProgressHUD sr_showInfoWithMessage:@"请打开系统定位服务" onView:self.view];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SRLocationServicesDisabled object:nil];
}

- (void)locationToolLocationServicesAuthorizationStatusDenied {
    
    [self loadWeatherDataOfCommonCity];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SRLocationServicesAuthorizationStatusDenied object:nil];
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

- (void)locationToolLocationSuccess {
    
    NSString *cityname = [SRLocationTool sharedInstance].currentLocationCity;
    NSString *cityid   = [SRWeatherDataTool cityidOfCityname:cityname];
    
    [self loadWeatherDataOfCityname:cityname cityid:cityid];
    
    if (_weatherMainController) {
        [_weatherMainController loadWeatherDataOfCityname:cityname cityid:cityid];
        [_weatherMainController updateToolBarWithCityname:cityname];
        [_weatherMainController hideLocatingTips];
    }
}

- (void)locationToolLocationFailed {
    
    [MBProgressHUD sr_showErrorWithMessage:@"定位失败" onView:self.view];
    if (_weatherMainController) {
        [_weatherMainController showLocationFailedTips];
    }
}

#pragma mark - WeatherMainControllerDelegate

- (void)weatherMainControllerDidCloseAutoLocation {
    
    [self loadWeatherDataOfCommonCity];
}

- (void)weatherMainControllerDidDismiss {
    
    _weatherMainController = nil;
    [self.navigationController popViewControllerAnimated:NO];
    [UIView animateWithDuration:0.75 animations:^{
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    }];
}

#pragma mark - Tool method

- (void)updateBannerWeatherViewWithCityname:(NSString *)cityname weatherData:(NSDictionary *)weatherData {
    
    self.weatherData = weatherData;
    self.bannerWeatherView.userInteractionEnabled = YES;
    NSDictionary *nowWeatherInfo = weatherData[@"HeWeather data service 3.0"][0][@"now"];
    [self.bannerWeatherView updateWithCityname:cityname nowWeatherInfo:nowWeatherInfo];
    
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

@end
