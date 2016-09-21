//
//  WeatherDataTool.h
//  SRClimate
//
//  Created by 郭伟林 on 16/7/11.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRWeatherDataTool : NSObject

+ (void)loadWeatherDataCityname:(NSString *)cityname
                         cityid:(NSString *)cityid
                        success:(void (^)(NSDictionary *weatherData))success
                        failure:(void (^)(NSError *error))failure;

+ (NSString *)defaultCityname;
+ (NSString *)defaultCityid;

+ (NSArray *)commonCities;
+ (NSArray *)hotCities;
+ (NSArray *)allCities;
+ (NSArray *)allCitiesDics;

+ (NSDictionary *)cachedWeatherDatas;

+ (void)saveCommonCities:(NSArray *)commonCities;
+ (void)saveCachedWeatherDatas:(NSDictionary *)cachedWeatherDatas;

+ (NSString *)cityidOfCityname:(NSString *)cityname;

@end
