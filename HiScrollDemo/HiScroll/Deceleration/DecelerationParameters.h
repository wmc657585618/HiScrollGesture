//
//  DecelerationParameters.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DecelerationParameters : NSObject

@property (nonatomic, assign, readonly) CGPoint destination;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

- (CGPoint)valueAtTime:(NSTimeInterval)time;
- (NSTimeInterval)durationToValue:(CGPoint)value;
- (CGPoint)velocityAtTime:(NSTimeInterval)time;

- (void)updateInitialValue:(CGPoint)initialValue initialVelocity:(CGPoint)initialVelocity decelerationRate:(CGFloat)decelerationRate threshold:(CGFloat)threshold;

@end

NS_ASSUME_NONNULL_END
