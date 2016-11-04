//
//  SRWeatherCityTool.m
//  SRClimate
//
//  Created by 郭伟林 on 16/11/4.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWeatherCityTool.h"

@implementation SRWeatherCityTool

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

+ (NSArray *)commonCities {
    
    NSString *filePath = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:@"commonCities.plist"];
    NSArray *commonCities = [NSArray arrayWithContentsOfFile:filePath];
    if (!commonCities) {
        commonCities = @[@"北京", @"上海", @"广州", @"深圳", @"成都"];
    }
    return commonCities;
}

+ (void)saveCommonCities:(NSArray *)commonCities {
    
    NSString *filePath = [[[UIApplication sharedApplication] cachesPath] stringByAppendingPathComponent:@"commonCities.plist"];
    [commonCities writeToFile:filePath atomically:YES];
}

+ (NSArray *)hotCities {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"hotCities" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSArray *)allCities {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allCities" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSArray *)allCitiesDics {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"allCitiesDics" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
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
