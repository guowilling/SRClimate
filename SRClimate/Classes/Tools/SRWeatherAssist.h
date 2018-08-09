//
//  SRWeatherAssist.h
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRWeatherAssist : NSObject

+ (NSString *)getBackgroundImageNameWithWeatherCode:(NSInteger)weatherCode;

+ (NSString *)getWeatherIconNameWithWeatherCode:(NSInteger)weatherCode;
    
@end
