//
//  HiDeceleration.m
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import "HiDeceleration.h"
#import "HiScrollHand.h"

@interface HiDeceleration ()

@property (nonatomic, assign) CGPoint initialValue;
@property (nonatomic, assign) CGPoint initialVelocity;
@property (nonatomic, assign) CGFloat decelerationRate;
@property (nonatomic, assign) CGFloat threshold;

@property (nonatomic, assign, readonly) CGFloat dCoeff;

@end

@implementation HiDeceleration
- (void)updatInitialValue:(CGPoint)initialValue initialVelocity:(CGPoint)initialVelocity decelerationRate:(CGFloat)decelerationRate threshold:(CGFloat)threshold {
    
    self.initialValue = initialValue;
    self.initialVelocity = initialVelocity;
    self.decelerationRate = decelerationRate;
    self.threshold = threshold;
}

- (CGFloat)dCoeff {
    return 1000 * self.decelerationRate;
}

- (CGPoint)destination {
    return CGPointMinusPoint(self.initialValue, CGPointDivideFloat(self.initialVelocity, self.dCoeff));
}

- (NSTimeInterval)duration {
    
    if (CGPointLength(self.initialVelocity) > 0){
        if (0 != self.dCoeff) return -self.dCoeff * self.threshold / CGPointLength(self.initialVelocity) / self.dCoeff;
        return 0;
    }
    
    return 0;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    
    CGFloat v = pow(self.decelerationRate, 1000 * time) - 1;
    CGPoint p = CGPointZero;

    if (0 != self.initialVelocity.x && 0 != self.initialVelocity.y && 0 != self.dCoeff) {
        p = CGPointMake(v / self.initialVelocity.x * self.dCoeff, v / self.initialVelocity.y * self.dCoeff);
    }
    
    return CGPointPlusPoint(self.initialValue, p);
}

- (NSTimeInterval)durationToValue:(CGPoint)value {
    if (CGPointDistanceToSegment(value, self.initialValue, self.destination) >= self.threshold) return 0.0;

    CGFloat initialVelocity_length = CGPointLength(self.initialVelocity);
    CGPoint m = CGPointMinusPoint(value, self.initialValue);
    CGFloat initialValue_length = CGPointLength(m);
    if (0 != self.dCoeff && 0 != initialValue_length)return log(1.0 + self.dCoeff * initialValue_length /initialVelocity_length) / self.dCoeff;
    return 0;
}

- (CGPoint)velocityAtTime:(NSTimeInterval)time {
    CGFloat v = pow(self.decelerationRate, 1000 * time);
    return CGPointMake(self.initialVelocity.x * v, self.initialVelocity.y * v);
}

@end
