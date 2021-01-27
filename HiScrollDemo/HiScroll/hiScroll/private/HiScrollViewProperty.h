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

extern HiScrollNode * hi_nodesSort(HiScrollNode *head, BOOL revert, HiScrollViewProperty direction);

@interface UIScrollView (HiScrollViewProperty)<HiScrollGestureDelegate>

@property (nonatomic, strong, readonly) HiScrollWeak *actionScrollViewWeak;
@property (nonatomic, strong, readonly) HiScrollGesture *scrollGesture;

@property (nonatomic, weak) UIScrollView *actionScrollView; // 本次处理滚动的 scrollview

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

/// 橡皮筋
@property (nonatomic, strong, readonly) RubberBand *rubberBand;

@property (nonatomic, assign) BOOL intersectionNull;
@property (nonatomic, assign) NSTimeInterval decelerationDuration;
@property (nonatomic, assign) CGPoint bounceOffset;

/// 减速
@property (nonatomic, strong, readonly) ScrollAnimation *decelerationAnimation;

/// 弹簧
@property (nonatomic, strong, readonly) ScrollAnimation *bounceAnimation;

@end

NS_ASSUME_NONNULL_END
