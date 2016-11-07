//
//  CommonCityController.h
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingCityControllerDelegate <NSObject>

- (void)settingCityControllerDidOpenAutoLocation;
- (void)settingCityControllerDidCloseAutoLocation;

- (void)settingCityControllerDidSelectCity:(NSString *)cityname isLocationCity:(BOOL)isLocationCity;
- (void)settingCityControllerDidDeleteCommonCity:(NSString *)city;
- (void)settingCityControllerDidReorderCommonCity;

@end

@interface SettingCityController : UIViewController

- (void)reloadCommonCityTableViewIsInsert:(BOOL)isInsert;

@property (nonatomic, weak) id<SettingCityControllerDelegate> delegate;

@end
