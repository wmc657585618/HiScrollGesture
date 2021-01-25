//
//  SpringParameters.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "SpringParameters.h"
#import "CGScroll.h"

@implementation SpringUnder 

- (NSTimeInterval)duration {
    if (0 == CGPointLenghtMake(self.displacement) && 0 == CGPointLenghtMake(self.initialVelocity)) return 0;
    return log((CGPointLenghtMake([self c1]) + CGPointLenghtMake([self c2]) / self.threshold) / self.spring.beta);
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    CGFloat wd = self.spring.dampedNaturalFrequency;
    CGFloat f1 = exp(-self.spring.beta * time);
    CGPoint p1 = CGPointMultiplyFloatMake([self c1], cos(wd * time));
    CGPoint p2 = CGPointMultiplyFloatMake([self c2], sin(wd * time));
    CGPoint p3 = CGPointPlusPointMake(p1, p2);
    return CGPointMultiplyFloatMake(p3, f1);
}

- (CGPoint)c1 {
    return self.displacement;
}

- (CGPoint)c2 {
    CGPoint p1 = CGPointMake(self.displacement.x * self.spring.beta, self.displacement.y * self.spring.beta);
    CGPoint p2 = CGPointPlusPointMake(p1, self.initialVelocity);
    return CGPointDivideFloatMake(p2, self.spring.dampedNaturalFrequency);
}

@end

@implementation SpringCritically

- (NSTimeInterval)duration {
    if (0 == CGPointLenghtMake(self.displacement) && 0 == CGPointLenghtMake(self.initialVelocity)) return 0;
    
    CGFloat b = self.spring.beta;
    CGFloat e = M_E;
     
    CGFloat t1 = 1 / b * log(2 * CGPointLenghtMake([self c1]) / self.threshold);
    CGFloat t2 = 2 / b * log(4 * CGPointLenghtMake([self c2]) / (e * b * self.threshold));
    
    return fmax(t1, t2);
}

- (CGPoint)valueAtTime:(NSTimeInterval)time {
    CGFloat f1 = exp(-self.spring.beta * time);
    CGPoint p1 = CGPointMultiplyFloatMake([self c2], time);
    CGPoint p2 = CGPointPlusPointMake([self c1], p1);
    return CGPointMultiplyFloatMake(p2, f1);
}

- (CGPoint)c1 {
    return self.displacement;
}

- (CGPoint)c2 {
    CGPoint p1 = CGPointMake(self.displacement.x * self.spring.beta, self.displacement.y * self.spring.beta);
    return CGPointPlusPointMake(self.initialVelocity, p1);
}

@end
