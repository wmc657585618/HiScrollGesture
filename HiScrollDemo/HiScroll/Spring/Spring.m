//
//  Spring.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "Spring.h"
#import "SpringParameters.h"

@interface ScrollSpring ()

@property (nonatomic, strong, readonly) ScrollSpringBase *implementation;
@property (nonatomic, strong) SpringUnder *under;
@property (nonatomic, strong) SpringCritically *critically;

@end

@implementation ScrollSpring

- (ScrollSpringBase *)implementation {
    if (1 == self.spring.dampingRatio) {
        return self.critically;
    } else if (self.spring.dampingRatio > 0 && self.spring.dampingRatio < 1) {
        return self.under;
    }
    
    return nil;
}

- (SpringUnder *)under {
    if (!_under) _under = [[SpringUnder alloc] init];
    return _under;
}

- (SpringCritically *)critically {
    if (!_critically) _critically = [[SpringCritically alloc] init];
    return _critically;
}

- (NSTimeInterval)duration {
    return self.implementation.duration;
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    return [self.implementation valueAtTime:time];
}

- (void)updateDisplacement:(CGPoint)displacement initialVelocity:(CGPoint)initialVelocity {
    self.implementation.displacement = displacement;
    self.implementation.initialVelocity = initialVelocity;
}

@end
