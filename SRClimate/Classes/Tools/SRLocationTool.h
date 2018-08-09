//
//  LocationTool.h
//  SRClimate
//
//  Created by https://github.com/guowilling on 16/6/1.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SRLocationToolDelegate <NSObject>

@optional
- (void)locationToolLocationServicesDisabled;
- (void)locationToolLocationServicesAuthorizationStatusDidChange;
- (void)locationToolLocationServicesAuthorizationStatusDenied;
- (void)locationToolLocationServicesAuthorizationStatusAuthorized;
- (void)locationToolLocationServicesLocating;
- (void)locationToolLocationSuccess;
- (void)locationToolLocationFailed;

@end

@interface SRLocationTool : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, weak) id<SRLocationToolDelegate> delegate;

@property (nonatomic, assign, getter=isAutoLocation) BOOL autoLocation;

@property (nonatomic, strong) NSNumber *currentLocationLongitude;
@property (nonatomic, strong) NSNumber *currentLocationLatitude;

@property (nonatomic, copy  ) NSString *currentLocationCity;
@property (nonatomic, copy  ) NSString *currentLocationState;

- (void)requestAuthorization;

- (void)beginLocation;

@end
