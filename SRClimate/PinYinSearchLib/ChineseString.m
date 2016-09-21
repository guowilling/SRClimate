//
//  ChineseString.m


#import "ChineseString.h"

@implementation ChineseString

- (NSString *)description {
    
    return [NSString stringWithFormat:@"string: %@, pinYin: %@", _string, _pinYin];
}

@end