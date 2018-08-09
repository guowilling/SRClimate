//
//  ChineseStringTool.h
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/4/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChineseStringTool : NSObject

/**
 *  返回根据首字母分组排序后的首字母组成的数组
 *
 *  @param stringArr 中文字符串数组
 *
 *  @return 首字母数组
 */
+ (NSMutableArray*)groupingFirstPinyinsFromArray:(NSArray *)array;

/**
 *  返回根据首字母分组排序后的数组
 *
 *  @param stringArr 中文字符串数组
 *
 *  @return 分组排序后的数组
 */
+ (NSMutableArray*)groupingSortedArrayFromArray:(NSArray *)array;

/**
 *  排序数组
 *
 *  @param stringArr 数据源数组
 *
 *  @return 排序后的数组
 */
+ (NSMutableArray*)sortedArrayFromArray:(NSArray *)array;

/**
 *  判断字符串里是否有中文
 *
 *  @param str 源字符串
 *
 *  @return YES: 有 NO: 无
 */
+ (BOOL)isIncludeChineseInString:(NSString*)str;

@end
