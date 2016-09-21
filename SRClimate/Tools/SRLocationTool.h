//
//  LocationTool.h
//  SRClimate
//
//  Created by 郭伟林 on 16/6/1.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SRLocationToolDelegate <NSObject>

@optional
- (void)locationToolLocationServicesDisabled;
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

@property (nonatomic, copy  ) NSString *currentLocationCity;
@property (nonatomic, copy  ) NSString *currentLocationState;

@property (nonatomic, strong) NSNumber *currentLocationLongitude;
@property (nonatomic, strong) NSNumber *currentLocationLatitude;

- (void)resetLocation;

- (void)beginLocation;

@end
