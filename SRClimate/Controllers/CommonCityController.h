//
//  CommonCityController.h
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommonCityControllerDelegate <NSObject>

- (void)commonCityControllerDidOpenAutoLocation;
- (void)commonCityControllerDidCloseAutoLocation;

- (void)commonCityControllerDidSelectCity:(NSString *)cityname isLocationCity:(BOOL)isLocationCity;
- (void)commonCityControllerDidAddCity;
- (void)commonCityControllerDidDeleteCity;
- (void)commonCityControllerDidReorderCity;

@end

@interface CommonCityController : UIViewController

@property (nonatomic, weak) id<CommonCityControllerDelegate> delegate;

@end
