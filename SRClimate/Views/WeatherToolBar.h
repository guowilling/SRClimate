//
//  WeatherToolBar.h
//  SRClimate
//
//  Created by 郭伟林 on 16/5/6.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtomItemWH     49
#define kButtomContainerH 49

@protocol WeatherToolBarDelegate <NSObject>

- (void)weatherToolBarDidClickDismissBtn;
- (void)weatherToolBarDidClickMoreCityBtn;
- (void)weatherToolBarDidScrollToIndex:(NSInteger)index;

@end

@interface WeatherToolBar : UIView

@property (nonatomic, weak) id<WeatherToolBarDelegate> delegate;

@property (nonatomic, weak) UIScrollView  *cityScrollView;
@property (nonatomic, weak) UIPageControl *cityPageControl;

- (instancetype)initWithLocationCity:(NSString *)locationCity commonCities:(NSArray *)commonCities;

- (void)updateWithCityname:(NSString *)cityname commonCities:(NSArray *)commonCities;

- (void)updateBackward;

- (void)updateForward;

@end
