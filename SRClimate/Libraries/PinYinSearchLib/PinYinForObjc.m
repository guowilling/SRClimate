//
//  PinYinForObjc.m
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "PinYinForObjc.h"

@implementation PinYinForObjc

+ (NSString *)chineseConvertToPinYin:(NSString *)chinese {
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *pinyinFull = [PinyinHelper chineseConvertToPinYin:chinese hanyuPinyinOutputFormat:outputFormat withSeparator:@""];
    return pinyinFull;
}

+ (NSString *)chineseConvertToPinYinHead:(NSString *)chinese {
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSMutableString *pinyinHeaders = [[NSMutableString alloc] init];
    for (int i = 0; i < chinese.length; i++) {
        NSString *firstHanyuPinyin = [PinyinHelper getFirstHanyuPinyinStringWithChar:[chinese characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (firstHanyuPinyin) {
            [pinyinHeaders appendString:[firstHanyuPinyin substringToIndex:1]];
        }
    }
    return pinyinHeaders;
}

@end
