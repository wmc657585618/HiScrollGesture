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

@interface UIScrollView (HiScrollProperty)

/// bottom: 如果 contentsize > height, 取 contentsize, 否则取 height
/// right: 如果 contentsize > right, 取 contentsize, 否则取 right
@property (nonatomic, assign,readonly) UIEdgeInsets boundsEdgeInsets;

@property (nonatomic, strong) NSDate *lastPan;

@property (nonatomic, assign) CGPoint initialOffset; // pan 开始时的 contentoffset

/// 减速
@property (nonatomic, strong, readonly) Deceleration *deceleration;
@property (nonatomic, strong, readonly) ScrollAnimation *decelerationAnimation;
@property (nonatomic, strong, readonly) DecelerationParameters *decelerationParameters;

/// 弹簧
@property (nonatomic, strong, readonly) ScrollSpring *spring;
@property (nonatomic, strong, readonly) ScrollAnimation *bounceAnimation;

/// 橡皮筋
@property (nonatomic, strong, readonly) RubberBand *rubberBand;

@property (nonatomic, assign) BOOL intersectionNull;
@property (nonatomic, assign) NSTimeInterval decelerationDuration;
@property (nonatomic, assign) CGPoint bounceOffset;

- (CGPoint)clampOffset:(CGPoint)offset;
- (void)completeGestureWithVelocity:(CGPoint)velocity;
- (void)bounceWithVelocity:(CGPoint)velocity;

@end

NS_ASSUME_NONNULL_END
