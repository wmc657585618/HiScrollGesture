//
//  CGScroll.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

/// point 相减
UIKIT_STATIC_INLINE CGPoint CGPointMinusPointMake(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x - p2.x, p1.y - p2.y);
}

/// point 相加
UIKIT_STATIC_INLINE CGPoint CGPointPlusPointMake(CGPoint p1, CGPoint p2) {
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

/// point 乘以 float
UIKIT_STATIC_INLINE CGPoint CGPointMultiplyFloatMake(CGPoint p, CGFloat f) {
    return CGPointMake(p.x * f, p.y * f);
}

/// point 乘以 point
UIKIT_STATIC_INLINE CGPoint CGPointMultiplyPointMake(CGPoint p, CGPoint p2) {
    return CGPointMake(p.x * p2.x, p.y * p2.y);
}

/// 获取 point 在 edge 中的有效值
UIKIT_STATIC_INLINE CGPoint CGPointInEdgeInsetsMake(CGPoint point, UIEdgeInsets edgeInsets) {
    CGPoint _point = point;
    
    if (point.x < edgeInsets.left) {
        _point.x = edgeInsets.left;
        
    } else if(point.x > edgeInsets.right) {
        _point.x = edgeInsets.right;
    }
    
    if (point.y < edgeInsets.top) {
        _point.y = edgeInsets.top;
        
    } else if (point.y > edgeInsets.bottom) {
        _point.y = edgeInsets.bottom;
    }
    
    return _point;
}

/// point 除 float
UIKIT_STATIC_INLINE CGPoint CGPointDivideFloatMake(CGPoint p, CGFloat f) {
    return CGPointMake(p.x / f, p.y / f);
}

/// 获取 point 长度
UIKIT_STATIC_INLINE CGFloat CGPointLenghtMake(CGPoint p) {
    return sqrt(p.x * p.x + p.y * p.y);
}

/// 减速相关
struct HiPoint {
    CGPoint point;
    BOOL null;
};
typedef struct HiPoint HiPoint;

/// 求 和边界的交点
UIKIT_STATIC_INLINE HiPoint _HiPointIntersection(CGPoint p1, CGPoint p2, CGPoint contentOffset, CGPoint destination) {
    HiPoint point;
    point.null = true;
    
    CGFloat d = (p2.x - p1.x) * (destination.y - contentOffset.y) - (p2.y - p1.y) * (destination.x - contentOffset.x);
    
    if (0 == d)return point; // 平行
    
    CGFloat u = ((contentOffset.x - p1.x) * (destination.y - contentOffset.y) - (contentOffset.y - p1.y) * (destination.x - contentOffset.x)) / d;
    CGFloat v = ((contentOffset.x - p1.x) * (p2.y - p1.y) - (contentOffset.y - p1.y) * (p2.x - p1.x)) / d;
    
    if (u < 0.0 || u > 1.0) return point; // intersection point is not between p1 and p2
    
    if (v < 0.0 || v > 1.0) return point; // intersection point is not between p3 and p4
    
    point.null = false;
    point.point = CGPointMake(p1.x + u * (p2.x - p1.x), p1.y + u * (p2.y - p1.y));
    return point;
}

/// 与内容边界的碰撞点位置
UIKIT_STATIC_INLINE HiPoint HiPointIntersection(UIEdgeInsets edgeInsets, CGPoint contentOffset, CGPoint destination) {
    HiPoint point;
    
    // 左上
    CGPoint point1 = CGPointMake(edgeInsets.left, edgeInsets.top);
    
    // 左下
    CGPoint point2 = CGPointMake(edgeInsets.left, edgeInsets.bottom);
    
    // 右上
    CGPoint point3 = CGPointMake(edgeInsets.right, edgeInsets.top);
    
    // 右下
    CGPoint point4 = CGPointMake(edgeInsets.right, edgeInsets.bottom);
    
    point = _HiPointIntersection(point1, point2, contentOffset, destination);
    if (!point.null) return point;
    
    point = _HiPointIntersection(point3, point4, contentOffset, destination);
    if (!point.null) return point;
    
    point = _HiPointIntersection(point1, point3, contentOffset, destination);
    if (!point.null) return point;
    
    point = _HiPointIntersection(point2, point4, contentOffset, destination);
    if (!point.null) return point;
    
    point.null = true;
    return point;
}

UIKIT_STATIC_INLINE CGFloat CGPointDistance(CGPoint p,CGPoint v, CGPoint w) {
    
    CGFloat pv_dx = p.x - v.x;
    CGFloat pv_dy = p.y - v.y;
    CGFloat wv_dx = w.x - v.x;
    CGFloat wv_dy = w.y - v.y;

    CGFloat dot = pv_dx * wv_dx + pv_dy * wv_dy;
    CGFloat len_sq = wv_dx * wv_dx + wv_dy * wv_dy;
    CGFloat param = dot / len_sq;

    CGFloat int_x, int_y; /* intersection of normal to vw that goes through p */

    if ( param < 0 || (v.x == w.x && v.y == w.y)) {
        int_x = v.x;
        int_y = v.y;
    } else if (param > 1) {
        int_x = w.x;
        int_y = w.y;
    } else {
        int_x = v.x + param * wv_dx;
        int_y = v.y + param * wv_dy;
    }

    /* Components of normal */
    CGFloat dx = p.x - int_x;
    CGFloat dy = p.y - int_y;

    return sqrt(dx * dx + dy * dy);
}

/// point 是否在 edge 中
UIKIT_STATIC_INLINE BOOL UIEdgeInsetsContainsCGPoint(CGPoint p, UIEdgeInsets edgeInsets) {
    if (p.x <= edgeInsets.right && p.x >= edgeInsets.left && p.y <= edgeInsets.bottom && p.y >= edgeInsets.top) return true;
    return false;
}
