//
//  HiScrollViewProperty.m
//  ScrollTest
//
//  Created by four on 2021/1/15.
//

#import "HiScrollViewProperty.h"
#import "HiObjectRunTime.h"

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

- (HiScrollWeak *)actionScrollViewWeak {
    SEL key = @selector(actionScrollViewWeak);
    HiScrollWeak *value = [self getAssociatedObjectForKey:key];
    if (!value) {
        value = [[HiScrollWeak alloc] init];
        [self setRETAIN_NONATOMIC:value key:key];
    }
    return value;
}

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
    self.actionScrollViewWeak.objc = actionScrollView;
}

- (UIScrollView *)actionScrollView {
    return self.actionScrollViewWeak.objc;
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

@end
