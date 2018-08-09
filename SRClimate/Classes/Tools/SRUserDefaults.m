//
//  SRUserDefaults.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 15/11/21.
//  Copyright © 2015年 SR. All rights reserved.
//

#import "SRUserDefaults.h"

@implementation SRUserDefaults

+ (void)setObject:(id)obj forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setBool:(BOOL)anBool forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:anBool forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

@end
