//
//  UIScrollViewCategory.h
//  HiScrollDemo
//
//  Created by four on 2021/1/25.
//

#import <UIKit/UIKit.h>
#import "CGScroll.h"
#import "Deceleration.h"
#import "ScrollAnimation.h"
#import "DecelerationParameters.h"
#import "Spring.h"
#import "RubberBand.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollHandle)

/// MARK: - bounce
- (void)_bounceAnimationWithTime:(NSTimeInterval)time;

/// MARK: - 减速
- (void)_decelerationAnimationWithProgress:(CGFloat)progess time:(NSTimeInterval)time;

- (void)_decelerationAnimationCompleted:(BOOL)finished;

- (CGPoint)clampOffset:(CGPoint)offset;
- (void)completeGestureWithVelocity:(CGPoint)velocity;
- (void)bounceWithVelocity:(CGPoint)velocity;

- (void)hi_handlePanRecognizer:(UIPanGestureRecognizer *)pan;
- (void)hi_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;

/// 没有滑动时 休正 bounce
- (void)modifyBounce;

@end

NS_ASSUME_NONNULL_END
