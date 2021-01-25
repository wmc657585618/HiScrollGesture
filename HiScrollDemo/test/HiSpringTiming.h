//
//  HiSpringTiming.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HiTimingParameters <NSObject>

@property (nonatomic, assign, readonly) NSTimeInterval duration;

- (CGPoint)valueAtTime:(NSTimeInterval)time;

@end

@interface HiSpringTimingBase : NSObject<HiTimingParameters>

@end


@interface HiSpringTiming : HiSpringTimingBase

- (void)updateWithDisplacement:(CGPoint)displacement initialVelocity:(CGPoint)initialVelocity threshold:(CGFloat)threshold;

@end
NS_ASSUME_NONNULL_END
