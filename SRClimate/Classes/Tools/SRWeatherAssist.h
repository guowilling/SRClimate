//
//  SRWeatherAssist.h
//  SRClimate
//
//  Created by 郭伟林 on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRWeatherAssist : NSObject

+ (NSString *)getBackgroundImageNameWithWeatherCode:(NSInteger)weatherCode;

+ (NSString *)getWeatherIconNameWithWeatherCode:(NSInteger)weatherCode;
    
@end
