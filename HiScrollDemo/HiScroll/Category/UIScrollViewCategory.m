//
//  UIScrollViewCategory.m
//  HiScrollDemo
//
//  Created by four on 2021/1/25.
//

#import "UIScrollViewCategory.h"
#import "HiObjectRunTime.h"
#import "HiScrollViewProperty.h"

@implementation UIScrollView (HiScrollHandle)

/// MARK: - bounce
- (void)_bounceAnimationWithTime:(NSTimeInterval)time {
    self.contentOffset = CGPointPlusPointMake(self.bounceOffset, [self.spring valueAtTime:time]);
}

/// MARK: - 减速
- (void)_decelerationAnimationWithProgress:(CGFloat)progess time:(NSTimeInterval)time {
    self.contentOffset = [self.decelerationParameters valueAtTime:time];
}

- (void)_decelerationAnimationCompleted:(BOOL)finished {
    if (finished && !self.intersectionNull) {
        // 碰撞的瞬间，计算出瞬时速度，作为调用 bounce 函数的参数.
        CGPoint velocity = [self.decelerationParameters velocityAtTime:self.decelerationDuration];
        [self bounceWithVelocity:velocity];
    }
}

/// MARK: - methods
- (void)bounceWithVelocity:(CGPoint)velocity {
    // 计算弹性动画的终止位置
    CGPoint contentOffset = CGPointInEdgeInsetsMake(self.contentOffset,self.boundsEdgeInsets);
    self.bounceOffset = contentOffset;
    
    // 计算初始的弹性动画的偏移量
    CGPoint displacement = CGPointMinusPointMake(self.contentOffset, contentOffset);
    [self.spring updateDisplacement:displacement initialVelocity:velocity];
    [self.bounceAnimation startAnimationsWithDuration:self.spring.duration];
}

// 计算偏移量
- (CGPoint)clampOffset:(CGPoint)offset {
    [self.rubberBand updateDims:self.bounds.size edgeInsets:self.boundsEdgeInsets];
    return [self.rubberBand clampPoint:offset];
}

- (void)completeGestureWithVelocity:(CGPoint)velocity {
    
    if (UIEdgeInsetsContainsCGPoint(self.contentOffset, self.boundsEdgeInsets)) {
        [self startDecelerationWithVelocity:velocity];

    } else {
        [self bounceWithVelocity:velocity];
    }
}

- (void)startDecelerationWithVelocity:(CGPoint)velocity {
    
    [self.decelerationParameters updateInitialValue:self.contentOffset initialVelocity:velocity decelerationRate:UIScrollViewDecelerationRateNormal threshold:0.5];
    // 找到滚动停止时的位置
    CGPoint destination = self.decelerationParameters.destination;
    
    // 找到与内容边界的碰撞点位置
    HiPoint intersection = HiPointIntersection(self.boundsEdgeInsets, self.contentOffset, destination);
    self.intersectionNull = intersection.null;

    // 如果发现会越界，那么找到越界之前的动画时间, 默认之前的
    NSTimeInterval duration = 0;
    if (intersection.null) {
        duration = self.decelerationParameters.duration;

    } else {
        duration = [self.decelerationParameters durationToValue:intersection.point];
    }
    
    self.decelerationDuration = duration;
    [self.decelerationAnimation startAnimationsWithDuration:duration];
}

- (void)hi_handlePanRecognizer:(UIPanGestureRecognizer *)pan {
    NSDate *newPan = [NSDate date];

    if (!self.lastPan) self.lastPan = newPan;

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.initialOffset = self.contentOffset;
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            // top, left < 0
            CGPoint translation = [pan translationInView:self];
            CGPoint offset = CGPointMinusPointMake(self.initialOffset, translation);// 偏移量
            self.contentOffset = [self clampOffset:offset];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            BOOL userHadStoppedDragging = [newPan timeIntervalSinceDate:self.lastPan] >= 0.15;
            CGPoint velocity = userHadStoppedDragging ? CGPointZero : [pan velocityInView:self];
            [self completeGestureWithVelocity:CGPointMake(-velocity.x, -velocity.y)];
        }
            break;
        default:
            
            break;
    }

    self.lastPan = newPan;
}

- (void)hi_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.decelerationAnimation invalidate];
    [self.bounceAnimation invalidate];
}

@end
