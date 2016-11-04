//
//  WeatherDataTool.h
//  SRClimate
//
//  Created by 郭伟林 on 16/7/11.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRWeatherDataTool : NSObject

+ (void)loadWeatherDataCity:(NSString *)cityname
                     cityid:(NSString *)cityid
                    success:(void (^)(NSDictionary *weatherData))success
                    failure:(void (^)(NSError *error))failure;

+ (NSDictionary *)cachedWeatherDatas;
+ (void)saveCachedWeatherDatas:(NSDictionary *)cachedWeatherDatas;

@end
