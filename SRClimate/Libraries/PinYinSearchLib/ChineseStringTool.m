//
//  ChineseStringTool.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/4/22.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "ChineseStringTool.h"
#import "ChineseString.h"

@implementation ChineseStringTool

+ (NSMutableArray*)groupingFirstPinyinsFromArray:(NSArray *)array {
    NSMutableArray *sortedChineseStringArray = [self sortedChineseStringArrayFromArray:array];
    NSMutableArray *firstPinyins = [NSMutableArray array];
    NSString *tempString;
    for (ChineseString *chineseString in sortedChineseStringArray) {
        NSString *firstPinyin = [chineseString.pinYin substringToIndex:1];
        if(![tempString isEqualToString:firstPinyin]) {
            [firstPinyins addObject:firstPinyin];
            tempString = firstPinyin;
        }
    }
    return firstPinyins;
}

+ (NSMutableArray*)groupingSortedArrayFromArray:(NSArray *)array {
    NSMutableArray *sortedChineseStringArray = [self sortedChineseStringArrayFromArray:array];
    
    NSMutableArray *groupingSortedArray = [NSMutableArray array];
    NSMutableArray *grouping = [NSMutableArray array];
    NSString *tempString;
    for (ChineseString *chineseString in sortedChineseStringArray) {
        NSString *firstPinyin = [chineseString.pinYin substringToIndex:1];
        if(![tempString isEqualToString:firstPinyin]) {
            grouping = [NSMutableArray array];
            [groupingSortedArray addObject:grouping];
            [grouping addObject:chineseString.string];
            tempString = firstPinyin;
        } else {
            [grouping addObject:chineseString.string];
        }
    }
    return groupingSortedArray;
}

+ (NSMutableArray*)sortedArrayFromArray:(NSArray*)stringArr {
    NSMutableArray *sortedChineseStringArray = [self sortedChineseStringArrayFromArray:stringArr];
    NSMutableArray *sortedArray = [NSMutableArray array];
    for (ChineseString *chineseString in sortedChineseStringArray) {
        [sortedArray addObject:chineseString.string];
    }
    return sortedArray;
}

/**
 *  排序中文字符串数组
 *
 *  @param array 中文字符串数组
 *
 *  @return 排序后的ChineseString对象数组
 */
+ (NSMutableArray*)sortedChineseStringArrayFromArray:(NSArray *)array {
    NSMutableArray *chineseStringArray = [NSMutableArray array];
    for(int i = 0; i < array.count; i++) {
        ChineseString *chineseString = [[ChineseString alloc] init];
        chineseString.string = array[i];
        if(!chineseString.string) {
            chineseString.string = @"";
        }
        // 去掉两端的空格和回车
        chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        // 此方法存在问题有些字符过滤不了
        //NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
        //chineseString.string = [chineseString.string stringByTrimmingCharactersInSet:set];
        
        // 递归过滤指定字符串
        chineseString.string = [self removeSpecialCharacter:chineseString.string];
        
        // 判断首字符是否为字母
        NSString *regex = @"[A-Za-z]+";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([predicate evaluateWithObject:chineseString.string]) { // 字母
            // 使首字母大写
            chineseString.pinYin = [chineseString.string capitalizedString];
        } else { // 非字母
            if (![chineseString.string isEqualToString:@""]) {
                NSString *pinyin = [NSString stringWithFormat:@"%c", pinyinFirstLetter([chineseString.string characterAtIndex:0])];
                chineseString.pinYin = [pinyin uppercaseString];
            } else {
                chineseString.pinYin = @"";
            }
        }
        [chineseStringArray addObject:chineseString];
    }
    // 根据pinYin排序
    [chineseStringArray sortUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]]];
    return chineseStringArray;
}

/**
 *  过滤字符串中指定的字符
 *
 *  @param str 需要过滤的字符组成的字符串
 *
 *  @return 过滤后的字符串
 */
+ (NSString*)removeSpecialCharacter:(NSString *)string {
    NSRange range = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@",.？、 ~￥#&<>《》()[]{}【】^@/￡¤|§¨「」『』￠￢￣~@#&*（）——+|《》$_€"]];
    if (range.location != NSNotFound) {
        return [self removeSpecialCharacter:[string stringByReplacingCharactersInRange:range withString:@""]];
    }
    return string;
}

+ (BOOL)isIncludeChineseInString:(NSString*)str {
    for (int i = 0; i < str.length; i++) {
        unichar character = [str characterAtIndex:i];
        if (0x4e00 < character  && character < 0x9fff) {
            return true;
        }
    }
    return false;
}

@end
