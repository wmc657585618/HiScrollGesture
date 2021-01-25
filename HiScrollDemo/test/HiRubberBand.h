//
//  HiRubberBand.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HiRubberBand : NSObject

- (CGPoint)clamp:(CGPoint)point dims:(CGSize)dims edgeInsets:(UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
