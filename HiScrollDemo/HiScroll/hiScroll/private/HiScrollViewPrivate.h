//
//  HiScrollViewPrivate.h
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import <UIKit/UIKit.h>
#import "HiScrollObject.h"
#import "HiScrollViewDefine.h"

typedef enum : NSUInteger {
    HiScrollViewPropertyTop,
    HiScrollViewPropertyBottom,
    HiScrollViewPropertyLeft,
    HiScrollViewPropertyRight,
} HiScrollViewProperty;

typedef struct __attribute__((objc_boxable)) HiOffsetValue {
    CGFloat value;
    BOOL bounce;
} HiOffsetValue;

UIKIT_STATIC_INLINE HiOffsetValue HiOffsetValueMake(CGFloat value, BOOL bounce) {
    HiOffsetValue offsetValue = {value, bounce};
    return offsetValue;
}

NS_ASSUME_NONNULL_BEGIN

extern CGFloat hi_rubberBandDistance(CGFloat offset, CGFloat dimension);

@interface UIScrollView (HiScrollViewPrivate)

- (NSInteger)hi_propertyForDirection:(HiScrollViewProperty)direction;

/// 更新 direction 上的值
- (void)updateContentOffset:(CGFloat)offset direction:(HiScrollViewDirection)direction;

- (HiScrollNode *)generateNode;

- (void)updatePanDirectionWithVelocity:(CGPoint)velocity;
- (void)updatePanDirectionWithOffset:(CGPoint)offset;

@end

NS_ASSUME_NONNULL_END
