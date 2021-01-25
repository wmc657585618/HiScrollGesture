//
//  HiSpring.m
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import "HiSpring.h"
#import "HiScrollHand.h"

@implementation HiSpring

- (instancetype)initWithMass:(CGFloat)mass stiffness:(CGFloat)stiffness dampingRatio:(CGFloat)dampingRatio
{
    self = [super init];
    if (self) {
        self.mass = mass;
        self.stiffness = stiffness;
        self.dampingRatio = dampingRatio;
    }
    return self;
}

- (CGFloat)damping {
    return 2 * self.dampingRatio * sqrt(self.mass * self.stiffness);
}

- (CGFloat)beta {
    return self.damping / (2 * self.mass);
}

- (CGFloat)dampedNaturalFrequency {
    return sqrt(self.stiffness / self.mass) * sqrt(1 - self.dampingRatio * self.dampingRatio);
}

@end
