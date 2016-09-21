
#import "WeatherLineChart.h"
#import <math.h>

#define kMargin 25

@interface WeatherLineChart ()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) CGFloat averageHeight;

@end

@implementation WeatherLineChart

- (NSInteger)maxValue {
    
    if (_maxValue == 0) {
        for (int i=0; i<self.data.count; i++) {
            NSInteger value = [self.data[i] integerValue];
            if (_maxValue < value ) {
                _maxValue = value;
            }
        }
    }
    return _maxValue;
}

- (NSInteger)minValue {
    
    if (_minValue == 0) {
        _minValue = [self.data[0] integerValue];
        for (int i=1; i<self.data.count; i++) {
            NSInteger value = [self.data[i] integerValue];
            if (_minValue > value ) {
                _minValue = value;
            }
        }
    }
    return _minValue;
}

- (CGFloat)averageHeight {
    
    if (_averageHeight == 0) {
        if (self.maxValue != self.minValue) {
            _averageHeight = (self.frame.size.height - kMargin) / (self.maxValue - self.minValue);
        }
    }
    return _averageHeight;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self setupLineShapeLayer];
    }
    return self;
}

- (void)setupLineShapeLayer {
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.lineWidth = 2;
    _shapeLayer.lineCap = kCALineCapRound;
    _shapeLayer.lineJoin = kCALineJoinBevel;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
}

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    for (int i=0; i < self.data.count; i++) {
        CGFloat value = [self.data[i] floatValue];
        CGPoint point = [self pointOfValue:value index:i];
        if (i==0) {
            [linePath moveToPoint:point];
        } else {
            //[linePath addLineToPoint:point];
            CGFloat preValue = [self.data[i - 1] floatValue];
            CGPoint prePoint = [self pointOfValue:preValue index:i - 1];
            CGFloat x = prePoint.x + fabs(prePoint.x - point.x) * 0.5;
            CGFloat y1 = MIN(prePoint.y, point.y) + fabs(prePoint.y - point.y) * 0.2;
            CGFloat y2 = MIN(prePoint.y, point.y) + fabs(prePoint.y - point.y) * 0.8;
            if (preValue < value) {
                CGFloat temp;
                temp = y1;
                y1 = y2;
                y2 = temp;
            }
            [linePath addCurveToPoint:point controlPoint1:CGPointMake(x, y1) controlPoint2:CGPointMake(x, y2)];
        }
    }
    _shapeLayer.path = linePath.CGPath;

    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.duration = 2.0;
    pathAnimation.removedOnCompletion = YES;
    [_shapeLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    for (int i=0; i < self.data.count; i++) {
        CGFloat value = [self.data[i] floatValue];
        CGPoint roundPoint = [self pointOfValue:value index:i];
        UIBezierPath *roundPath = [UIBezierPath bezierPath];
        [roundPath addArcWithCenter:roundPoint radius:3 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        layer.path = roundPath.CGPath;
        //layer.fillColor = self.lineColor.CGColor;
        layer.fillColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:layer];
        
        CGRect valueframe = [self.data[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                                  context:nil];
        CGPoint valuePoint;
        if (self.valuePosition == ValuePositionUP) {
            valuePoint = CGPointMake(roundPoint.x - valueframe.size.width * 0.5, roundPoint.y - valueframe.size.height);
        } else {
            valuePoint = CGPointMake(roundPoint.x - valueframe.size.width * 0.5, roundPoint.y);
        }
        [self.data[i] drawAtPoint:valuePoint withAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15],
                                                              NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }
}

- (CGPoint)pointOfValue:(NSInteger)value index:(NSInteger)index {
    
    CGFloat pointHeight;
    if (value == self.minValue) {
        pointHeight = self.frame.size.height * 0.5;
    } else {
        pointHeight = self.frame.size.height - (value - self.minValue) * self.averageHeight;
    }
    if (self.valuePosition == ValuePositionUP) {
        return CGPointMake([self.drawXPoints[index] floatValue], pointHeight - 5);
    } else {
        return CGPointMake([self.drawXPoints[index] floatValue], pointHeight - kMargin + 5);
    }
}

- (void)setLineColor:(UIColor *)lineColor {
    
    _lineColor = lineColor;
    
    _shapeLayer.strokeColor = lineColor.CGColor;
}

@end
