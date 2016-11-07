//
//  UILabel+Font.m
//  SRClimate
//
//  Created by 郭伟林 on 16/6/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UILabel+Font.h"
#import <objc/runtime.h>


@implementation UILabel (Font)

+ (void)load {
    
    [super load];
    
    Method oldImp = class_getInstanceMethod([self class], @selector(setFont:));
    Method newImp = class_getInstanceMethod([self class], @selector(mySetFont:));
    method_exchangeImplementations(oldImp, newImp);
}

- (void)mySetFont:(UIFont *)font {
    
    CGFloat fontSize = font.pointSize;
    if ([font.fontName isEqualToString:@"GillSans-Light"]) {
        [self mySetFont:[UIFont fontWithName:font.fontName size:fontSize]];
    } else {
        [self mySetFont:[UIFont fontWithName:@"PingFangSC-Light" size:fontSize]];
    }
}

@end
