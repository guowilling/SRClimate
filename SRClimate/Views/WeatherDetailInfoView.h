//
//  WeatherDetailView.h
//  SRClimate
//
//  Created by 郭伟林 on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWeatherDetailItemWH 39
#define kHourlyWeatherInfoViewH kWeatherDetailItemWH * 4
#define kDailyWeatherInfoViewH  kWeatherDetailItemWH * 4 + 150

@interface WeatherDetailInfoView : UIScrollView

@property (nonatomic, copy) NSDictionary *weatherData;

@end
