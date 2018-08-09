//
//  MBProgressHUD+SR.m
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/6/16.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "MBProgressHUD+SR.h"

@implementation MBProgressHUD (SR)

#pragma mark - Show HUD

#pragma mark - Only test

+ (MBProgressHUD *)sr_showMessage:(NSString *)message {
    
    return [self sr_showMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showMessage:(NSString *)message onView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
    hud.margin = 12;
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor orangeColor];
    hud.bezelView.backgroundColor = COLOR_RGBA(225, 235, 245, 1.0);
    hud.bezelView.layer.cornerRadius = 20;
    return hud;
}

#pragma mark - UIActivityIndicatorView and text

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message {
    
    return [self sr_showIndeterminateWithMessage:message onView:nil];
}

+ (MBProgressHUD *)sr_showIndeterminateWithMessage:(NSString *)message onView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
    hud.minSize = CGSizeMake(120, 120);
    hud.margin = 15.0;
    hud.contentColor = [UIColor orangeColor];
    hud.bezelView.backgroundColor = COLOR_RGBA(225, 235, 245, 1.0);
    hud.bezelView.layer.cornerRadius = 20;
    //hud.dimBackground = YES;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

#pragma mark - Success icon and text

+ (void)sr_showSuccessWithMessage:(NSString *)message {
    
    [self sr_showSuccessWithMessage:message onView:nil];
}

+ (void)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view {
    
    [self sr_showIconName:@"success.png" message:message onView:view];
}

+ (void)sr_showSuccessWithMessage:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    
    [self sr_showIconName:@"success.png" message:message onView:view completionBlock:completionBlock];
}

#pragma mark - Error icon and text

+ (void)sr_showErrorWithMessage:(NSString *)message {
    
    [self sr_showErrorWithMessage:message onView:nil];
}

+ (void)sr_showErrorWithMessage:(NSString *)message onView:(UIView *)view {
    
    [self sr_showIconName:@"error.png" message:message onView:view];
}

#pragma mark - Info icon and text

+ (void)sr_showInfoWithMessage:(NSString *)message {
    
    [self sr_showInfoWithMessage:message onView:nil];
}

+ (void)sr_showInfoWithMessage:(NSString *)message onView:(UIView *)view {
    
    [self sr_showIconName:@"info.png" message:message onView:view];
}

+ (void)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view {
    
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    if ([iconName isEqualToString:@"success.png"] || [iconName isEqualToString:@"error.png"] || [iconName isEqualToString:@"info.png"]) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]]];
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    }
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
    hud.label.numberOfLines = 0;
    hud.minSize = CGSizeMake(120, 120);
    hud.margin = 15.0;
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor orangeColor];
    hud.bezelView.backgroundColor = COLOR_RGBA(225, 235, 245, 1.0);
    hud.bezelView.layer.cornerRadius = 20;
    [hud hideAnimated:YES afterDelay:2.0];
    hud.userInteractionEnabled = NO;
}

+ (void)sr_showIconName:(NSString *)iconName message:(NSString *)message onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)completionBlock {
    
    if (view == nil) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    if ([iconName isEqualToString:@"success.png"] || [iconName isEqualToString:@"error.png"] || [iconName isEqualToString:@"info.png"]) {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", iconName]]];
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    }
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:SCREEN_ADJUST(17)];
    hud.minSize = CGSizeMake(120, 120);
    hud.margin = 15.0;
    hud.removeFromSuperViewOnHide = YES;
    hud.contentColor = [UIColor orangeColor];
    hud.bezelView.backgroundColor = COLOR_RGBA(225, 235, 245, 1.0);
    hud.bezelView.layer.cornerRadius = 20;
    [hud hideAnimated:YES afterDelay:2.0];
    hud.completionBlock = completionBlock;
    hud.userInteractionEnabled = NO;
}

#pragma mark - Hide HUD

+ (void)sr_hideHUD {
    
    [self sr_hideHUDForView:nil];
}

+ (void)sr_hideHUDForView:(UIView *)view {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)sr_hideHUDForView:(UIView *)view afterDelay:(NSTimeInterval)delay {
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [self HUDForView:view];
    [hud hideAnimated:YES afterDelay:delay];
}

@end
