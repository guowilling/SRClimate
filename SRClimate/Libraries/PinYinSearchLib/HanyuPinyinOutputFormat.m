//
//  
//
//  Created by kimziv on 13-9-14.
//

#include "HanyuPinyinOutputFormat.h"

@implementation HanyuPinyinOutputFormat

- (id)init {
    self = [super init];
    if (self) {
        _vCharType = VCharTypeWithUAndColon;
        _caseType  = CaseTypeLowercase;
        _toneType  = ToneTypeWithToneNumber;
    }
    return self;
}

@end
