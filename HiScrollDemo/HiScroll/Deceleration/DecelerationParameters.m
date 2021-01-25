//
//  DecelerationParameters.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "DecelerationParameters.h"
#import "CGScroll.h"

@interface DecelerationParameters ()

@property (nonatomic, assign) CGPoint initialValue;
@property (nonatomic, assign) CGPoint initialVelocity;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat threshold;

@property (nonatomic, assign, readonly) CGFloat dCoeff;

@end

@implementation DecelerationParameters

- (CGFloat)dCoeff {
    return 1000 * log(self.decelerationRate);
}

- (CGPoint)destination {
    CGPoint p1 = CGPointDivideFloatMake(self.initialVelocity, self.dCoeff);
    return CGPointMinusPointMake(self.initialValue, p1);
}

- (NSTimeInterval)duration {
    if (CGPointLenghtMake(self.initialVelocity) > 0) {
        return log(-self.dCoeff * self.threshold / CGPointLenghtMake(self.initialVelocity)) / self.dCoeff;
    }
    
    return 0;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    CGFloat f1 = pow(self.decelerationRate, 1000 * time) - 1;
    CGFloat f2 = f1 / self.dCoeff;
    CGPoint p1 = CGPointMultiplyFloatMake(self.initialVelocity, f2);
    return CGPointPlusPointMake(self.initialValue, p1);
}

- (NSTimeInterval)durationToValue:(CGPoint)value {
    
    if (CGPointDistance(value, self.initialValue, self.destination) < self.threshold) {
        CGPoint p1 = CGPointMinusPointMake(value, self.initialValue);
        CGFloat f = CGPointLenghtMake(p1);
        return log(1.0 + self.dCoeff * f / CGPointLenghtMake(self.initialVelocity)) / self.dCoeff;
    }
    return 0;
}

- (CGPoint)velocityAtTime:(NSTimeInterval)time {
    return CGPointMultiplyFloatMake(self.initialValue, pow(self.decelerationRate, 1000 * time));
}

- (void)updateInitialValue:(CGPoint)initialValue initialVelocity:(CGPoint)initialVelocity decelerationRate:(CGFloat)decelerationRate threshold:(CGFloat)threshold {
    assert(decelerationRate > 0 && decelerationRate < 1);

    self.initialValue = initialValue;
    self.initialVelocity = initialVelocity;
    self.decelerationRate = decelerationRate;
    self.threshold = threshold;
}

@end
