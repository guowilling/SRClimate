//
//  LocationTool.m
//  SRClimate
//
//  Created by 郭伟林 on 16/6/1.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRLocationTool.h"
#import "SRUserDefaults.h"
#import "SRWeatherDataTool.h"

#define YXWeatherAutoLocation              @"weatherAutoLocation"
#define YXWeatherCurrentLocationCity       @"weatherCurrentLocationCity"
#define YXWeatherCurrentLocationState      @"weatherCurrentLocationState"
#define YXWeatherCurrentLocationLongitude  @"weatherCurrentLocationLongitude"
#define YXWeatherCurrentLocationLatitude   @"weatherCurrentLocationLatitude"

static SRLocationTool *instance;

@interface SRLocationTool () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation SRLocationTool

@synthesize autoLocation              = _autoLocation;
@synthesize currentLocationCity       = _currentLocationCity;
@synthesize currentLocationState      = _currentLocationState;
@synthesize currentLocationLongitude  = _currentLocationLongitude;
@synthesize currentLocationLatitude   = _currentLocationLatitude;

+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @synchronized(self) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}
- (instancetype)init {
    
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 10.0;
    }
    return self;
}

- (void)beginLocation {
    
    if (![CLLocationManager locationServicesEnabled]) {
        [SRLocationTool sharedInstance].autoLocation = NO;
        if ([self.delegate respondsToSelector:@selector(locationToolLocationServicesDisabled)]) {
            [self.delegate locationToolLocationServicesDisabled];
        }
        return;
    }
    
    if (IS_iOS8) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusNotDetermined:
                [self.locationManager requestWhenInUseAuthorization];
                break;
                
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                [SRLocationTool sharedInstance].autoLocation = NO;
                if ([self.delegate respondsToSelector:@selector(locationToolLocationServicesAuthorizationStatusDenied)]) {
                    [self.delegate locationToolLocationServicesAuthorizationStatusDenied];
                }
                break;
                
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                if ([self.delegate respondsToSelector:@selector(locationToolLocationServicesAuthorizationStatusAuthorized)]) {
                    [self.delegate locationToolLocationServicesAuthorizationStatusAuthorized];
                }
                if ([SRLocationTool sharedInstance].isAutoLocation) {
                    [self.locationManager startUpdatingLocation];
                }
                break;
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(locationToolLocationServicesAuthorizationStatusAuthorized)]) {
            [self.delegate locationToolLocationServicesAuthorizationStatusAuthorized];
        }
        if ([[SRLocationTool sharedInstance] isAutoLocation]) {
            [self.locationManager startUpdatingLocation];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    HSLog(@"LocationManager didChangeAuthorizationStatus %zd", status);
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        case kCLAuthorizationStatusRestricted:
        {
            break;
        }
        case kCLAuthorizationStatusDenied: {
            [SRLocationTool sharedInstance].autoLocation = NO;
            [SRLocationTool sharedInstance].currentLocationCity = nil;
            if ([self.delegate respondsToSelector:@selector(locationToolLocationServicesAuthorizationStatusDenied)]) {
                [self.delegate locationToolLocationServicesAuthorizationStatusDenied];
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways: {
            
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            [SRLocationTool sharedInstance].autoLocation = YES;
            [self.locationManager startUpdatingLocation];
            if ([self.delegate respondsToSelector:@selector(locationToolLocationServicesLocating)]) {
                [self.delegate locationToolLocationServicesLocating];
            }
            break;
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (_location) {
        [self.locationManager stopUpdatingLocation];
        return;
    }
    _location = [locations firstObject];
    [self getAddress];
}

- (void)getAddress {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            HSLog(@"error: %@", error);
            if ([self.delegate respondsToSelector:@selector(locationToolLocationFailed)]) {
                [self.delegate locationToolLocationFailed];
            }
            return;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        CLLocation *location = placemark.location;
        NSDictionary *addressDic = placemark.addressDictionary;
        self.currentLocationLongitude = @(location.coordinate.longitude);
        self.currentLocationLatitude  = @(location.coordinate.latitude);
        NSString *state = placemark.administrativeArea;
        NSString *cityname = placemark.locality;
        NSString *cityid = nil;
        BOOL isChinese = NO;
        for (int i = 0; i < cityname.length; i++) {
            unichar character = [cityname characterAtIndex:i];
            if (0x4e00 < character && character < 0x9fff) {
                isChinese = YES;
            }
        }
        if (isChinese) {
            state = [state substringToIndex:state.length -1];
            cityname = [cityname substringToIndex:cityname.length -1];
            cityid = [SRWeatherDataTool cityidOfCityname:cityname];
        }
        HSLog(@"addressDic: %@", addressDic);
        HSLog(@"cityid: %@", cityid);
        HSLog(@"cityname: %@", cityname);
        HSLog(@"state: %@", state);
        if (![cityname isEqualToString:[SRLocationTool sharedInstance].currentLocationCity]) {
            [SRLocationTool sharedInstance].currentLocationCity = cityname;
            [SRLocationTool sharedInstance].currentLocationState = state;
            if ([self.delegate respondsToSelector:@selector(locationToolLocationSuccess)]) {
                [self.delegate locationToolLocationSuccess];
            }
        }
    }];
}

- (void)resetLocation {
    
    _location = nil;
}

- (BOOL)isAutoLocation {
    
    if (!_autoLocation) {
        _autoLocation = [SRUserDefaults boolForKey:YXWeatherAutoLocation];
    }
    return _autoLocation;
}

- (void)setAutoLocation:(BOOL)autoLocation {
    
    _autoLocation = autoLocation;
    
    [SRUserDefaults setBool:autoLocation forKey:YXWeatherAutoLocation];
}

- (NSString *)currentLocationCity {
    
    if (!_currentLocationCity) {
        _currentLocationCity = [SRUserDefaults objectForKey:YXWeatherCurrentLocationCity];
    }
    return _currentLocationCity;
}

- (void)setCurrentLocationCity:(NSString *)locationCity {
    
    _currentLocationCity = locationCity;
    
    [SRUserDefaults setObject:locationCity forKey:YXWeatherCurrentLocationCity];
}

- (NSString *)currentLocationState {
    
    if (!_currentLocationState) {
        _currentLocationState = [SRUserDefaults objectForKey:YXWeatherCurrentLocationState];
    }
    return _currentLocationState;
}

- (void)setCurrentLocationState:(NSString *)currentLocationState {
    
    _currentLocationState = currentLocationState;
    
    [SRUserDefaults setObject:currentLocationState forKey:YXWeatherCurrentLocationState];
}

- (NSNumber *)currentLocationLongitude {
    
    if (!_currentLocationLongitude) {
        _currentLocationLongitude = [SRUserDefaults objectForKey:YXWeatherCurrentLocationLongitude];
    }
    return _currentLocationLongitude;
}

- (void)setCurrentLocationLongitude:(NSNumber *)currentLocationLongitude {
    
    _currentLocationLongitude = currentLocationLongitude;
    
    [SRUserDefaults setObject:currentLocationLongitude forKey:YXWeatherCurrentLocationLongitude];
}

- (NSNumber *)currentLocationLatitude {
    
    if (!_currentLocationLatitude) {
        _currentLocationLatitude = [SRUserDefaults objectForKey:YXWeatherCurrentLocationLatitude];
    }
    return _currentLocationLatitude;
}

- (void)setCurrentLocationLatitude:(NSNumber *)currentLocationLatitude {
    
    _currentLocationLatitude = currentLocationLatitude;
    
    [SRUserDefaults setObject:currentLocationLatitude forKey:YXWeatherCurrentLocationLatitude];
}

@end
