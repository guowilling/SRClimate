//
//  NSString+Extension.m
//  YX
//
//  Created by 郭伟林 on 15/11/30.
//  Copyright (c) 2015年 郭伟林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

#pragma mark - String size

/**
*  Accroding the font get the string's best fit size
*
*  @param font The string font
*
*  @return The string's size
*/
- (CGSize)sizeWithFont:(UIFont *)font;

/**
 *  Accroding the font and the width get the string's best fit size
 *
 *  @param font The string font
 *  @param maxW The string max width
 *
 *  @return The string's size
 */
- (CGSize)sizeWithFont:(UIFont *)font  maxWidth:(CGFloat)maxW;

/**
 *  Accroding the font and the width get the string's best fit size
 *
 *  @param font The string font
 *  @param maxH The string max height
 *
 *  @return The string's size
 */
- (CGSize)sizeWithFont:(UIFont *)font  maxHeight:(CGFloat)maxH;

@end
