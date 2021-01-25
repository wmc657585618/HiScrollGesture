//
//  Deceleration.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "Deceleration.h"
#import "CGScroll.h"

@interface Deceleration ()

/// 初始的 contentOffset — 抬起手指的位置点。
@property (nonatomic, assign) CGPoint initialValue;

/// 抬起手指的初始速度
@property (nonatomic, assign) CGPoint initialVelocity;

/// 衰减率
@property (nonatomic, assign, readonly) CGFloat decelerationRate;

/// 确定衰减时间的阈值
@property (nonatomic, assign, readonly) CGFloat threshold;

@property (nonatomic, assign, readonly) CGFloat dCoeff;

@end

@implementation Deceleration

- (CGFloat)decelerationRate {
    return UIScrollViewDecelerationRateNormal;
}

- (CGFloat)threshold {
    static CGFloat v = -1;
    if (-1 == v) v = 0.5 / UIScreen.mainScreen.scale;
    return v;
}
- (CGFloat)dCoeff {
    return 1000 * log(self.decelerationRate);
}

- (void)updateInitialValue:(CGPoint)initialValue initialVelocity:(CGPoint)initialVelocity {
    self.initialValue = initialValue;
    self.initialVelocity = initialVelocity;
}

/// 衰减滚动停止的点
- (CGPoint)destination {
    CGPoint p = CGPointDivideFloatMake(self.initialVelocity, self.dCoeff);
    return CGPointMinusPointMake(self.initialValue, p);
}

/// 衰减动画时间
- (NSTimeInterval)duration {
    CGFloat length = CGPointLenghtMake(self.initialVelocity);
    if (length > 0) return  log(-self.dCoeff * self.threshold / length) / self.dCoeff;
    return 0;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    CGFloat v = (pow(self.decelerationRate, 1000 * time) - 1) / self.dCoeff;
    CGPoint p = CGPointMultiplyFloatMake(self.initialVelocity, v);
    return CGPointPlusPointMake(self.initialValue, p);
}

@end
