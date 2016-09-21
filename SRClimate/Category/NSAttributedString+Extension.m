//
//  NSAttributedString+Extension.m
//  SRClimate
//
//  Created by 郭伟林 on 16/9/20.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "NSAttributedString+Extension.h"

@implementation NSAttributedString (Extension)

+ (instancetype)attributedStringWithString:(NSString *)string {
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    shadow.shadowBlurRadius = 2;
    shadow.shadowOffset = CGSizeMake(1, -1);
    [attStr addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, string.length)];
    return attStr;
}

@end
