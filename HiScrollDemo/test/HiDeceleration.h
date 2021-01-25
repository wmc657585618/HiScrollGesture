//
//  HiDeceleration.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HiDeceleration : NSObject

- (void)updatInitialValue:(CGPoint)initialValue initialVelocity:(CGPoint)initialVelocity decelerationRate:(CGFloat)decelerationRate threshold:(CGFloat)threshold;

@property (nonatomic, assign, readonly) CGPoint destination;
@property (nonatomic, assign, readonly) NSTimeInterval duration;

- (CGPoint)valueAtTime:(NSTimeInterval)time;
- (NSTimeInterval)durationToValue:(CGPoint)value;
- (CGPoint)velocityAtTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
