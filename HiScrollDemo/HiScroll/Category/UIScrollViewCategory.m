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
        
        // 找到可以处理的 scroll, 调用 - completeGestureWithVelocity:
        [self bounceWithVelocity:velocity];
    }
}

- (UIScrollView *)findDecelerationActionScrollView {
    
    UIScrollView *scrollView = self.scrollView;
    if (!scrollView) scrollView = self; // 容器本身
    
    HiScrollNode *node = scrollView.scrollNode;
    while (node && node.object != self) {
        node = node.nextNode;
    }
    
    return node.object;
}

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
    return hi_clampPointInEdgeInsets(offset, self.boundsEdgeInsets, self.bounds.size);
}

- (void )findScrollActionScrollView:(CGPoint)offset {
    UIScrollView *scrollView = self.scrollView;
    if (!scrollView) scrollView = self; // 容器本身
    HiScrollNode *node = scrollView.scrollNode;
    CGPoint p = CGPointPlusPointMake(scrollView.contentOffset, offset);

    while (!UIEdgeInsetsContainsCGPoint(p, scrollView.boundsEdgeInsets)) {
        node = node.nextNode;
        scrollView = node.object;
        p = CGPointPlusPointMake(scrollView.contentOffset, offset);
    }
}

- (void)completeGestureWithVelocity:(CGPoint)velocity {
    
    // 抬手时 在 boundsEdgeInsets 内.
    if (UIEdgeInsetsContainsCGPoint(self.contentOffset, self.boundsEdgeInsets)) {
        [self startDecelerationWithVelocity:velocity];

    } else {
        
        HiPoint intersection = [self findIntersectionWithVelocity:velocity];
        if (!intersection.null) {
            [self startDecelerationWithIntersection:intersection];

        } else {
            [self bounceWithVelocity:velocity];
        }

    }
}

- (void)modifyBounce {
    if (!UIEdgeInsetsContainsCGPoint(self.contentOffset, self.boundsEdgeInsets)) [self bounceWithVelocity:CGPointZero];
}

/// MARK:- 找到与内容边界的碰撞点位置
- (HiPoint)findIntersectionWithVelocity:(CGPoint)velocity {
    [self.decelerationParameters updateInitialValue:self.contentOffset initialVelocity:velocity decelerationRate:UIScrollViewDecelerationRateNormal threshold:0.5];
    // 找到滚动停止时的位置
    CGPoint destination = self.decelerationParameters.destination;
        
    // 找到与内容边界的碰撞点位置
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            return HiPointIntersectionInVertical(self.boundsEdgeInsets, self.contentOffset, destination,HiPanTop == self.panDirection);
            
        case HiScrollViewDirectionHorizontal:
            return HiPointIntersectionInHorizontal(self.boundsEdgeInsets, self.contentOffset, destination, HiPanLeft == self.panDirection);
    }
}

- (void)startDecelerationWithIntersection:(HiPoint)intersection {
    self.intersectionNull = intersection.null;

    // 如果发现会越界，那么找到越界之前的动画时间, 默认之前的
    NSTimeInterval duration = 0;
    if (intersection.null) { // 没有越界
        duration = self.decelerationParameters.duration;

    } else {
        duration = [self.decelerationParameters durationToValue:intersection.point];
    }
    
    self.decelerationDuration = duration;
    [self.decelerationAnimation startAnimationsWithDuration:duration];
}

- (void)startDecelerationWithVelocity:(CGPoint)velocity {
    // 找到与内容边界的碰撞点位置
    HiPoint intersection = [self findIntersectionWithVelocity:velocity];
    [self startDecelerationWithIntersection:intersection];
}

- (CGPoint)pointInDirection:(CGPoint)point {
    if (HiScrollViewDirectionVertical == self.scrollDirection) return CGPointMake(0, point.y);
    return  CGPointMake(point.x, 0);
}

- (void)hi_handlePanRecognizer:(UIPanGestureRecognizer *)pan {
    NSDate *newPan = [NSDate date];

    if (!self.lastPan) self.lastPan = newPan;

    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.initialOffset = self.contentOffset;
            [self changeDraggin];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            // top, left < 0
            CGPoint translation = [pan translationInView:self];
            CGPoint offset = CGPointMinusPointMake(self.initialOffset, translation);// 偏移量
            
            self.contentOffset = [self clampOffset:[self pointInDirection:offset]];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            BOOL userHadStoppedDragging = [newPan timeIntervalSinceDate:self.lastPan] >= 0.15;
            CGPoint velocity = userHadStoppedDragging ? CGPointZero : [pan velocityInView:self];
            if (HiScrollViewDirectionVertical == self.scrollDirection) {
                self.panDirection = velocity.y < 0 ? HiPanTop : HiPanBottom;
            } else {
                self.panDirection = velocity.x < 0 ? HiPanLeft : HiPanRight;
            }
            
            [self completeGestureWithVelocity:[self pointInDirection:CGPointMake(-velocity.x, -velocity.y)]];
            [self resetDraggin];
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

- (void)changeNode:(HiScrollNode *)scrollNode draggin:(BOOL)draggin{
    
    HiScrollNode *node = scrollNode;
    while (node) {
        node.object.hi_draggin = draggin;
        node = node.nextNode;
    }
}

- (HiScrollNode *)nodeInDirection:(HiScrollViewDirection)direction {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            return self.topNode;
        case HiScrollViewDirectionHorizontal:
            return self.leftNode;
    }
}

- (void)changeDraggin {
    [self changeNode:[self nodeInDirection:self.scrollDirection] draggin:true];
}

- (void)resetDraggin {
    [self changeNode:[self nodeInDirection:self.scrollDirection] draggin:false];
}

@end
