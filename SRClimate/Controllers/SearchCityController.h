//
//  SearchCityController.h
//  SRClimate
//
//  Created by 郭伟林 on 16/4/15.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCityControllerDelegate <NSObject>

- (void)searchCityControllerDidAddCity;
- (void)searchCityControllerDidAddMoreThan12Cities;
- (void)searchCityControllerCityHasAdded;

@end

@interface SearchCityController : UIViewController

@property (nonatomic, weak) id<SearchCityControllerDelegate> delegate;

@end
