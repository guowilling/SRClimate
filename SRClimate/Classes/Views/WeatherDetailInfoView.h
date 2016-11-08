//
//  WeatherDetailView.h
//  SRClimate
//
//  Created by 郭伟林 on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWeatherDetailItemWH      SCREEN_ADJUST(40)
#define KWeatherLineChartHeight   SCREEN_ADJUST(75)
#define kHourlyWeatherInfoViewH kWeatherDetailItemWH * 4
#define kDailyWeatherInfoViewH  kWeatherDetailItemWH * 4 + KWeatherLineChartHeight * 2

@interface WeatherDetailInfoView : UIScrollView

@property (nonatomic, copy) NSDictionary *weatherData;

@end
