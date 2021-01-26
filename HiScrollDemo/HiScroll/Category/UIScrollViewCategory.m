//
//  UIScrollViewCategory.m
//  HiScrollDemo
//
//  Created by four on 2021/1/25.
//

#import "UIScrollViewCategory.h"

@implementation UIScrollView (HiScrollProperty)

- (UIEdgeInsets)boundsEdgeInsets {
    CGFloat maxBottom = self.contentInset.bottom + self.contentSize.height;
    CGFloat bottom = maxBottom > self.bounds.size.height ? maxBottom : self.bounds.size.height;
    CGFloat maxRight = self.contentInset.right + self.contentSize.width;
    CGFloat right = maxRight > self.bounds.size.width ? maxRight : self.bounds.size.width;
    return UIEdgeInsetsMake(self.contentInset.top, self.contentInset.left, bottom, right);
}

@end
