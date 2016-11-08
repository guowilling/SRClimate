//
//  WeatherGeneralInfoView.m
//  SRClimate
//
//  Created by 郭伟林 on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WeatherGeneralInfoView.h"
#import "NSAttributedString+Extension.h"
#import "NowWeatherData.h"
#import "CityWeatherData.h"
#import "SRWeatherAssist.h"

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
    self.temperatureLabel.frame = CGRectMake(SCREEN_ADJUST(10), SCREEN_ADJUST(20), size.width, kWeatherGeneralItemWH * 2);
    
    self.conditionIcon.frame    = CGRectMake(CGRectGetMaxX(_temperatureLabel.frame), _temperatureLabel.sr_y,
                                             kWeatherGeneralItemWH, kWeatherGeneralItemWH);
    
    self.conditionLabel.frame   = CGRectMake(CGRectGetMaxX(_conditionIcon.frame), _conditionIcon.sr_y,
                                             kWeatherGeneralItemWH, kWeatherGeneralItemWH);
    
    self.PMIcon.frame           = CGRectMake(_conditionIcon.sr_x + SCREEN_ADJUST(5), CGRectGetMaxY(_conditionIcon.frame) - SCREEN_ADJUST(10),
                                             kWeatherGeneralItemWH, kWeatherGeneralItemWH);
    
    self.PMLabel.frame          = CGRectMake(CGRectGetMaxX(_PMIcon.frame) + SCREEN_ADJUST(5), _PMIcon.sr_y,
                                             [_PMLabel.text sizeWithFont:_PMLabel.font].width, kWeatherGeneralItemWH);
    
    self.indicatorIcon.frame    = CGRectMake(_temperatureLabel.sr_x, CGRectGetMaxY(_PMIcon.frame), kWeatherGeneralItemWH, SCREEN_ADJUST(40));
}

- (void)updateWeatherInfoWithNowWeatherInfo:(NowWeatherData *)nowWeatherInfo cityWeatherInfo:(CityWeatherData *)cityWeatherInfo {
    
    NSString *temperatureText = [NSString stringWithFormat:@"%@℃", nowWeatherInfo.tmp];
    NSAttributedString *attributedString = [NSAttributedString attributedStringWithString:temperatureText];
    NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
    [attributedStringM addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"GillSans-Light" size:75 / 375.0 * SCREEN_WIDTH]
                              range:NSMakeRange(0, attributedStringM.length - 1)];
    [attributedStringM addAttribute:NSFontAttributeName
                              value:[UIFont fontWithName:@"GillSans-Light" size:75 / 375.0 * SCREEN_WIDTH]
                              range:NSMakeRange(attributedStringM.length - 1, 1)];
    self.temperatureLabel.attributedText = attributedStringM;
    
    NSInteger weatherCode = [nowWeatherInfo.code integerValue];
    self.conditionIcon.image = [UIImage imageNamed:[SRWeatherAssist getWeatherIconNameWithWeatherCode:weatherCode]];

    self.conditionLabel.attributedText = [NSAttributedString attributedStringWithString:nowWeatherInfo.txt];
    
    if (cityWeatherInfo.pm25) {
        self.PMIcon.hidden = NO;
        self.PMLabel.hidden = NO;
        NSString *qlty = cityWeatherInfo.qlty;
        NSInteger pm25 = [cityWeatherInfo.pm25 integerValue];
        self.PMLabel.attributedText = [NSAttributedString attributedStringWithString:[NSString stringWithFormat:@"%zd %@", pm25, qlty]];
    } else {
        self.PMIcon.hidden = YES;
        self.PMLabel.hidden = YES;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
