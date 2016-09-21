
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ValuePosition) {
    ValuePositionUP,
    ValuePositionDown,
};

@interface WeatherLineChart : UIView

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *drawXPoints;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) ValuePosition valuePosition;

@end
