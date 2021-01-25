//
//  HiSpringTiming.m
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import "HiSpringTiming.h"
#import "HiScrollHand.h"
#import "HiSpring.h"

@interface HiSpringTimingBase ()

@property (nonatomic, strong) HiSpring *spring;
@property (nonatomic, assign) CGPoint displacement;
@property (nonatomic, assign) CGPoint initialVelocity;
@property (nonatomic, assign) CGFloat threshold;

@end

@implementation HiSpringTimingBase

- (HiSpring *)spring {
    if (!_spring) {
        _spring = [[HiSpring alloc] initWithMass:1 stiffness:100 dampingRatio:1];
    }
    return _spring;
}

- (NSTimeInterval)duration {
    return 0;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    return CGPointZero;
}

@end


@interface HiUnderdampedSpringTimingParameters : HiSpringTimingBase

@property (nonatomic, assign, readonly) CGPoint c2;

@end

@implementation HiUnderdampedSpringTimingParameters

- (NSTimeInterval)duration {
    if (0 == CGPointLength(self.displacement) && 0 == CGPointLength(self.initialVelocity)) {
        return 0;
    }
    
    return log((CGPointLength(self.displacement) + CGPointLength(self.c2)) / self.threshold) / self.spring.beta;
}

- (CGPoint)c2 {
    CGPoint displacement = CGPointMultiplyFloat(self.displacement, self.spring.beta);
    CGPoint initialVelocity = CGPointPlusPoint(self.initialVelocity, displacement);
    return CGPointDivideFloat(initialVelocity, self.spring.dampedNaturalFrequency);
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    
    CGFloat wd = self.spring.dampedNaturalFrequency;
    CGPoint point1 = CGPointMultiplyFloat(self.displacement, cos(wd * time));
    CGPoint point2 = CGPointMultiplyFloat(self.c2, sin(wd * time));
    CGPoint point3  = CGPointPlusPoint(point1, point2);
    return CGPointMultiplyFloat(point3, exp(-self.spring.beta * time));
}

@end


@interface HiCriticallyDampedSpringTimingParameters : HiSpringTimingBase

@property (nonatomic, assign, readonly) CGPoint c2;

@end

@implementation HiCriticallyDampedSpringTimingParameters

- (CGPoint)c2 {
    CGPoint point1 = CGPointMultiplyFloat(self.displacement, self.spring.beta);
    return CGPointPlusPoint(self.initialVelocity, point1);
}

- (NSTimeInterval)duration {
    
    if (0 == CGPointLength(self.displacement) && 0 == CGPointLength(self.initialVelocity)) return 0;
    
    CGFloat b = self.spring.beta;
    CGFloat e = M_E;
    CGFloat t1 = 1 / b * log(2 * CGPointLength(self.displacement) / self.threshold);
    CGFloat t2 = 2 / b * log(4 * CGPointLength(self.c2) / (e * b * self.threshold));
    return fmax(t1, t2);
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {

    CGPoint point1 = CGPointMultiplyFloat(self.c2, time);
    CGPoint point2 = CGPointPlusPoint(self.displacement, point1);
    
    return CGPointMultiplyFloat(point2, exp(-self.spring.beta * time));
}

@end

@interface HiSpringTiming ()
@property (nonatomic, strong) HiCriticallyDampedSpringTimingParameters *critically;
@property (nonatomic, strong) HiUnderdampedSpringTimingParameters *underdamped;

@property (nonatomic, strong, readonly) HiSpringTimingBase *impl;

@end

@implementation HiSpringTiming

- (id<HiTimingParameters>)impl {
    if (1 == self.spring.dampingRatio) return self.critically;
    if (self.spring.dampingRatio > 0 && self.spring.dampingRatio < 1) return self.underdamped;
    return nil;
}

- (HiCriticallyDampedSpringTimingParameters *)critically {
    if (!_critically) {
        _critically = [[HiCriticallyDampedSpringTimingParameters alloc] init];
    }
    return _critically;
}

- (HiUnderdampedSpringTimingParameters *)underdamped {
    if (!_underdamped) {
        _underdamped = [[HiUnderdampedSpringTimingParameters alloc] init];
    }
    return _underdamped;
}

- (NSTimeInterval)duration {
    return self.impl.duration;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    return [self.impl valueAtTime:time];
}

- (void)updateWithDisplacement:(CGPoint)displacement initialVelocity:(CGPoint)initialVelocity threshold:(CGFloat)threshold {
    
    self.initialVelocity = initialVelocity;
    self.threshold = threshold;
    
    self.impl.initialVelocity = initialVelocity;
    self.impl.threshold = threshold;
    self.impl.displacement = displacement;
}


@end
