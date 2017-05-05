//
//  WeatherDataTool.m
//  SRClimate
//
//  Created by 郭伟林 on 16/7/11.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWeatherDataTool.h"
#import "SRLocationTool.h"
#import "SRUserDefaults.h"
#import "SRHTTPSessionManager.h"

#define kDataCacheInterval 3600

@implementation SRWeatherDataTool

#pragma mark - Load weatehr data

+ (void)loadWeatherDataCity:(NSString *)city
                     cityid:(NSString *)cityid
                    success:(void (^)(NSDictionary *weatherData))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *cachedWeatherDatas = [NSMutableDictionary dictionaryWithDictionary:[self cachedWeatherDatas]];
    if (cachedWeatherDatas[cityid]) {
        NSDictionary *weatherData = cachedWeatherDatas[cityid];
        if (success) {
            success(weatherData);
        }
        NSTimeInterval lastTime = [weatherData[@"time"] doubleValue];
        NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval interval = now - lastTime;
        if (interval < kDataCacheInterval) {
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"key"] = @"d6c40a9f213e42d1a411d709f24721cd";
    params[@"cityid"] = cityid;
    [SRHTTPSessionManager GET:@"https://free-api.heweather.com/x3/weather"
                   parameters:params
                      success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
                          // NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                          // response.statusCode
                          NSString *status = responseObject[@"HeWeather data service 3.0"][0][@"status"];
                          if ([status isEqualToString:@"ok"]) {
                              NSMutableDictionary *responseObjectM = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                              NSTimeInterval timeInterval = [NSDate timeIntervalSinceReferenceDate];
                              NSDictionary *timeDic = @{@"time": @(timeInterval)};
                              [responseObjectM addEntriesFromDictionary:timeDic];
                              [cachedWeatherDatas addEntriesFromDictionary:@{cityid: responseObjectM}];
                              [self saveCachedWeatherDatas:cachedWeatherDatas];
                              if (success) {
                                  success(responseObjectM);
                              }
                          } else {
                              if (cachedWeatherDatas[cityid]) {
                                  if (failure) {
                                      failure(nil);
                                  }
                              } else {
                                  if (failure) {
                                      failure([NSError errorWithDomain:@"网络异常" code:0 userInfo:nil]);
                                  }
                              }
                          }
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          if (cachedWeatherDatas[cityid]) {
                              if (failure) {
                                  failure(nil);
                              }
                          } else {
                              if (failure) {
                                  failure(error);
                              }
                          }
                      }];
}

+ (NSDictionary *)cachedWeatherDatas {
    
    NSString *filePath = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:@"cachedWeatherDatas.plist"];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

+ (void)saveCachedWeatherDatas:(NSDictionary *)cachedWeatherDatas {
    
    NSString *filePath = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:@"cachedWeatherDatas.plist"];
    [cachedWeatherDatas writeToFile:filePath atomically:YES];
}

@end
