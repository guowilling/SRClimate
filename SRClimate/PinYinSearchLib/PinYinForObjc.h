//
//  PinYinForObjc.h
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HanyuPinyinOutputFormat.h"
#import "PinyinHelper.h"

@interface PinYinForObjc : NSObject

/**
 *  中文对应的所有拼音
 *
 *  @param chinese 中文
 *
 *  @return 拼音
 */
+ (NSString *)chineseConvertToPinYin:(NSString *)chinese;

/**
 *  中文对应的拼音首字母
 *
 *  @param chinese 中文
 *
 *  @return 拼音首字母
 */
+ (NSString *)chineseConvertToPinYinHead:(NSString *)chinese;

@end
