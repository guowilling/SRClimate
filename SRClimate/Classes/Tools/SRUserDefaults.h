//
//  SRUserDefaults.h
//  SRClimate
//
//  Created by https://github.com/guowilling on 15/11/21.
//  Copyright © 2015年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kHasRequestLocationAuthorization @"hasRequestLocationAuthorization"

@interface SRUserDefaults : NSObject

+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

+ (void)setBool:(BOOL)anBool forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

@end
