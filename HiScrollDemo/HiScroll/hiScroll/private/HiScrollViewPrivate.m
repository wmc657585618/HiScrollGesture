//
//  HiScrollViewPrivate.m
//  ScrollTest
//
//  Created by four on 2020/12/30.
//

#import "HiScrollViewPrivate.h"
#import "HiScrollViewPublic.h"
#import "HiScrollViewProperty.h"
#import "HiObjectRunTime.h"

@implementation UIScrollView (HiScrollViewPrivate)

- (NSInteger)hi_propertyForDirection:(HiScrollViewProperty)direction {
    
    switch (direction) {
        case HiScrollViewPropertyTop:
            return self.topProperty;
            
        case HiScrollViewPropertyBottom:
            return self.bottomProperty;

        case HiScrollViewPropertyLeft:
            return self.leftProperty;
            
        case HiScrollViewPropertyRight:
            return self.rightProperty;
    }
}

- (HiScrollNode *)generateNode {
    HiScrollNode *node = [[HiScrollNode alloc] init];
    node.object = self;
    return node;
}

- (void)updateContentOffset:(CGFloat)offset direction:(HiScrollViewDirection)direction{
    if (self.hi_scrollEnabled) {
        CGPoint point = self.contentOffset;
        switch (direction) {
            case HiScrollViewDirectionVertical:
                point.y = offset;
                break;
            case HiScrollViewDirectionHorizontal:
                point.x = offset;
                break;
        }
        self.contentOffset = point;
    }
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

@end
