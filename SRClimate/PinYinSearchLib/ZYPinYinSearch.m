//
//  ZYPinYinSearch.m
//  ZYPinYinSearch
//
//  Created by soufun on 15/7/27.
//  Copyright (c) 2015年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYPinYinSearch.h"
#import "PinYinForObjc.h"
#import "ChineseStringTool.h"
#import <objc/runtime.h>

@implementation ZYPinYinSearch

+ (NSArray *)searchWithOriginalArray:(NSArray *)originalArray searchText:(NSString *)searchText searchByPropertyName:(NSString *)propertyName {
    
    NSMutableArray *dataSourceArray = [[NSMutableArray alloc] init];
    NSString *type;
    if (originalArray && originalArray.count > 0) {
        id object = originalArray[0];
        if ([object isKindOfClass:[NSString class]]) {
            type = @"string";
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            type = @"dict";
            NSDictionary *dict = object;
            BOOL isExit = NO;
            for (NSString *key in dict.allKeys) {
                if ([key isEqualToString:propertyName]) {
                    isExit = YES;
                    break;
                }
            }
        } else {
            type = @"model";
            NSMutableArray *propertyNames = [NSMutableArray array];
            unsigned int outCount;
            objc_property_t *properties = class_copyPropertyList([object class], &outCount);
            for (int i = 0; i < outCount; i++) {
                objc_property_t property = properties[i];
                const char *char_name = property_getName(property);
                NSString *propertyName = [NSString stringWithUTF8String:char_name];
                [propertyNames addObject:propertyName];
            }
            free(properties);
            
            BOOL isExit = NO;
            for (NSString *propertyname in propertyNames) {
                if([propertyname isEqualToString:propertyName]){
                    isExit = YES;
                    break;
                }
            }
        }
    }
    
    if (searchText.length > 0) {
        if ([ChineseStringTool isIncludeChineseInString:searchText]) {
            for (id object in originalArray) {
                NSString *tempString;
                if ([type isEqualToString:@"string"]) {
                    tempString = object;
                } else {
                    tempString = [object valueForKey:propertyName];
                }
                NSRange range = [tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
                if (range.length > 0) {
                    [dataSourceArray addObject:object];
                }
            }
        }
        
        if (![ChineseStringTool isIncludeChineseInString:searchText]) {
            for (id object in originalArray) {
                NSString *tempString;
                if ([type isEqualToString:@"string"]) {
                    tempString = object;
                } else {
                    tempString = [object valueForKey:propertyName];
                }
                
                if ([ChineseStringTool isIncludeChineseInString:tempString]) {
                    NSString *tempPinYinFull = [PinYinForObjc chineseConvertToPinYin:tempString];
                    NSRange rangeFull = [tempPinYinFull rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (rangeFull.length > 0) {
                        [dataSourceArray addObject:object];
                        continue;
                    }
                    
                    NSString *tempPinYinHead = [PinYinForObjc chineseConvertToPinYinHead:tempString];
                    NSRange rangeHead = [tempPinYinHead rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (rangeHead.length > 0) {
                        [dataSourceArray addObject:object];
                        continue;
                    }
                }
                
                if (![ChineseStringTool isIncludeChineseInString:tempString]) {
                    NSRange range = [tempString rangeOfString:searchText options:NSCaseInsensitiveSearch];
                    if (range.length > 0) {
                        [dataSourceArray addObject:object];
                        continue;
                    }
                }
            }
        }
    }
    return dataSourceArray;
}

@end
