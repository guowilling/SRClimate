//
//  BannerWeatherView.h
//  SRClimate
//
//  Created by 郭伟林 on 16/7/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewBanner : UIView

@property (nonatomic, weak) UILabel *loadingWeatherLabel;

- (void)updateWithCityname:(NSString *)cityname nowWeatherInfo:(NSDictionary *)nowWeatherInfo;

@end
