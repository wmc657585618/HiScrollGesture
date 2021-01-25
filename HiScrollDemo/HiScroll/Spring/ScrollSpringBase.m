//
//  ScrollSpringBase.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "ScrollSpringBase.h"

@implementation ScrollSpringBase

- (CGFloat)threshold {
    // 阈值设置为半个像素
    static CGFloat _threshold = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _threshold = 0.5 / UIScreen.mainScreen.scale;
    });
    
    return _threshold;
}

- (Spring)spring {
    // 阻尼比设置为 1，这样在内容边界附近就不会产生周期振荡的动画效果。
    static Spring _spring;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat mass = 1;
        CGFloat stiffness = 100;
        CGFloat dampingRatio = 1;
        CGFloat damping = 2 * dampingRatio * sqrt(mass * stiffness);
        CGFloat beta = damping / (2 * mass);
        CGFloat dampedNaturalFrequency = sqrt(stiffness / mass) * sqrt(1 - dampingRatio * dampingRatio);
        Spring spring = {mass,stiffness,dampingRatio,damping,beta,dampedNaturalFrequency};
        _spring = spring;
    });
    
    return _spring;
}
- (NSTimeInterval)durationToValue:(CGPoint)value {
    return 0;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    return CGPointZero;
}

@end
