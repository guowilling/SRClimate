//
//  ChineseString.h


#import <Foundation/Foundation.h>
#import "pinyin.h"

@interface ChineseString : NSObject

@property (retain, nonatomic) NSString *string;
@property (retain, nonatomic) NSString *pinYin;


@end