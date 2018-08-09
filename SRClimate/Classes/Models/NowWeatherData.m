//
//  NowWeatherData.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NowWeatherData.h"
#import "MJExtension.h"

@implementation NowWeatherData

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"code": @"cond.code",
             @"txt": @"cond.txt"};
}

@end
