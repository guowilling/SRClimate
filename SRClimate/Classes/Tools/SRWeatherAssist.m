//
//  SRWeatherAssist.m
//  SRClimate
//
//  Created by 郭伟林 on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWeatherAssist.h"

@implementation SRWeatherAssist

+ (NSString *)getBackgroundImageNameWithWeatherCode:(NSInteger)weatherCode {
    
    NSString *imageName;
    switch (weatherCode) {
        case 100:
        {
            imageName = @"background_sunny.jpeg";
        }
            break;
        case 101:
        case 102:
        case 103:
        {
            imageName = @"background_cloudy.jpeg";
        }
            break;
        case 104:
        case 300:
        case 301:
        case 302:
        case 303:
        case 304:
        case 305:
        case 306:
        case 307:
        case 308:
        case 309:
        case 310:
        case 311:
        case 312:
        case 313:
        case 400:
        case 401:
        {
            imageName = @"background_rainy.jpeg";
        }
            break;
        case 402:
        case 403:
        case 404:
        case 405:
        case 406:
        case 407:
        {
            imageName = @"background_snowy.jpeg";
        }
            break;
        default:
            imageName = @"background_cloudy.jpeg";
            break;
    }
    return imageName;
}

+ (NSString *)getWeatherIconNameWithWeatherCode:(NSInteger)weatherCode {
    
    NSString *weatherIconName = nil;
    switch (weatherCode) {
        case 100:
        case 102:
            weatherIconName = @"new_weather_sunny";
            break;
        case 101:
        case 103:
            weatherIconName = @"new_weather_cloudy";
            break;
        case 104:
            weatherIconName = @"new_weather_overcast";
            break;
        case 300:
        case 301:
        case 307:
        case 308:
        case 310:
        case 311:
        case 312:
        case 313:
            weatherIconName = @"new_weather_heavyrain";
            break;
        case 302:
        case 303:
            weatherIconName = @"new_weather_thundershower";
            break;
        case 305:
        case 309:
            weatherIconName = @"new_weather_lightrain";
            break;
        case 306:
            weatherIconName = @"new_weather_mediumrain";
            break;
        case 400:
        case 401:
            weatherIconName = @"new_weather_lightsnow";
            break;
        case 403:
            weatherIconName = @"new_weather_heavysnow";
            break;
        case 304:
        case 404:
            weatherIconName = @"new_weather_hailstone";
            break;
        case 405:
        case 406:
        case 407:
            weatherIconName = @"new_weather_rainandsnow";
            break;
        case 500:
        case 501:
            weatherIconName = @"new_weahter_fog";
            break;
        default:
            weatherIconName = @"new_weather_NA";
            break;
    }
    return weatherIconName;
}

@end
