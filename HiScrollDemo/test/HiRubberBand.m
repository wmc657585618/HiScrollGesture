//
//  HiRubberBand.m
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import "HiRubberBand.h"
#import "HiScrollHand.h"

/*
 
 f(x, d, c) = (x * d * c) / (d + c * x)

 where,
 x – distance from the edge
 c – constant (UIScrollView uses 0.55)
 d – dimension, either width or height
 
 */

static inline CGFloat _rubberBandClamp(CGFloat x, CGFloat coeff, CGFloat dim) {
    CGFloat v1 = 1.0;
    CGFloat v2 = 0;
    if (0 != dim) v1 = x * coeff / dim + 1.0;
    if (0 != v1) v2 = 1.0 / v1;
    CGFloat v3 = 1.0 - v2;
    return v3 * dim;
}

static inline CGFloat rubberBandClamp(CGFloat x, CGFloat coeff, CGFloat dim, CGFloat min, CGFloat max) {
    
    CGFloat clampedX = CGFloatClampedLimits(x, min, max);
    CGFloat diff = fabs(x - clampedX);
    CGFloat sign = clampedX > x ? -1: 1;
    
    return clampedX + sign * _rubberBandClamp(diff, coeff, dim);
}

@implementation HiRubberBand

- (CGPoint)clamp:(CGPoint)point dims:(CGSize)dims edgeInsets:(UIEdgeInsets)edgeInsets {
    static CGFloat coeff = 0.55;
    CGFloat x = rubberBandClamp(point.x, coeff, dims.width, edgeInsets.left, edgeInsets.right);
    CGFloat y = rubberBandClamp(point.y, coeff, dims.height, edgeInsets.top, edgeInsets.bottom);
    return CGPointMake(x, y);
}

@end
