//
//  RubberBand.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "RubberBand.h"
#import "CGScroll.h"

struct Limits {
    CGFloat lowerBound;
    CGFloat upperBound;
};

typedef struct Limits Limits;

// 在边界内 取原值 否则取边界
UIKIT_STATIC_INLINE CGFloat CGFloatClamped(CGFloat v, Limits limits) {
    return fmin(fmax(v, limits.lowerBound), limits.upperBound);
}

/// @param v 手指的位移量
/// @param coeff 某个比率
/// @param dims 滚动视图的尺寸
UIKIT_STATIC_INLINE CGFloat _rubberBandClamp(CGFloat v, CGFloat coeff, CGFloat dims) {
    return (1.0 - (1.0 / (v * coeff / dims + 1.0))) * dims;
}

UIKIT_STATIC_INLINE CGFloat rubberBandClamp(CGFloat v, CGFloat coeff, CGFloat dims, Limits limits) {
    CGFloat clamped = CGFloatClamped(v, limits);
    CGFloat diff = fabs(v - clamped); // 偏移量
    CGFloat sign = clamped > v ? -1 : 1; // clamped < 0, 超过 left or top
    return clamped + sign * _rubberBandClamp(diff, coeff, dims);
}

inline CGPoint hi_clampPoint(CGPoint p, UIEdgeInsets e, CGSize d) {
    
    static CGFloat coeff = 0.55;;
    Limits limitsX = {e.left, e.right};
    Limits limitsY = {e.top, e.bottom};
    CGFloat x = rubberBandClamp(p.x, coeff, d.width, limitsX);
    CGFloat y = rubberBandClamp(p.y, coeff, d.height, limitsY);
    return CGPointMake(x, y);
}

@interface RubberBand ()

@property (nonatomic, assign, readonly) CGFloat coeff;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGSize dims;

@end

@implementation RubberBand
- (CGFloat)coeff {
    return 0.55;
}

- (void)updateDims:(CGSize)dims edgeInsets:(UIEdgeInsets)edgeInsets {
    self.dims = dims;
    self.edgeInsets = edgeInsets;
}

- (CGPoint)clampPoint:(CGPoint)point {
    Limits limitsX = {self.edgeInsets.left, self.edgeInsets.right};
    Limits limitsY = {self.edgeInsets.top, self.edgeInsets.bottom};
    CGFloat x = rubberBandClamp(point.x, self.coeff, self.dims.width, limitsX);
    CGFloat y = rubberBandClamp(point.y, self.coeff, self.dims.height, limitsY);
    return CGPointMake(x, y);
}

@end
