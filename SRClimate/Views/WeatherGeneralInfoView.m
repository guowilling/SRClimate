//
//  WeatherGeneralInfoView.m
//  SRClimate
//
//  Created by 郭伟林 on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WeatherGeneralInfoView.h"
#import "NSAttributedString+Extension.h"

@implementation WeatherGeneralInfoView

- (instancetype)init {
    
    if (self = [super init]) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent {
    
    UILabel *temperatureLabel = [[UILabel alloc] init];
    [self addSubview:temperatureLabel];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.adjustsFontSizeToFitWidth = YES;
    temperatureLabel.textAlignment = NSTextAlignmentLeft;
    _temperatureLabel = temperatureLabel;
    //_temperatureLabel.backgroundColor = COLOR_RANDOM;
    
    UIImageView *conditionIcon = [[UIImageView alloc] init];
    [self addSubview:conditionIcon];
    conditionIcon.contentMode = UIViewContentModeCenter;
    _conditionIcon = conditionIcon;
    //_conditionIcon.backgroundColor = COLOR_RANDOM;
    
    UILabel *conditionLabel = [[UILabel alloc] init];
    [self addSubview:conditionLabel];
    conditionLabel.textColor = [UIColor whiteColor];
    conditionLabel.textAlignment = NSTextAlignmentLeft;
    conditionLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(19)];
    conditionLabel.adjustsFontSizeToFitWidth = YES;
    _conditionLabel = conditionLabel;
    //_conditionLabel.backgroundColor = COLOR_RANDOM;
    
    UIImageView *PMIcon = [[UIImageView alloc] init];
    PMIcon.image = [UIImage imageNamed:@"new_pm2.5"];
    PMIcon.contentMode = UIViewContentModeCenter;
    [self addSubview:PMIcon];
    _PMIcon = PMIcon;
    //_PMIcon.backgroundColor = COLOR_RANDOM;
    
    UILabel *PMlabel = [[UILabel alloc] init];
    PMlabel.textColor = [UIColor whiteColor];
    PMlabel.textAlignment = NSTextAlignmentLeft;
    PMlabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(19)];
    PMlabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:PMlabel];
    _PMLabel = PMlabel;
    //_PMLabel.backgroundColor = COLOR_RANDOM;
    
    UIImageView *indicatorIcon = [[UIImageView alloc] init];
    indicatorIcon.contentMode = UIViewContentModeCenter;
    indicatorIcon.image = [UIImage imageNamed:@"wea_indicator_up"];
    [self addSubview:indicatorIcon];
    _indicatorIcon = indicatorIcon;
    //_indicatorIcon.backgroundColor = COLOR_RANDOM;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    NSString *temperature       = self.temperatureLabel.attributedText.string;
    CGSize size                 = [temperature sizeWithFont:[UIFont fontWithName:@"GillSans-Light" size:75 / 375.0 * SCREEN_WIDTH]];
    self.temperatureLabel.frame = CGRectMake(10, 20, size.width, kWeatherGeneralItemWH * 2);
    self.conditionIcon.frame    = CGRectMake(CGRectGetMaxX(_temperatureLabel.frame), _temperatureLabel.sr_y,
                                             kWeatherGeneralItemWH, kWeatherGeneralItemWH);
    self.conditionLabel.frame   = CGRectMake(CGRectGetMaxX(_conditionIcon.frame), _conditionIcon.sr_y,
                                             kWeatherGeneralItemWH, kWeatherGeneralItemWH);
    self.PMIcon.frame           = CGRectMake(_conditionIcon.sr_x + 5, CGRectGetMaxY(_conditionIcon.frame) - 10,
                                             kWeatherGeneralItemWH, kWeatherGeneralItemWH);
    self.PMLabel.frame          = CGRectMake(CGRectGetMaxX(_PMIcon.frame) + 5, _PMIcon.sr_y,
                                             [_PMLabel.text sizeWithFont:_PMLabel.font].width, kWeatherGeneralItemWH);
    self.indicatorIcon.frame    = CGRectMake(_temperatureLabel.sr_x, CGRectGetMaxY(_PMIcon.frame), kWeatherGeneralItemWH, 39);
}

- (void)updateWeatherInfoWithNowWeatherInfo:(NSDictionary *)nowWeatherInfo cityWeatherInfo:(NSDictionary *)cityWeatherInfo {
    
    NSString *temperatureText = [NSString stringWithFormat:@"%@℃", nowWeatherInfo[@"tmp"]];
    NSAttributedString *attributedString = [NSAttributedString attributedStringWithString:temperatureText];
    NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [attributedStringM addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"GillSans-Light" size:75 / 375.0 * SCREEN_WIDTH]
                              range:NSMakeRange(0, attributedStringM.length - 1)];
    [attributedStringM addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"GillSans-Light" size:75 / 375.0 * SCREEN_WIDTH]
                              range:NSMakeRange(attributedStringM.length - 1, 1)];
    self.temperatureLabel.attributedText = attributedStringM;
    
    NSString *weatherIconName = nil;
    NSInteger weatherCode = [nowWeatherInfo[@"cond"][@"code"] integerValue];
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
    self.conditionIcon.image = [UIImage imageNamed:weatherIconName];

    self.conditionLabel.attributedText = [NSAttributedString attributedStringWithString:nowWeatherInfo[@"cond"][@"txt"]];
    
    if (cityWeatherInfo[@"aqi"]) {
        self.PMIcon.hidden = NO;
        self.PMLabel.hidden = NO;
        NSString *qlty = cityWeatherInfo[@"qlty"];
        NSInteger aqi = [cityWeatherInfo[@"aqi"] integerValue];
        if (aqi <= 50) {
            qlty = @"优";
        } else if (aqi <= 100) {
            qlty = @"良";
        } else if (aqi <= 150) {
            qlty = @"轻度污染";
        } else if (aqi <= 200) {
            qlty = @"中度污染";
        } else {
            qlty = @"严重污染";
        }
        self.PMLabel.attributedText = [NSAttributedString attributedStringWithString:[NSString stringWithFormat:@"%zd %@", aqi, qlty]];
    } else {
        self.PMIcon.hidden = YES;
        self.PMLabel.hidden = YES;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
