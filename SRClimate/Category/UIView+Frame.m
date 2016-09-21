//
//  UIView+Frame.m
//  SRClimate
//
//  Created by 郭伟林 on 16/8/31.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)sr_x {
    
    return self.frame.origin.x;
}

- (void)setSr_x:(CGFloat)sr_x {
    
    CGRect frame = self.frame;
    frame.origin.x = sr_x;
    self.frame = frame;
}

- (CGFloat)sr_y {
    
    return self.frame.origin.y;
}

- (void)setSr_y:(CGFloat)sr_y {
    
    CGRect frame = self.frame;
    frame.origin.y = sr_y;
    self.frame = frame;
}

- (CGFloat)sr_width {
    
    return self.frame.size.width;
}

- (void)setSr_width:(CGFloat)sr_width {
    
    CGRect frame = self.frame;
    frame.size.width = sr_width;
    self.frame = frame;
}

- (CGFloat)sr_height {
    
    return self.frame.size.height;
}

- (void)setSr_height:(CGFloat)sr_height {
    
    CGRect frame = self.frame;
    frame.size.height = sr_height;
    self.frame = frame;
}

- (CGFloat)sr_centerX {
    
    return self.center.x;
}

- (void)setSr_centerX:(CGFloat)sr_centerX {
    
    CGPoint center = self.center;
    center.x = sr_centerX;
    self.center = center;
}

- (CGFloat)sr_centerY {
    
    return self.center.y;
}

- (void)setSr_centerY:(CGFloat)sr_centerY {
    
    CGPoint center = self.center;
    center.y = sr_centerY;
    self.center = center;
}

- (CGPoint)sr_origin {
    
    return self.frame.origin;
}

- (void)setSr_origin:(CGPoint)sr_origin {
    
    CGRect frame = self.frame;
    frame.origin = sr_origin;
    self.frame = frame;
}

- (CGSize)sr_size {
    
    return self.frame.size;
}

- (void)setSr_size:(CGSize)sr_size {
    
    CGRect frame = self.frame;
    frame.size = sr_size;
    self.frame = frame;
}

- (CGFloat)sr_top {
    
    return self.sr_y;
}

- (void)setSr_top:(CGFloat)sr_top {
    
    [self setSr_y:sr_top];
}

- (CGFloat)sr_left {
    
    return self.sr_x;
}

- (void)setSr_left:(CGFloat)sr_left {
    
    [self setSr_x:sr_left];
}

- (CGFloat)sr_bottom {
    
    return CGRectGetMaxY(self.frame);
}

- (void)setSr_bottom:(CGFloat)sr_bottom {
    
    [self setSr_y:(sr_bottom - self.sr_height)];
}

- (CGFloat)sr_right {
    
    return CGRectGetMaxX(self.frame);
}

- (void)setSr_right:(CGFloat)sr_right {
    
    [self setSr_x:(sr_right - self.sr_width)];
}

@end
