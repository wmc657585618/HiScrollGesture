//
//  HiScrollHand.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef struct __attribute__((objc_boxable)) HiPoint {
    CGPoint point;
    BOOL available;
} HiPoint;

static inline CGFloat CGFloatclamped(CGFloat value, CGFloat min, CGFloat max) {
    return fmin(fmax(value, min), max);
}

/* + */
static inline CGPoint CGPointPlusPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

/* - */
static inline CGPoint CGPointMinusPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

/* * */
static inline CGPoint CGPointMultiplyPoint(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x * point2.x, point1.y * point2.y);
}

static inline CGPoint CGPointMultiplyFloat(CGPoint point, CGFloat f) {
    return CGPointMake(point.x * f, point.y * f);
}

/* / */
static inline CGPoint CGPointDivideFloat(CGPoint point1, CGFloat v) {
    if (0 == v) return point1;
    return CGPointMake(point1.x / v, point1.y / v);
}

/* 相反 */
static inline CGPoint CGPointContrary(CGPoint point) {
    return CGPointMake(-point.x, -point.y);
}

static inline CGFloat CGPointLength(CGPoint point) {
    return sqrtf(point.x * point.x + point.y * point.y);
}

static inline CGPoint CGPointClampedToRect(CGPoint point, UIEdgeInsets other) {
    CGFloat x = CGFloatclamped(point.x, other.left, other.right);
    CGFloat y = CGFloatclamped(point.y, other.top, other.bottom);
    return CGPointMake(x, y);
}

static inline CGFloat CGPointDistanceToPoint(CGPoint point1, CGPoint point2) {
    CGPoint point = CGPointMinusPoint(point1, point2);
    return CGPointLength(point);
}

static inline CGFloat CGPointDistanceToSegment(CGPoint point,CGPoint v, CGPoint w) {
    
    CGFloat pv_dx = point.x - v.x;
    CGFloat pv_dy = point.y - v.y;
    CGFloat wv_dx = w.x - v.x;
    CGFloat wv_dy = w.y - v.y;

    CGFloat dot= pv_dx * wv_dx + pv_dy * wv_dy;
    CGFloat len_sq = wv_dx * wv_dx + wv_dy * wv_dy;
    CGFloat param = dot / len_sq;

    CGFloat int_x, int_y; /* intersection of normal to vw that goes through p */

    if(param < 0 || (v.x == w.x && v.y == w.y)) {
        int_x = v.x;
        int_y = v.y;
    } else if(param > 1){
        int_x = w.x;
        int_y = w.y;
    } else {
        int_x = v.x + param * wv_dx;
        int_y = v.y + param * wv_dy;
    }

    /* Components of normal */
    CGFloat dx = point.x - int_x;
    CGFloat dy = point.y - int_y;

    return sqrt(dx * dx + dy * dy);
}

static inline BOOL UIEdgeInsetsContainsIncludingBorders(UIEdgeInsets insets, CGPoint point) {
    
    return !(point.x < insets.left || point.x > insets.right || point.y < insets.top || point.y > insets.bottom);
}

static HiPoint HiPointNull = {0,0,false};

static inline HiPoint HiPointMake(CGFloat x, CGFloat y, BOOL available) {
    HiPoint p = {x,y,available};
    return p;
}

static inline HiPoint _getIntersection(CGPoint p1, CGPoint p2, CGPoint p3, CGPoint p4) {
    CGFloat d = (p2.x - p1.x) * (p4.y - p3.y) - (p2.y - p1.y) * (p4.x - p3.x);
    
    if (0 == d) return HiPointNull;
    
    CGFloat u = ((p3.x - p1.x) * (p4.y - p3.y) - (p3.y - p1.y) * (p4.x - p3.x)) / d;
    CGFloat v = ((p3.x - p1.x) * (p2.y - p1.y) - (p3.y - p1.y) * (p2.x - p1.x)) / d;
    
    if (u < 0.0 || u > 1.0) return HiPointNull;

    if (v < 0.0 || v > 1.0) return HiPointNull;

    return HiPointMake(p1.x + u * (p2.x - p1.x), p1.y + u * (p2.y - p1.y), true);
}

static inline HiPoint getIntersection(UIEdgeInsets ddgeInsets, CGPoint segment1, CGPoint segment2) {
    CGPoint rMinMin = CGPointMake(ddgeInsets.left, ddgeInsets.top);
    CGPoint rMinMax = CGPointMake(ddgeInsets.left, ddgeInsets.bottom);
    CGPoint rMaxMin = CGPointMake(ddgeInsets.right, ddgeInsets.top);
    CGPoint rMaxMax = CGPointMake(ddgeInsets.right, ddgeInsets.bottom);
    
    HiPoint value = _getIntersection(rMinMin, rMinMax, segment1, segment2);
    if (value.available) return value;
    
    value = _getIntersection(rMinMin, rMaxMin, segment1, segment2);
    if (value.available) return value;
    
    value = _getIntersection(rMinMax, rMaxMax, segment1, segment2);
    if (value.available) return value;
    
    value = _getIntersection(rMaxMin, rMaxMax, segment1, segment2);
    if (value.available) return value;
    
    return HiPointNull;
}

static inline CGFloat CGFloatClampedLimits(CGFloat f, CGFloat min, CGFloat max) {
    return fmin(fmax(f, min), max);
}

