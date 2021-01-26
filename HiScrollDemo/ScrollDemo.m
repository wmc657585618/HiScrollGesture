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
#import "UIScrollViewCategory.h"

@interface ScrollDemo ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

@end

@implementation ScrollDemo

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
//
//- (CGPoint)clampOffset:(CGPoint)offset {
//    [self.rubberBand updateDims:self.bounds.size edgeInsets:self.boundsEdgeInsets];
//    return [self.rubberBand clampPoint:offset];
//}
//
//- (void)completeGestureWithVelocity:(CGPoint)velocity {
//    
//    if (UIEdgeInsetsContainsCGPoint(self.contentOffset, self.boundsEdgeInsets)) {
//        [self startDecelerationWithVelocity:velocity];
//
//    } else {
//        [self bounceWithVelocity:velocity];
//    }
//}
//
//- (void)startDecelerationWithVelocity:(CGPoint)velocity {
//    
//    [self.decelerationParameters updateInitialValue:self.contentOffset initialVelocity:velocity decelerationRate:UIScrollViewDecelerationRateNormal threshold:0.5];
//    // 找到滚动停止时的位置
//    CGPoint destination = self.decelerationParameters.destination;
//    
//    // 找到与内容边界的碰撞点位置
//    HiPoint intersection = HiPointIntersection(self.boundsEdgeInsets, self.contentOffset, destination);
//    self.intersectionNull = intersection.null;
//
//    // 如果发现会越界，那么找到越界之前的动画时间, 默认之前的
//    NSTimeInterval duration = self.decelerationParameters.duration;
//    if (!intersection.null) {
//        duration = [self.decelerationParameters durationToValue:intersection.point];
//    }
//    self.decelerationDuration = duration;
//    [self.decelerationAnimation startAnimationsWithDuration:duration];
//}
//
////- (void)bounceWithVelocity:(CGPoint)velocity {
////    // 计算弹性动画的终止位置
////    CGPoint contentOffset = CGPointInEdgeInsetsMake(self.contentOffset,self.boundsEdgeInsets);
////    self.bounceOffset = contentOffset;
////    
////    // 计算初始的弹性动画的偏移量
////    CGPoint displacement = CGPointMinusPointMake(self.contentOffset, contentOffset);
////    [self.spring updateDisplacement:displacement initialVelocity:velocity];
////    [self.bounceAnimation startAnimationsWithDuration:self.spring.duration];
////}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    [self.decelerationAnimation invalidate];
    [self.bounceAnimation invalidate];
    return true;
}

@end
