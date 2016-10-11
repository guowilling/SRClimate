//
//  BannerWeatherView.m
//  SRClimate
//
//  Created by 郭伟林 on 16/7/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WeatherViewBanner.h"
#import "NSAttributedString+Extension.h"

@interface WeatherViewBanner ()

@property (nonatomic, weak) UILabel     *cityLabel;
@property (nonatomic, weak) UILabel     *tmpLabel;
@property (nonatomic, weak) UIImageView *weaIcon;
@property (nonatomic, weak) UIImageView *animationImageView;

@property (nonatomic, strong) CALayer   *backgroundLayer;

@end

@implementation WeatherViewBanner

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
                
        UILabel *loadingWeatherLabel      = [[UILabel alloc] init];
        loadingWeatherLabel.frame         = CGRectMake(10, 0, frame.size.width - 20, frame.size.height);
        loadingWeatherLabel.textAlignment = NSTextAlignmentCenter;
        loadingWeatherLabel.textColor     = COLOR_RGBA(139, 149, 168, 1.0);
        loadingWeatherLabel.font          = [UIFont systemFontOfSize:SCREEN_ADJUST(19)];
        loadingWeatherLabel.text          = @"正在获取天气信息...";
        [self addSubview:loadingWeatherLabel];
        _loadingWeatherLabel = loadingWeatherLabel;
        
        UILabel *cityLabel      = [[UILabel alloc] init];
        cityLabel.text          = @"北京"; // fake
        cityLabel.font          = [UIFont systemFontOfSize:SCREEN_ADJUST(22)];
        cityLabel.frame         = CGRectMake(0, self.sr_height * 0.4, self.sr_width, [cityLabel.text sizeWithFont:cityLabel.font].height);
        cityLabel.textAlignment = NSTextAlignmentCenter;
        cityLabel.textColor     = [UIColor whiteColor];
        cityLabel.hidden        = YES;
        [self addSubview:cityLabel];
        _cityLabel              = cityLabel;
        //_cityLabel.backgroundColor = COLOR_RANDOM;
        
        UILabel *tmpLabel      = [[UILabel alloc] init];
        tmpLabel.text          = @"25℃ 晴"; // fake
        tmpLabel.font          = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
        tmpLabel.frame         = CGRectMake(0, CGRectGetMaxY(cityLabel.frame) + 5, self.sr_width, [tmpLabel.text sizeWithFont:tmpLabel.font].height);
        tmpLabel.textAlignment = NSTextAlignmentCenter;
        tmpLabel.textColor     = [UIColor whiteColor];
        tmpLabel.hidden        = YES;
        [self addSubview:tmpLabel];
        _tmpLabel              = tmpLabel;
        //_tmpLabel.backgroundColor = COLOR_RANDOM;
        
        UIImageView *weaIcon = [[UIImageView alloc] init];
        weaIcon.frame        = CGRectMake(self.sr_width * 0.5 - tmpLabel.sr_height - [tmpLabel.text sizeWithFont:tmpLabel.font].width * 0.5,
                                          tmpLabel.sr_top, tmpLabel.sr_height, tmpLabel.sr_height);
        weaIcon.contentMode  = UIViewContentModeCenter;
        weaIcon.hidden       = YES;
        [self addSubview:weaIcon];
        _weaIcon             = weaIcon;
        //_weaIcon.backgroundColor = COLOR_RANDOM;
    }
    return self;
}

- (void)updateWithCityname:(NSString *)cityname nowWeatherInfo:(NSDictionary *)nowWeatherInfo {
    
    self.loadingWeatherLabel.hidden = YES;
    self.cityLabel.hidden           = NO;
    self.tmpLabel.hidden            = NO;
    self.weaIcon.hidden             = NO;
    
    self.cityLabel.attributedText = [NSAttributedString attributedStringWithString:cityname];
    
    if (nowWeatherInfo) {
        NSString *tmpText = [NSString stringWithFormat:@"%@℃ %@", nowWeatherInfo[@"tmp"], nowWeatherInfo[@"cond"][@"txt"]];
        self.tmpLabel.attributedText = [NSAttributedString attributedStringWithString:tmpText];
    } else {
        self.tmpLabel.attributedText = [NSAttributedString attributedStringWithString:@"火星气候"];
    }
    self.weaIcon.sr_x = self.sr_width * 0.5 - self.tmpLabel.sr_height - [self.tmpLabel.text sizeWithFont:self.tmpLabel.font].width * 0.55;
    
    NSInteger weatherCode = [nowWeatherInfo[@"cond"][@"code"] integerValue];
    [self updateWeatherIcon:weatherCode];
}

- (void)updateWeatherIcon:(NSInteger)weatherCode {
    
    NSString *weatherIconName = nil;
    switch (weatherCode) {
        case 100:
        case 102:
            weatherIconName = @"new_weather_sunny";
            break;
        case 101:
        case 103:
            weatherIconName = @"new_weather_cloudy";
            break;
        case 104:
            weatherIconName = @"new_weather_overcast";
            break;
        case 300:
        case 301:
        case 307:
        case 308:
        case 310:
        case 311:
        case 312:
        case 313:
            weatherIconName = @"new_weather_heavyrain";
            break;
        case 302:
        case 303:
            weatherIconName = @"new_weather_thundershower";
            break;
        case 305:
        case 309:
            weatherIconName = @"new_weather_lightrain";
            break;
        case 306:
            weatherIconName = @"new_weather_mediumrain";
            break;
        case 400:
        case 401:
            weatherIconName = @"new_weather_lightsnow";
            break;
        case 403:
            weatherIconName = @"new_weather_heavysnow";
            break;
        case 304:
        case 404:
            weatherIconName = @"new_weather_hailstone";
            break;
        case 405:
        case 406:
        case 407:
            weatherIconName = @"new_weather_rainandsnow";
            break;
        case 500:
        case 501:
            weatherIconName = @"new_weahter_fog";
            break;
        default:
            weatherIconName = @"new_weather_NA";
            break;
    }
    self.weaIcon.image = [UIImage imageNamed:weatherIconName];
}

@end
