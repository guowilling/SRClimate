//
//  
//
//  Created by kimziv on 13-9-14.
//

#import <Foundation/Foundation.h>

@class HanyuPinyinOutputFormat;

@interface PinyinHelper : NSObject

+ (NSArray *)toHanyuPinyinStringArrayWithChar:(unichar)ch;
+ (NSArray *)toHanyuPinyinStringArrayWithChar:(unichar)ch withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat;
+ (NSArray *)getFormattedHanyuPinyinStringArrayWithChar:(unichar)ch withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat;
+ (NSArray *)getUnformattedHanyuPinyinStringArrayWithChar:(unichar)ch;
+ (NSArray *)toTongyongPinyinStringArrayWithChar:(unichar)ch;
+ (NSArray *)toWadeGilesPinyinStringArrayWithChar:(unichar)ch;
+ (NSArray *)toMPS2PinyinStringArrayWithChar:(unichar)ch;
+ (NSArray *)toYalePinyinStringArrayWithChar:(unichar)ch;
+ (NSArray *)convertToTargetPinyinStringArrayWithChar:(unichar)ch withPinyinRomanizationType:(NSString *)targetPinyinSystem;
+ (NSArray *)toGwoyeuRomatzyhStringArrayWithChar:(unichar)ch;
+ (NSArray *)convertToGwoyeuRomatzyhStringArrayWithChar:(unichar)ch;


+ (NSString *)chineseConvertToPinYin:(NSString *)chinese
             hanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat
                        withSeparator:(NSString *)separator;

+ (NSString *)getFirstHanyuPinyinStringWithChar:(unichar)ch withHanyuPinyinOutputFormat:(HanyuPinyinOutputFormat *)outputFormat;

@end
