//
//  ScrollDemo.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "ScrollDemo.h"
#import "CGScroll.h"
#import "Deceleration.h"
#import "ScrollAnimation.h"
#import "DecelerationParameters.h"
#import "Spring.h"
#import "RubberBand.h"

@interface ScrollDemo ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign, readonly) UIEdgeInsets boundsEdge;
@property (nonatomic, strong) NSDate *lastPan;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, assign) CGPoint initialOffset; // pan 开始时的 contentoffset

@property (nonatomic, strong) Deceleration *deceleration;
@property (nonatomic, strong) ScrollAnimation *decelerationAnimation;
@property (nonatomic, strong) ScrollAnimation *bounceAnimation;

@property (nonatomic, strong) DecelerationParameters *decelerationParameters;
@property (nonatomic, assign) BOOL intersectionNull;
@property (nonatomic, assign) NSTimeInterval decelerationDuration;
@property (nonatomic, assign) CGPoint bounceOffset;
@property (nonatomic, strong) ScrollSpring *spring;

@property (nonatomic, strong) RubberBand *rubberBand;

@end

@implementation ScrollDemo

- (Deceleration *)deceleration {
    if (!_deceleration) _deceleration = [[Deceleration alloc] init];
    return _deceleration;
}

- (ScrollAnimation *)decelerationAnimation {
    if (!_decelerationAnimation) {
        __weak typeof(self) weak = self;
        _decelerationAnimation = [[ScrollAnimation alloc] initWithAinmations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            [strong _decelerationAnimationWithProgress:progress time:time];
        } completion:^(BOOL finished) {
            __strong typeof(weak) strong = weak;
            [strong _decelerationAnimationCompleted:finished];
        }];
    }
    return _decelerationAnimation;
}

- (ScrollAnimation *)bounceAnimation {
    if (!_bounceAnimation) {
        __weak typeof(self) weak = self;
        _bounceAnimation = [[ScrollAnimation alloc] initWithAinmations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            [strong _bounceAnimationWithTime:time];
        }];
    }
    return _bounceAnimation;
}

- (ScrollSpring *)spring {
    if (!_spring) _spring = [[ScrollSpring alloc] init];
    return _spring;
}

- (DecelerationParameters *)decelerationParameters {
    if (!_decelerationParameters) _decelerationParameters = [[DecelerationParameters alloc] init];
    return _decelerationParameters;
}

- (RubberBand *)rubberBand {
    if (!_rubberBand) _rubberBand = [[RubberBand alloc] init];
    return _rubberBand;
}

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

- (UIEdgeInsets)boundsEdge {
    return UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom + self.contentSize.height - self.bounds.size.height, self.contentInset.right + self.contentSize.width - self.bounds.size.width);
}

- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
        _panRecognizer.delegate = self;
    }
    return _panRecognizer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addGestureRecognizer:self.panRecognizer];
    }
    return self;
}

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)pan {
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

- (CGPoint)clampOffset:(CGPoint)offset {
    [self.rubberBand updateDims:self.bounds.size edgeInsets:self.boundsEdge];
    return [self.rubberBand clampPoint:offset];
}

- (void)completeGestureWithVelocity:(CGPoint)velocity {
    
    if (UIEdgeInsetsContainsCGPoint(self.contentOffset, self.boundsEdge)) {
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
    HiPoint intersection = HiPointIntersection(self.boundsEdge, self.contentOffset, destination);
    self.intersectionNull = intersection.null;

    // 如果发现会越界，那么找到越界之前的动画时间, 默认之前的
    NSTimeInterval duration = self.decelerationParameters.duration;
    if (!intersection.null) {
        duration = [self.decelerationParameters durationToValue:intersection.point];
    }
    self.decelerationDuration = duration;
    [self.decelerationAnimation startAnimationsWithDuration:duration];
}

- (void)bounceWithVelocity:(CGPoint)velocity {
    // 计算弹性动画的终止位置
    CGPoint contentOffset = CGPointInEdgeInsetsMake(self.contentOffset,self.boundsEdge);
    self.bounceOffset = contentOffset;
    
    // 计算初始的弹性动画的偏移量
    CGPoint displacement = CGPointMinusPointMake(self.contentOffset, contentOffset);
    [self.spring updateDisplacement:displacement initialVelocity:velocity];
    [self.bounceAnimation startAnimationsWithDuration:self.spring.duration];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self.decelerationAnimation invalidate];
    [self.bounceAnimation invalidate];
    return true;
}

@end
