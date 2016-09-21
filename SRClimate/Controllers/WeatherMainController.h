//
//  WeatherMainViewController.h
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherMainController;

@protocol WeatherMainControllerDelegate <NSObject>

- (void)weatherMainControllerDidCloseAutoLocation;
- (void)weatherMainControllerDidDismiss;

@end

@interface WeatherMainController : UIViewController

@property (nonatomic, copy) NSDictionary *weatherData;

@property (nonatomic, weak) id<WeatherMainControllerDelegate> delegate;

- (void)updateToolBarWithCityname:(NSString *)cityname;
- (void)loadWeatherDataOfCityname:(NSString *)cityname cityid:(NSString *)cityid;

- (void)showLocatingTips;
- (void)hideLocatingTips;
- (void)showLocationFailedTips;

@end

