//
//  HiScrollView.m
//  ScrollTest
//
//  Created by four on 2020/12/23.
//

#import "HiScrollView.h"
#import "HiObjectRunTime.h"
#import "UIScrollViewCategory.h"
#import "HiScrollViewProperty.h"

@implementation UIScrollView (HiScrollView)

- (void)changeNode:(HiScrollNode *)scrollNode draggin:(BOOL)draggin{
    
    HiScrollNode *node = scrollNode;
    while (node) {
        node.object.hi_draggin = draggin;
        node = node.nextNode;
    }
}

- (void)changeDraggin {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            [self changeNode:self.topNode draggin:true];
            break;
        case HiScrollViewDirectionHorizontal:
            [self changeNode:self.leftNode draggin:true];
            break;
    }
}

- (void)resetDraggin {
    switch (self.scrollDirection) {
        case HiScrollViewDirectionVertical:
            [self changeNode:self.topNode draggin:false];
            break;
        case HiScrollViewDirectionHorizontal:
            [self changeNode:self.leftNode draggin:false];
            break;
    }
}

/// 手势
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    [self hi_handlePanRecognizer:pan];
}

/// MARK: - HiScrollGestureDelegate
- (BOOL)gesture:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    [self hi_gestureRecognizerShouldBegin:gestureRecognizer];

    UIView *view = touch.view;
    HiScrollNode *node1 = [self generateNode];
    HiScrollNode *node2 = [self generateNode];

    while (![view isEqual:self]) {        
        if ([view isKindOfClass:UIScrollView.class]) {
            UIScrollView *scroll = (UIScrollView *)view;
            if (scroll.hi_scrollEnabled) { // 可以滚动
                HiScrollNode *_node1 = [scroll generateNode];
                HiScrollNode *_node2 = [scroll generateNode];

                _node1.nextNode = node1;
                _node2.nextNode = node2;
                node1 = _node1;
                node2 = _node2;
            }
        }
        
        view = [view superview];
    }
    
    if (HiScrollViewDirectionVertical == self.scrollDirection) {
        self.topNode = hi_nodesSort(node1,true,HiScrollViewPropertyTop);
        self.bottomNode = hi_nodesSort(node2, true, HiScrollViewPropertyBottom);

    } else if (HiScrollViewDirectionHorizontal == self.scrollDirection) {
        self.leftNode = hi_nodesSort(node1,true,HiScrollViewPropertyLeft);
        self.rightNode = hi_nodesSort(node2, true, HiScrollViewPropertyRight);
    }
    
    return true;
}

- (BOOL)_isDragging {
    if (self.hi_scrollEnabled) return self.hi_draggin;
    return [self _isDragging];
}

+ (void)load {
    SEL originalSelector = @selector(isDragging);
    SEL altSelector = @selector(_isDragging);
    [self hi_class_getInstanceMethod:originalSelector newSelector:altSelector];
}

/// MARK: - public
- (void)hi_scrollWithScrollDirection:(HiScrollViewDirection)direction {
    if (![self.scrollGesture addGestureAtView:self]) self.scrollDirection = direction;
}

@end
