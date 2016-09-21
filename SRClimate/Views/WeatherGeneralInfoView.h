//
//  WeatherGeneralInfoView.h
//  SRClimate
//
//  Created by 郭伟林 on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kWeatherGeneralItemWH 49

@interface WeatherGeneralInfoView : UIView

@property (nonatomic, weak) UILabel      *temperatureLabel;
@property (nonatomic, weak) UIImageView  *conditionIcon;
@property (nonatomic, weak) UILabel      *conditionLabel;
@property (nonatomic, weak) UIImageView  *indicatorIcon;
@property (nonatomic, weak) UIImageView  *PMIcon;
@property (nonatomic, weak) UILabel      *PMLabel;

- (void)updateWeatherInfoWithNowWeatherInfo:(NSDictionary *)nowWeatherInfo cityWeatherInfo:(NSDictionary *)cityWeatherInfo;
    
@end