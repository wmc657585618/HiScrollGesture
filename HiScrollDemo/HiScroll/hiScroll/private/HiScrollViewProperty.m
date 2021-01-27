//
//  HiScrollViewProperty.m
//  ScrollTest
//
//  Created by four on 2021/1/15.
//

#import "HiScrollViewProperty.h"
#import "HiObjectRunTime.h"
#import "UIScrollViewCategory.h"

// default 从小到大
inline HiScrollNode * hi_nodesSort(HiScrollNode *head, BOOL revert, HiScrollViewProperty direction)
{
    HiScrollNode * first = nil;     /*排列后有序链的表头指针*/
    HiScrollNode * tail = nil;      /*排列后有序链的表尾指针*/
    HiScrollNode * p_min = nil;     /*保留键值更小的节点的前驱节点的指针*/
    HiScrollNode * min = nil;       /*存储最小节点*/
    HiScrollNode * p = nil;         /*当前比较的节点*/
    
    while (head) {
        for (p = head,min = head; p.nextNode != nil; p = p.nextNode) {
            BOOL res = false;
            
            if (revert) {
                res = [p.nextNode.object hi_propertyForDirection:direction] > [min.object hi_propertyForDirection:direction];
            } else {
                res = [p.nextNode.object hi_propertyForDirection:direction] < [min.object hi_propertyForDirection:direction];
            }
            
            if (res) {
                p_min = p;
                min = p.nextNode;
            }
        }
        
        if (!first) {
            first = min;
            tail = min;
            
        } else {
            tail.nextNode = min;
            tail = min;
        }
        
        if ([min isEqual: head]) {
            head = head.nextNode;
            
        } else  {
            p_min.nextNode = min.nextNode;
        }
    }
    
    if (first) tail.nextNode = nil;
    head = first;
    return head;
}

@implementation UIScrollView (HiScrollViewProperty)

- (HiScrollGesture *)scrollGesture {
    
    SEL key = @selector(scrollGesture);
    HiScrollGesture *value = [self getAssociatedObjectForKey:key];
    if (!value) {
        value = [[HiScrollGesture alloc] init];
        value.delegate = self;
        [self setRETAIN_NONATOMIC:value key:key];
    }
    return value;
}

- (void)setActionScrollView:(UIScrollView *)actionScrollView {
    [self setWEAK:actionScrollView key:@selector(actionScrollView)];
}

- (UIScrollView *)actionScrollView {
    return [self getAssociatedObjectForKey:@selector(actionScrollView)];
}

- (void)setScrollView:(UIScrollView *)scrollView {
    [self setWEAK:scrollView key:@selector(scrollView)];
}

- (UIScrollView *)scrollView {
    return [self getAssociatedObjectForKey:@selector(scrollView)];
}

- (HiScrollNode *)nodeForKey:(SEL)key {
    return [self getAssociatedObjectForKey:key];
}

- (void)setNodeForKey:(SEL)key value:(HiScrollNode *)value{
    [self setRETAIN_NONATOMIC:value key:key];
}

- (HiScrollNode *)topNode {
    return [self nodeForKey:@selector(topNode)];
}

- (void)setTopNode:(HiScrollNode *)topNode {
    [self setNodeForKey:@selector(topNode) value:topNode];
}

- (HiScrollNode *)bottomNode {
    return [self nodeForKey:@selector(bottomNode)];
}

- (void)setBottomNode:(HiScrollNode *)bottomNode {
    [self setNodeForKey:@selector(bottomNode) value:bottomNode];
}

- (HiScrollNode *)leftNode {
    return [self nodeForKey:@selector(leftNode)];
}

- (void)setLeftNode:(HiScrollNode *)leftNode {
    [self setNodeForKey:@selector(leftNode) value:leftNode];
}

- (HiScrollNode *)rightNode {
    return [self nodeForKey:@selector(rightNode)];
}

- (void)setRightNode:(HiScrollNode *)rightNode {
    [self setNodeForKey:@selector(rightNode) value:rightNode];
}

- (void)setScrollDirection:(HiScrollViewDirection)scrollDirection {
    [self setRETAIN_NONATOMIC:@(scrollDirection) key:@selector(scrollDirection)];
}

- (HiScrollViewDirection)scrollDirection {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(scrollDirection)];
    return [value integerValue];
}

- (void)setHi_draggin:(BOOL)hi_draggin {
    [self setRETAIN_NONATOMIC:@(hi_draggin) key:@selector(hi_draggin)];
}

- (BOOL)hi_draggin {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(hi_draggin)];
    return [value boolValue];
}

- (UIEdgeInsets)boundsEdgeInsets {
    return UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, self.contentInset.bottom + self.contentSize.height - self.bounds.size.height, self.contentInset.right + self.contentSize.width - self.bounds.size.width);
}

- (void)setLastPan:(NSDate *)lastPan {
    [self setRETAIN_NONATOMIC:lastPan key:@selector(lastPan)];
}

- (NSDate *)lastPan {
    return [self getAssociatedObjectForKey:@selector(lastPan)];
}

- (void)setInitialOffset:(CGPoint)initialOffset {
    NSValue *value = [NSValue valueWithBytes:&initialOffset objCType:@encode(CGPoint)];
    [self setRETAIN_NONATOMIC:value key:@selector(initialOffset)];
}

- (CGPoint)initialOffset {
    NSValue *value = [self getAssociatedObjectForKey:@selector(initialOffset)];
    CGPoint p = CGPointZero;
    [value getValue:&p];
    return p;
}

- (Deceleration *)deceleration {
    Deceleration *_value = [self getAssociatedObjectForKey:@selector(deceleration)];
    if (!_value) {
        _value = [[Deceleration alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(deceleration)];
    }
    return _value;
}


- (DecelerationParameters *)decelerationParameters {
    DecelerationParameters *_value = [self getAssociatedObjectForKey:@selector(decelerationParameters)];
    if (!_value) {
        _value = [[DecelerationParameters alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(decelerationParameters)];
    }
    return _value;
}

- (ScrollSpring *)spring {
    ScrollSpring *_value = [self getAssociatedObjectForKey:@selector(spring)];
    if (!_value) {
        _value = [[ScrollSpring alloc] init];
        [self setRETAIN_NONATOMIC:_value key:@selector(spring)];
    }
    return _value;
}

- (void)setIntersectionNull:(BOOL)intersectionNull {
    [self setASSIGN:@(intersectionNull) key:@selector(intersectionNull)];
}

- (BOOL)intersectionNull {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(intersectionNull)];
    return value.boolValue;
}

- (void)setDecelerationDuration:(NSTimeInterval)decelerationDuration {
    [self setRETAIN_NONATOMIC:@(decelerationDuration) key:@selector(decelerationDuration)];
}

- (NSTimeInterval)decelerationDuration {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(decelerationDuration)];
    return value.doubleValue;
}

- (void)setBounceOffset:(CGPoint)bounceOffset {
    NSValue *value = [NSValue valueWithBytes:&bounceOffset objCType:@encode(CGPoint)];
    [self setRETAIN_NONATOMIC:value key:@selector(bounceOffset)];
}

- (CGPoint)bounceOffset {
    NSValue *value = [self getAssociatedObjectForKey:@selector(bounceOffset)];
    CGPoint p = CGPointZero;
    [value getValue:&p];
    return p;
}

- (ScrollAnimation *)decelerationAnimation {
    ScrollAnimation *_value = [self getAssociatedObjectForKey:@selector(decelerationAnimation)];
    if (!_value) {
        __weak typeof(self) weak = self;
        _value = [[ScrollAnimation alloc] initWithAinmations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            [strong _decelerationAnimationWithProgress:progress time:time];
        } completion:^(BOOL finished) {
            __strong typeof(weak) strong = weak;
            [strong _decelerationAnimationCompleted:finished];
        }];
        [self setRETAIN_NONATOMIC:_value key:@selector(decelerationAnimation)];
    }
    return _value;
}

- (ScrollAnimation *)bounceAnimation {
    ScrollAnimation *_value = [self getAssociatedObjectForKey:@selector(bounceAnimation)];
    if (!_value) {
        __weak typeof(self) weak = self;
        _value = [[ScrollAnimation alloc] initWithAinmations:^(CGFloat progress, NSTimeInterval time) {
            __strong typeof(weak) strong = weak;
            [strong _bounceAnimationWithTime:time];
        }];
        [self setRETAIN_NONATOMIC:_value key:@selector(bounceAnimation)];
    }
    return _value;
}

- (CGPoint)hi_contentOffset {
    return self.actionScrollView.contentOffset;
}

- (void)setPanDirection:(HiPanDirection)panDirection {
    [self setRETAIN_NONATOMIC:@(panDirection) key:@selector(panDirection)];
}

- (HiPanDirection)panDirection {
    NSNumber *value = [self getAssociatedObjectForKey:@selector(panDirection)];
    return value.integerValue;
}

- (HiScrollNode *)scrollNode {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
        {
            if (HiPanTop == self.panDirection) return self.topNode;
            return self.bottomNode;
        }
        case HiScrollViewDirectionHorizontal:
        {
            if (HiPanLeft == self.panDirection) return self.leftNode;
            return self.rightNode;
        }
    }
}

@end
