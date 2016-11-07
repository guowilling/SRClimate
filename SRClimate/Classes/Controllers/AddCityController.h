//
//  SearchCityController.h
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCityControllerDelegate <NSObject>

- (void)addCityControllerDidAddCity:(NSString *)city;

@end

@interface AddCityController : UIViewController

@property (nonatomic, weak) id<AddCityControllerDelegate> delegate;

@end
