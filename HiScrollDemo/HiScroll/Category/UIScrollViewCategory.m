//
//  UIScrollViewCategory.m
//  HiScrollDemo
//
//  Created by four on 2021/1/25.
//

#import "UIScrollViewCategory.h"
#import "HiObjectRunTime.h"

@implementation UIScrollView (HiScrollProperty)

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

/// MARK: - public
- (UIEdgeInsets)boundsEdgeInsets {
    return UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom + self.contentSize.height - self.bounds.size.height, self.contentInset.right + self.contentSize.width - self.bounds.size.width);
}

- (void)setLastPan:(NSDate *)lastPan {
    [self setRETAIN_NONATOMIC:lastPan key:@selector(lastPan)];
}

- (NSDate *)lastPan {
    return [self getAssociatedObjectForKey:@selector(lastPan)];
}

- (void)setInitialOffset:(CGPoint)initialOffset {
    NSValue *value = [NSValue valueWithBytes:&initialOffset objCType:@encode(CGPoint)];
    [self setRETAIN_NONATOMIC:value key:@selector(initialOffset)];
}

- (CGPoint)initialOffset {
    NSValue *value = [self getAssociatedObjectForKey:@selector(initialOffset)];
    CGPoint p = CGPointZero;
    [value getValue:&p];
    return p;
}

- (Deceleration *)deceleration {
    Deceleration *_value = [self getAssociatedObjectForKey:@selector(deceleration)];
    if (!_value) {
        _value = [[Deceleration alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(deceleration)];
    }
    return _value;
}

- (ScrollAnimation *)decelerationAnimation {
    ScrollAnimation *_value = [self getAssociatedObjectForKey:@selector(decelerationAnimation)];
    if (!_value) {
        __weak typeof(self) weak = self;
        _value = [[ScrollAnimation alloc] initWithAinmations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            [strong _decelerationAnimationWithProgress:progress time:time];
        } completion:^(BOOL finished) {
            __strong typeof(weak) strong = weak;
            [strong _decelerationAnimationCompleted:finished];
        }];
        [self setRETAIN_NONATOMIC:_value key:@selector(decelerationAnimation)];
    }
    return _value;
}

- (DecelerationParameters *)decelerationParameters {
    DecelerationParameters *_value = [self getAssociatedObjectForKey:@selector(decelerationParameters)];
    if (!_value) {
        _value = [[DecelerationParameters alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(decelerationParameters)];
    }
    return _value;
}

- (ScrollSpring *)spring {
    ScrollSpring *_value = [self getAssociatedObjectForKey:@selector(spring)];
    if (!_value) {
        _value = [[ScrollSpring alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(spring)];
    }
    return _value;
}

- (ScrollAnimation *)bounceAnimation {
    ScrollAnimation *_value = [self getAssociatedObjectForKey:@selector(bounceAnimation)];
    if (!_value) {
        __weak typeof(self) weak = self;
        _value = [[ScrollAnimation alloc] initWithAinmations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            [strong _bounceAnimationWithTime:time];
        }];
        [self setRETAIN_NONATOMIC:_value key:@selector(bounceAnimation)];
    }
    return _value;
}

- (RubberBand *)rubberBand {
    RubberBand *_value = [self getAssociatedObjectForKey:@selector(rubberBand)];
    if (!_value) {
        _value = [[RubberBand alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(rubberBand)];
    }
    return _value;
}

- (void)setIntersectionNull:(BOOL)intersectionNull {
    [self setASSIGN:@(intersectionNull) key:@selector(intersectionNull)];
}

- (BOOL)intersectionNull {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(intersectionNull)];
    return value.boolValue;
}

- (void)setDecelerationDuration:(NSTimeInterval)decelerationDuration {
    [self setRETAIN_NONATOMIC:@(decelerationDuration) key:@selector(decelerationDuration)];
}

- (NSTimeInterval)decelerationDuration {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(decelerationDuration)];
    return value.doubleValue;
}

- (void)setBounceOffset:(CGPoint)bounceOffset {
    NSValue *value = [NSValue valueWithBytes:&bounceOffset objCType:@encode(CGPoint)];
    [self setRETAIN_NONATOMIC:value key:@selector(bounceOffset)];
}

- (CGPoint)bounceOffset {
    NSValue *value = [self getAssociatedObjectForKey:@selector(bounceOffset)];
    CGPoint p = CGPointZero;
    [value getValue:&p];
    return p;
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
    NSTimeInterval duration = self.decelerationParameters.duration;
    if (!intersection.null) {
        duration = [self.decelerationParameters durationToValue:intersection.point];
    }
    self.decelerationDuration = duration;
    [self.decelerationAnimation startAnimationsWithDuration:duration];
}

@end
