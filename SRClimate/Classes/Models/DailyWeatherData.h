//
//  DailyWeatherData.h
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/11/7.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyWeatherData : NSObject

@property (nonatomic, copy) NSString *tmpMax;
@property (nonatomic, copy) NSString *tmpMin;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *txt;

@end
