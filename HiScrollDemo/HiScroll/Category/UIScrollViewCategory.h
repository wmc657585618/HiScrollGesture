//
//  UIScrollViewCategory.h
//  HiScrollDemo
//
//  Created by four on 2021/1/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (HiScrollProperty)

/// bottom: 如果 contentsize > height, 取 contentsize, 否则取 height
/// right: 如果 contentsize > right, 取 contentsize, 否则取 right
//@property (nonatomic, assign,readonly) UIEdgeInsets boundsEdgeInsets;

@end

NS_ASSUME_NONNULL_END
