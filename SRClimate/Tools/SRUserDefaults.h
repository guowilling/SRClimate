//
//  SRUserDefaults.h
//  SRClimate
//
//  Created by 郭伟林 on 15/11/21.
//  Copyright © 2015年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRUserDefaults : NSObject

+ (void)setObject:(id)obj forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;

+ (void)setBool:(BOOL)anBool forKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

@end