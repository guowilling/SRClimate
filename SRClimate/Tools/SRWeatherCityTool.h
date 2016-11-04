//
//  SRWeatherCityTool.h
//  SRClimate
//
//  Created by 郭伟林 on 16/11/4.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRWeatherCityTool : NSObject

+ (NSString *)defaultCity;
+ (NSString *)defaultCityid;

+ (NSArray *)commonCities;
+ (void)saveCommonCities:(NSArray *)commonCities;

+ (NSArray *)hotCities;

+ (NSArray *)allCities;

+ (NSArray *)allCitiesDics;

+ (NSString *)cityidOfCityname:(NSString *)cityname;

@end
