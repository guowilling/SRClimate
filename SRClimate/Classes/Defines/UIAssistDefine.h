//
//  UIAssistDefine.h
//  SRClimate
//
//  Created by 郭伟林 on 16/7/12.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <sys/time.h>

#ifndef UIAssistDefine_h
#define UIAssistDefine_h

#pragma mark - COLOR

#define COLOR_RGBA(r,g,b,a)             [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define COLOR_RANDOM                    COLOR_RGBA(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.0)
#define COLOR_BACKGROUND_GRAY           COLOR_RGBA(240, 240, 240, 1.0)
#define COLOR_DIVIDERLIN                COLOR_RGBA(240, 240, 240, 1.0)

#pragma mark - SCREENSIZE

#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
#define SCREEN_WIDTH            SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT           SCREEN_BOUNDS.size.height
#define SCREEN_ADJUST(Value)    ceilf(SCREEN_WIDTH * (Value) / 375.0f)

#define IS_iPad      [[UIDevice currentDevice].model containsString:@"iPad"]
#define IS_iOS8      [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define IS_iOS10     [[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0

#endif /* UIAssistDefine_h */
