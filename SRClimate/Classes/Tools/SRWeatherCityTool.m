//
//  SRWeatherCityTool.m
//  SRClimate
//
//  Created by 郭伟林 on 16/11/4.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWeatherCityTool.h"

static NSString * const kCommonCitiesFileName   = @"commonCities.plist";

static NSString * const kHotCitiesFileName      = @"hotCities.plist";
static NSString * const kAllCitiesFileName      = @"allCities.plist";
static NSString * const kAllCitiesDicsFileName  = @"allCitiesDics.plist";


@implementation SRWeatherCityTool

+ (void)saveCommonCities:(NSArray *)commonCities {
    
    NSString *filePath = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:kCommonCitiesFileName];
    [commonCities writeToFile:filePath atomically:YES];
}

#pragma mark - Cities

+ (NSArray *)commonCities {
    
    NSString *filePath = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:kCommonCitiesFileName];
    NSArray *commonCities = [NSArray arrayWithContentsOfFile:filePath];
    if (!commonCities) {
        commonCities = @[@"北京", @"上海", @"广州", @"深圳", @"成都"];
    }
    return commonCities;
}

+ (NSArray *)hotCities {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kHotCitiesFileName ofType:nil];
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSArray *)allCities {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kAllCitiesFileName ofType:nil];
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSArray *)allCitiesDics {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:kAllCitiesDicsFileName ofType:nil];
    return [NSArray arrayWithContentsOfFile:filePath];
}

#pragma mark - Tool method

+ (NSString *)defaultCity {
    
    NSArray *commonCities = [self commonCities];
    NSString *cityname;
    if (commonCities.count > 0) {
        cityname = commonCities[0];
    } else {
        cityname = @"北京";
    }
    return cityname;
}

+ (NSString *)defaultCityid {
    
    return [self cityidOfCityname:[self defaultCity]];
}

+ (NSString *)cityidOfCityname:(NSString *)cityname {
    
    NSArray *allCitiesDics = [self allCitiesDics];
    for (NSInteger i = 0; i < allCitiesDics.count; i++) {
        NSDictionary *cityDic = allCitiesDics[i];
        if ([cityname isEqualToString:cityDic[@"city"]]) {
            return cityDic[@"id"];
        }
    }
    return nil;
}

@end
