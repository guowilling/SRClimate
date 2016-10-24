//
//  
//
//  Created by kimziv on 13-9-14.
//

#import <Foundation/Foundation.h>

@interface ChineseToPinyinResource : NSObject
{
    NSString *_directory;
    NSDictionary *_unicodeToHanyuPinyinTable;
}

- (NSArray *)getHanyuPinyinStringArrayWithChar:(unichar)ch;
- (BOOL)isValidRecordWithNSString:(NSString *)record;
- (NSString *)getHanyuPinyinRecordFromCharWithChar:(unichar)ch;
+ (ChineseToPinyinResource *)getInstance;

@end
