//
//  DailyWeatherData.m
//  SRClimate
//
//  Created by 郭伟林 on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "DailyWeatherData.h"

@implementation DailyWeatherData

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"tmpMax": @"tmp.max",
             @"tmpMin": @"tmp.min",
             @"code": @"cond.code_d",
             @"txt": @"cond.txt_d"
             };
}


@end
