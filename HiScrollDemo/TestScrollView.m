//
//  TestScrollView.m
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import "TestScrollView.h"
#import "HiScrollHand.h"
#import "HiDeceleration.h"
#import "HiTimerAnimation.h"
#import "HiSpringTiming.h"
#import "HiState.h"
#import "HiRubberBand.h"

@interface TestScrollView ()
@property (nonatomic, strong) HiState *state;
@property (nonatomic, strong) HiRubberBand *rubberBand;
@property (nonatomic, strong) HiDeceleration *deceleration;
@property (nonatomic, strong) HiTimerAnimation *contentOffsetAnimation;
@property (nonatomic, strong) HiSpringTiming *springParameters;

@property (nonatomic, assign, readonly) UIEdgeInsets boundsEdge;
@property (nonatomic, strong) NSDate *lastPan;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation TestScrollView

- (UIEdgeInsets)boundsEdge {
    return UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom + self.contentSize.height - self.bounds.size.height, self.contentInset.right + self.contentSize.width + self.bounds.size.width);
}

- (UIPanGestureRecognizer *)panRecognizer {
    if (!_panRecognizer) {
        _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
    }
    return _panRecognizer;
}

- (HiState *)state {
    if (!_state) {
        _state = [[HiState alloc] init];
    }
    return _state;
}

- (HiRubberBand *)rubberBand {
    if (!_rubberBand) {
        _rubberBand = [[HiRubberBand alloc] init];
    }
    return _rubberBand;
}

- (HiDeceleration *)deceleration {
    if (!_deceleration) {
        _deceleration = [[HiDeceleration alloc] init];
    }
    return _deceleration;
}

- (HiTimerAnimation *)contentOffsetAnimation {
    if (!_contentOffsetAnimation) {
        _contentOffsetAnimation = [[HiTimerAnimation alloc] init];
    }
    return _contentOffsetAnimation;
}

- (HiSpringTiming *)springParameters {
    if (!_springParameters) {
        _springParameters = [[HiSpringTiming alloc] init];
    }
    return _springParameters;
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
        {
            [self stopOffsetAnimation];
            self.state.state = StateDraggin;
            self.state.initialOffset = self.contentOffset;
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            if (StateDraggin == self.state.state) {
                CGPoint translation = [pan translationInView:self];
                self.contentOffset = [self clampOffset:CGPointMinusPoint(self.state.initialOffset, translation)];
                NSLog(@"==%@",NSStringFromCGPoint(self.contentOffset));
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            self.state.state = StateDefault;
            BOOL userHadStoppedDragging = [newPan timeIntervalSinceDate:self.lastPan] >= 0.1;
            CGPoint velocity = userHadStoppedDragging ? CGPointZero : [pan velocityInView:self];
            [self completeGestureWithVelocity:CGPointMake(-velocity.x, -velocity.y)];
        }
            break;
        default:
            self.state.state = StateDefault;
            break;
    }
    
    self.lastPan = newPan;
}

- (CGPoint)clampOffset:(CGPoint)offset {
    if (UIEdgeInsetsContainsIncludingBorders(self.boundsEdge, self.contentOffset)) return offset;
    return [self.rubberBand clamp:offset dims:self.bounds.size edgeInsets:self.boundsEdge];
}

- (void)completeGestureWithVelocity:(CGPoint)velocity {
    if (UIEdgeInsetsContainsIncludingBorders(self.boundsEdge, self.contentOffset)) {
        [self startDecelerationWithVelocity:velocity];
    }else {
        [self bounceWithVelocity:velocity];
    }
}

- (void)startDecelerationWithVelocity:(CGPoint)velocity {
    
    [self.deceleration updatInitialValue:self.contentOffset initialVelocity:velocity decelerationRate:UIScrollViewDecelerationRateNormal threshold:0.5];
    
    CGPoint destination = self.deceleration.destination;
    HiPoint intersection = getIntersection(self.boundsEdge, self.contentOffset, destination);
    
    NSTimeInterval duration = 0.0;
    NSTimeInterval intersectionDuration = [self.deceleration durationToValue:intersection.point];
    if (intersection.available &&  intersectionDuration> 0) {
        duration = intersectionDuration;
    } else {
        duration = self.deceleration.duration;
    }
    
    __weak typeof(self) weak = self;
    [self.contentOffsetAnimation statrWithDuration:duration animations:^(CGFloat progress, NSTimeInterval time) {
        __strong typeof(weak) strong = weak;
        strong.contentOffset = [strong.deceleration valueAtTime:time];
        
    } completion:^(BOOL finished) {
        __strong typeof(weak) strong = weak;

        if (finished && intersection.available) {
            CGPoint velocity = [strong.deceleration velocityAtTime:duration];
            [strong bounceWithVelocity:velocity];
        }
    }];
}

- (void)bounceWithVelocity:(CGPoint)velocity {
    
    CGPoint restOffset = CGPointClampedToRect(self.contentOffset, self.boundsEdge);
    CGPoint displacement = CGPointMinusPoint(self.contentOffset, restOffset);
    CGFloat threshold = 0.5 / UIScreen.mainScreen.scale;
    
    [self.springParameters updateWithDisplacement:displacement initialVelocity:velocity threshold:threshold];
    
    __weak typeof(self) weak = self;
    [self.contentOffsetAnimation statrWithDuration:self.springParameters.duration animations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            strong.contentOffset = CGPointPlusPoint(restOffset, [strong.springParameters valueAtTime:time]);
        
    } completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self stopOffsetAnimation];
}

- (void)stopOffsetAnimation {
    [self.contentOffsetAnimation invalidate];
}

@end
