//
//  HiScrollView.m
//  ScrollTest
//
//  Created by four on 2020/12/23.
//

#import "HiScrollView.h"
#import "UIScrollViewCategory.h"
#import "HiScrollViewProperty.h"

@implementation UIScrollView (HiScrollView)

/// 手势
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)pan {
    [self hi_handlePanRecognizer:pan];
}

/// 没有触发 pan 休正 content offset
- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer {
    [self modifyBounce];
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
                
                scroll.scrollView = self;
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

/// MARK: - public
- (void)hi_scrollWithScrollDirection:(HiScrollViewDirection)direction {
    if (![self.scrollGesture addGestureAtView:self]) self.scrollDirection = direction;
}

@end
