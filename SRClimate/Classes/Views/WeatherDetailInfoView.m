//
//  WeatherDetailView.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WeatherDetailInfoView.h"
#import "WeatherLineChart.h"
#import "NSAttributedString+Extension.h"
#import "NowWeatherData.h"
#import "HourlyWeatherData.h"
#import "DailyWeatherData.h"
#import "MJExtension.h"
#import "NSDate+Extension.h"
#import "SRWeatherAssist.h"

#define kMargin SCREEN_ADJUST(20)

@interface WeatherDetailInfoView ()

@property (nonatomic, weak  ) UIView       *hourlyWeatherDetailContainer;
@property (nonatomic, weak  ) UILabel      *hourlyLabel;
@property (nonatomic, weak  ) UIView       *hourlyLine;
@property (nonatomic, weak  ) UIScrollView *hourlyScrollView;

@property (nonatomic, strong) NSArray *hourlyItemContainers;
@property (nonatomic, strong) NSArray *hourlyTimeLabels;
@property (nonatomic, strong) NSArray *hourlyConditionIcons;
@property (nonatomic, strong) NSArray *hourlyTemperatureLabels;

@property (nonatomic, weak  ) UIView       *dailyWeatherDetailContainer;
@property (nonatomic, weak  ) UILabel      *dailyLabel;
@property (nonatomic, weak  ) UIView       *dailyLine;
@property (nonatomic, weak  ) UIScrollView *dailyScrollView;

@property (nonatomic, strong) NSArray *dailyItemContainers;
@property (nonatomic, strong) NSArray *dailyDateLabels;
@property (nonatomic, strong) NSArray *dailyConditionIcons;
@property (nonatomic, strong) NSArray *dailyConditionLabels;

@property (nonatomic, strong) NSArray          *drawXPoints;
@property (nonatomic, weak  ) WeatherLineChart *chartMax;
@property (nonatomic, weak  ) WeatherLineChart *chartMin;

@property (nonatomic, strong) NSArray *hourlyForecastDics;
@property (nonatomic, strong) NSArray *dailyForecastDics;
@property (nonatomic, strong) NSArray *maxTemperatures;
@property (nonatomic, strong) NSArray *minTemperatures;

@end

@implementation WeatherDetailInfoView

- (NSArray *)drawXPoints {
    if (!_drawXPoints) {
        NSMutableArray *points = [NSMutableArray array];
        CGFloat width = (SCREEN_WIDTH - kMargin * 2) / 5;
        for (NSInteger i = 0; i < self.dailyItemContainers.count; i++) {
            CGFloat point = width * 0.5 + width * i;
            [points addObject:@(point)];
        }
        _drawXPoints = points;
    }
    return _drawXPoints;
}

- (NSArray *)hourlyForecastDics {
    return [HourlyWeatherData mj_objectArrayWithKeyValuesArray:_weatherData[@"HeWeather data service 3.0"][0][@"hourly_forecast"]];
}

- (NSArray *)dailyForecastDics {
    return [DailyWeatherData mj_objectArrayWithKeyValuesArray:_weatherData[@"HeWeather data service 3.0"][0][@"daily_forecast"]];
}

- (NSArray *)maxTemperatures {
    NSMutableArray *tempArrayM = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dailyForecastDics.count; i++) {
        NSString *tmp = [NSString stringWithFormat:@"%@˚",[self.dailyForecastDics[i] tmpMax]];
        [tempArrayM addObject:tmp];
    }
    _maxTemperatures = tempArrayM;
    return _maxTemperatures;
}

- (NSArray *)minTemperatures {
    NSMutableArray *tempArrayM = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dailyForecastDics.count; i++) {
        NSString *tmp = [NSString stringWithFormat:@"%@˚",[self.dailyForecastDics[i] tmpMin]];
        [tempArrayM addObject:tmp];
    }
    _minTemperatures = tempArrayM;
    return _minTemperatures;
}

- (void)setWeatherData:(NSDictionary *)weatherData {
    if (_weatherData == nil) {
        _weatherData = weatherData;
        [self setupHourlyWeatherInfoView];
        [self setupDailyWeatherInfoView];
    } else {
        NSArray *newHourlyForecastDics = weatherData[@"HeWeather data service 3.0"][0][@"hourly_forecast"];
        if (self.hourlyForecastDics.count != newHourlyForecastDics.count) {
            _weatherData = weatherData;
            [self.hourlyWeatherDetailContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self setupHourlyWeatherInfoView];
        } else {
            _weatherData = weatherData;
        }
    }
    
    [self updateWeatherInfo];
}

- (void)setupHourlyWeatherInfoView {
    if (!_hourlyWeatherDetailContainer) {
        UIView *hourlyWeatherDetailContainer = [[UIView alloc] init];
        [self addSubview:hourlyWeatherDetailContainer];
        self.hourlyWeatherDetailContainer = hourlyWeatherDetailContainer;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [NSAttributedString attributedStringWithString:@"分时天气"];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(19)];
    label.textAlignment = NSTextAlignmentLeft;
    [self.hourlyWeatherDetailContainer addSubview:label];
    _hourlyLabel = label;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.hourlyWeatherDetailContainer addSubview:line];
    _hourlyLine = line;
    
    UIScrollView *hourlyScrollView = [[UIScrollView alloc] init];
    hourlyScrollView.showsHorizontalScrollIndicator = NO;
    hourlyScrollView.alwaysBounceHorizontal = YES;
    [self.hourlyWeatherDetailContainer addSubview:hourlyScrollView];
    _hourlyScrollView = hourlyScrollView;
    
    NSMutableArray *tempItemContainers = [NSMutableArray array];
    NSMutableArray *tempTimeLabels = [NSMutableArray array];
    NSMutableArray *tempConditionIcons = [NSMutableArray array];
    NSMutableArray *tempTemperatureLabels = [NSMutableArray array];
    
    UIView *itemContainer = [[UIView alloc] init];
    [hourlyScrollView addSubview:itemContainer];
    [tempItemContainers addObject:itemContainer];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(17)];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.attributedText = [NSAttributedString attributedStringWithString:@"现在"];
    [itemContainer addSubview:timeLabel];
    [tempTimeLabels addObject:timeLabel];
    
    UIImageView *conditionIcon = [[UIImageView alloc] init];
    conditionIcon.contentMode = UIViewContentModeCenter;
    [itemContainer addSubview:conditionIcon];
    [tempConditionIcons addObject:conditionIcon];
    
    UILabel *temperatureLabel = [[UILabel alloc] init];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(17)];
    temperatureLabel.textAlignment = NSTextAlignmentCenter;
    [itemContainer addSubview:temperatureLabel];
    [tempTemperatureLabels addObject:temperatureLabel];
    
    for (NSInteger i = 0; i < self.hourlyForecastDics.count; i++) {
        UIView *itemContainer = [[UIView alloc] init];
        [hourlyScrollView addSubview:itemContainer];
        [tempItemContainers addObject:itemContainer];
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:17];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        HourlyWeatherData *hourlyData = self.hourlyForecastDics[i];
        NSString *date = hourlyData.date;
        NSArray *parts = [date componentsSeparatedByString:@" "];
        timeLabel.attributedText = [NSAttributedString attributedStringWithString:parts[1]];
        [itemContainer addSubview:timeLabel];
        [tempTimeLabels addObject:timeLabel];
        
        UIImageView *conditionIcon = [[UIImageView alloc] init];
        conditionIcon.contentMode = UIViewContentModeCenter;
        [itemContainer addSubview:conditionIcon];
        [tempConditionIcons addObject:conditionIcon];
        
        UILabel *temperatureLabel = [[UILabel alloc] init];
        temperatureLabel.textColor = [UIColor whiteColor];
        temperatureLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(17)];
        temperatureLabel.textAlignment = NSTextAlignmentCenter;
        [itemContainer addSubview:temperatureLabel];
        [tempTemperatureLabels addObject:temperatureLabel];
    }
    self.hourlyItemContainers = [tempItemContainers copy];
    self.hourlyTimeLabels = [tempTimeLabels copy];
    self.hourlyConditionIcons  = [tempConditionIcons copy];
    self.hourlyTemperatureLabels = [tempTemperatureLabels copy];;
}

- (void)setupDailyWeatherInfoView {
    UIView *dailyWeatherDetailContainer = [[UIView alloc] init];
    [self addSubview:dailyWeatherDetailContainer];
    _dailyWeatherDetailContainer = dailyWeatherDetailContainer;
    
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [NSAttributedString attributedStringWithString:@"一周天气"];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(19)];
    label.textAlignment = NSTextAlignmentLeft;
    [dailyWeatherDetailContainer addSubview:label];
    _dailyLabel = label;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [dailyWeatherDetailContainer addSubview:line];
    self.dailyLine = line;
    
    UIScrollView *dailyScrollView = [[UIScrollView alloc] init];
    dailyScrollView.tag = 55;
    dailyScrollView.showsHorizontalScrollIndicator = NO;
    dailyScrollView.alwaysBounceHorizontal = YES;
    [dailyWeatherDetailContainer addSubview:dailyScrollView];
    _dailyScrollView = dailyScrollView;
    
    NSMutableArray *tempItemContainers = [NSMutableArray array];
    NSMutableArray *tempDateLabels = [NSMutableArray array];
    NSMutableArray *tempConditionIcons = [NSMutableArray array];
    NSMutableArray *tempConditionLabels = [NSMutableArray array];
    for (NSInteger i = 0; i < self.dailyForecastDics.count; i++) {
        UIView *itemContainer = [[UIView alloc] init];
        [dailyScrollView addSubview:itemContainer];
        [tempItemContainers addObject:itemContainer];
        
        UILabel *dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(17)];
        dateLabel.numberOfLines = 0;

        DailyWeatherData *dailyData = self.dailyForecastDics[i];
        NSString *dateString = dailyData.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        date = [date dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];
        NSString *weekday = [NSDate weekdayFromDate:date];
        NSString *text;
        if (i == 0) {
            text = @"今天";
        } else if (i == 1) {
            text = @"明天";
        } else {
            text = weekday;
        }
        dateLabel.attributedText = [NSAttributedString attributedStringWithString:text];
        [itemContainer addSubview:dateLabel];
        [tempDateLabels addObject:dateLabel];
        
        UIImageView *conditionIcon = [[UIImageView alloc] init];
        conditionIcon.contentMode = UIViewContentModeCenter;
        [itemContainer addSubview:conditionIcon];
        [tempConditionIcons addObject:conditionIcon];
        
        UILabel *conditionLabel = [[UILabel alloc] init];
        conditionLabel.textAlignment = NSTextAlignmentCenter;
        conditionLabel.adjustsFontSizeToFitWidth = YES;
        conditionLabel.numberOfLines = 0;
        conditionLabel.textColor = [UIColor whiteColor];
        conditionLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:SCREEN_ADJUST(17)];
        [itemContainer addSubview:conditionLabel];
        [tempConditionLabels addObject:conditionLabel];
    }
    self.dailyItemContainers  = [tempItemContainers  copy];
    self.dailyDateLabels      = [tempDateLabels      copy];
    self.dailyConditionIcons  = [tempConditionIcons  copy];
    self.dailyConditionLabels = [tempConditionLabels copy];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _hourlyWeatherDetailContainer.frame = CGRectMake(kMargin, 0, SCREEN_WIDTH - kMargin*2, kHourlyWeatherInfoViewH);
    
    _hourlyLabel.frame = CGRectMake(0, 0, self.hourlyWeatherDetailContainer.sr_width, kWeatherDetailItemWH);
    
    _hourlyLine.frame = CGRectMake(0, CGRectGetMaxY(_hourlyLabel.frame), self.hourlyWeatherDetailContainer.sr_width, 0.5);
    
    _hourlyScrollView.frame = CGRectMake(0, CGRectGetMaxY(_hourlyLine.frame), self.hourlyWeatherDetailContainer.sr_width, kHourlyWeatherInfoViewH - kWeatherDetailItemWH);
  
    CGFloat itemWidth = _hourlyScrollView.sr_width / 5;
    _hourlyScrollView.contentInset = UIEdgeInsetsMake(0, -itemWidth * 0.25, 0, 0);
    for (NSInteger i = 0; i < self.hourlyItemContainers.count; i++) {
        UIView *itemContainer = self.hourlyItemContainers[i];
        itemContainer.frame = CGRectMake(itemWidth * i, 0, itemWidth, _hourlyScrollView.sr_height);
    }
    
    for (NSInteger i = 0; i < self.hourlyTimeLabels.count; i++) {
        UILabel *timeLabel = self.hourlyTimeLabels[i];
        timeLabel.frame = CGRectMake(0, 0, itemWidth, kWeatherDetailItemWH);
    }
    
    for (NSInteger i = 0; i < self.hourlyConditionIcons.count; i++) {
        UIImageView *conditionIcon = self.hourlyConditionIcons[i];
        conditionIcon.frame = CGRectMake(0, kWeatherDetailItemWH, itemWidth, kWeatherDetailItemWH);
    }
    
    for (NSInteger i = 0; i < self.hourlyTemperatureLabels.count; i++) {
        UILabel *temperatureLabel = self.hourlyTemperatureLabels[i];
        temperatureLabel.frame = CGRectMake(0, kWeatherDetailItemWH * 2, itemWidth, kWeatherDetailItemWH);
    }
    
    self.hourlyScrollView.contentSize = CGSizeMake(itemWidth + itemWidth * self.hourlyForecastDics.count, 0);
    
    _dailyWeatherDetailContainer.frame = CGRectMake(kMargin, self.hourlyWeatherDetailContainer.sr_height, SCREEN_WIDTH - kMargin*2, kDailyWeatherInfoViewH);
 
    _dailyLabel.frame = CGRectMake(0, 0, _dailyWeatherDetailContainer.sr_width, kWeatherDetailItemWH);
  
    _dailyLine.frame = CGRectMake(0, CGRectGetMaxY(_dailyLabel.frame), _dailyWeatherDetailContainer.sr_width, 0.5);
  
    _dailyScrollView.frame = CGRectMake(0, CGRectGetMaxY(_dailyLine.frame), _dailyWeatherDetailContainer.sr_width, kDailyWeatherInfoViewH - kWeatherDetailItemWH);
 
    _dailyScrollView.contentInset = UIEdgeInsetsMake(0, -itemWidth * 0.25, 0, 0);
    for (NSInteger i = 0; i < self.dailyItemContainers.count; i++) {
        UIView *itemContainer = self.dailyItemContainers[i];
        itemContainer.frame = CGRectMake(itemWidth * i, 0, itemWidth, kWeatherDetailItemWH * 3);
    }
  
    for (NSInteger i = 0; i < self.dailyDateLabels.count; i++) {
        UILabel *dateLabel = self.dailyDateLabels[i];
        dateLabel.frame = CGRectMake(0, 0, itemWidth, kWeatherDetailItemWH);
    }
  
    for (NSInteger i = 0; i < self.dailyConditionIcons.count; i++) {
        UIImageView *conditionIcon = self.dailyConditionIcons[i];
        conditionIcon.frame = CGRectMake(0, kWeatherDetailItemWH, itemWidth, kWeatherDetailItemWH);
    }
  
    for (NSInteger i = 0; i < self.dailyConditionLabels.count; i++) {
        UILabel *conditionLabel = self.dailyConditionLabels[i];
        conditionLabel.frame = CGRectMake(0, kWeatherDetailItemWH * 2, itemWidth, kWeatherDetailItemWH);
    }
    _dailyScrollView.contentSize = CGSizeMake(itemWidth * self.dailyForecastDics.count, 0);
  
    _chartMax.frame = CGRectMake(0, 3 * kWeatherDetailItemWH + 10, self.dailyWeatherDetailContainer.sr_width * 1.5, KWeatherLineChartHeight);
  
    _chartMin.frame = CGRectMake(0, 3 * kWeatherDetailItemWH + KWeatherLineChartHeight, self.dailyWeatherDetailContainer.sr_width * 1.5, KWeatherLineChartHeight);
}

- (void)updateWeatherInfo {
    NowWeatherData *nowData = [NowWeatherData mj_objectWithKeyValues:_weatherData[@"HeWeather data service 3.0"][0][@"now"]];
    
    for (NSInteger i = 0; i < self.hourlyTemperatureLabels.count; i++) {
        UILabel *label = self.hourlyTemperatureLabels[i];
        if (i == 0) {
            NSString *text = [NSString stringWithFormat:@" %@˚", nowData.tmp];
            label.attributedText = [NSAttributedString attributedStringWithString:text];
        } else {
            NSString *text = [NSString stringWithFormat:@" %@˚", [self.hourlyForecastDics[i - 1] tmp]];
            label.attributedText = [NSAttributedString attributedStringWithString:text];
        }
    }
    
    for (NSInteger i = 0; i < self.hourlyConditionIcons.count; i++) {
        UIImageView *imageView = self.hourlyConditionIcons[i];
        NSInteger weatherCode = [nowData.code integerValue];
        
        imageView.image = [UIImage imageNamed:[SRWeatherAssist getWeatherIconNameWithWeatherCode:weatherCode]];
    }
    
    for (NSInteger i = 0; i < self.dailyConditionIcons.count; i++) {
        UIImageView *imageView = self.dailyConditionIcons[i];
        DailyWeatherData *dailyData = self.dailyForecastDics[i];
        NSInteger weatherCode = [dailyData.code integerValue];
        imageView.image = [UIImage imageNamed:[SRWeatherAssist getWeatherIconNameWithWeatherCode:weatherCode]];
    }
    
    for (NSInteger i = 0; i < self.dailyConditionLabels.count; i++) {
        UILabel *label = self.dailyConditionLabels[i];
        DailyWeatherData *dailyData = self.dailyForecastDics[i];
        label.attributedText = [NSAttributedString attributedStringWithString:dailyData.txt];
    }
    
    [self setupWeatherLineChart];
}

- (void)setupWeatherLineChart {
    [self.chartMax removeFromSuperview];
    WeatherLineChart *chartMax = [[WeatherLineChart alloc] init];
    [[self.dailyWeatherDetailContainer viewWithTag:55] addSubview:chartMax];
    chartMax.drawXPoints = self.drawXPoints;
    chartMax.datas = self.maxTemperatures;
    chartMax.valuePosition = ValuePositionUP;
    chartMax.lineColor = COLOR_RGBA(255, 106, 106, 1.0);
    chartMax.backgroundColor = [UIColor clearColor];
    self.chartMax = chartMax;
    
    [self.chartMin removeFromSuperview];
    WeatherLineChart *chartMin = [[WeatherLineChart alloc] init];
    [[self.dailyWeatherDetailContainer viewWithTag:55] addSubview:chartMin];
    chartMin.drawXPoints = self.drawXPoints;
    chartMin.datas = self.minTemperatures;
    chartMin.valuePosition = ValuePositionDown;
    chartMin.lineColor = COLOR_RGBA(75, 222, 255, 1.0);
    chartMin.backgroundColor = [UIColor clearColor];
    self.chartMin = chartMin;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
