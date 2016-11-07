//
//  SRWeatherCityTool.h
//  SRClimate
//
//  Created by 郭伟林 on 16/11/4.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRWeatherCityTool : NSObject

+ (NSArray *)commonCities;
+ (NSArray *)hotCities;
+ (NSArray *)allCities;
+ (NSArray *)allCitiesDics;
+ (void)saveCommonCities:(NSArray *)commonCities;

+ (NSString *)defaultCity;
+ (NSString *)defaultCityid;
+ (NSString *)cityidOfCityname:(NSString *)cityname;

@end
