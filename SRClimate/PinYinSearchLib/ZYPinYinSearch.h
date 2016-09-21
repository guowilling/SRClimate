//
//  ZYPinYinSearch.h
//  ZYPinYinSearch
//
//  Created by soufun on 15/7/27.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYPinYinSearch : NSObject

/**
*  根据匹配文本过滤数组 支持NSString/NSDictionnary/自定义Model
*
*  @param originalArray 数据源数组
*  @param searchText    匹配文本
*  @param propertyName  按照字典中或者模型中哪个字段搜索, 如果数组中存的是NSString则传@""即可
*
*  @return 匹配的数组
*/
+ (NSArray *)searchWithOriginalArray:(NSArray *)originalArray searchText:(NSString *)searchText searchByPropertyName:(NSString *)propertyName;

@end
