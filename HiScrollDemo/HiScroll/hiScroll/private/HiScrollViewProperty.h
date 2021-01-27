//
//  HiScrollViewProperty.h
//  ScrollTest
//
//  Created by four on 2021/1/15.
//

#import <UIKit/UIKit.h>
#import "HiScrollObject.h"
#import "HiScrollViewDefine.h"
#import "HiScrollViewPublic.h"
#import "HiScrollViewPrivate.h"
#import "CGScroll.h"
#import "Deceleration.h"
#import "ScrollAnimation.h"
#import "DecelerationParameters.h"
#import "Spring.h"
#import "RubberBand.h"

NS_ASSUME_NONNULL_BEGIN

// 滚动方向
typedef enum : NSUInteger {
    HiPanTop,
    HiPanBottom,
    HiPanLeft,
    HiPanRight,
} HiPanDirection;


extern HiScrollNode * hi_nodesSort(HiScrollNode *head, BOOL revert, HiScrollViewProperty direction);

@interface UIScrollView (HiScrollViewProperty)<HiScrollGestureDelegate>

@property (nonatomic, strong, readonly) HiScrollGesture *scrollGesture;

@property (nonatomic, weak) UIScrollView *actionScrollView; // 本次处理滚动的 scrollview
@property (nonatomic, weak) UIScrollView *scrollView; // 容器 scrollView

@property (nonatomic, strong) HiScrollNode *topNode;
@property (nonatomic, strong) HiScrollNode *bottomNode;
@property (nonatomic, strong) HiScrollNode *leftNode;
@property (nonatomic, strong) HiScrollNode *rightNode;
@property (nonatomic, assign) HiScrollViewDirection scrollDirection;
@property (nonatomic, assign) BOOL hi_draggin;


/// bottom: 如果 contentsize > height, 取 contentsize, 否则取 height
/// right: 如果 contentsize > right, 取 contentsize, 否则取 right
@property (nonatomic, assign,readonly) UIEdgeInsets boundsEdgeInsets;

@property (nonatomic, strong) NSDate *lastPan;

@property (nonatomic, assign) CGPoint initialOffset; // pan 开始时的 contentoffset

/// 减速
@property (nonatomic, strong, readonly) Deceleration *deceleration;
@property (nonatomic, strong, readonly) DecelerationParameters *decelerationParameters;

/// 弹簧
@property (nonatomic, strong, readonly) ScrollSpring *spring;

@property (nonatomic, assign) BOOL intersectionNull;
@property (nonatomic, assign) NSTimeInterval decelerationDuration;
@property (nonatomic, assign) CGPoint bounceOffset;

/// 减速
@property (nonatomic, strong, readonly) ScrollAnimation *decelerationAnimation;

/// 弹簧
@property (nonatomic, strong, readonly) ScrollAnimation *bounceAnimation;

/// 当前 actionScroll 的 content offset
@property (nonatomic, assign, readonly) CGPoint hi_contentOffset;

@property (nonatomic, assign) HiPanDirection panDirection;

@property (nonatomic, strong, readonly) HiScrollNode *scrollNode; // 当前的 node

@end

NS_ASSUME_NONNULL_END
