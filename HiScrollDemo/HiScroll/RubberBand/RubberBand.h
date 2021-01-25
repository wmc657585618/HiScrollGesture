//
//  RubberBand.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct Limits {
    CGFloat lowerBound;
    CGFloat upperBound;
};

typedef struct Limits Limits;

@interface RubberBand : NSObject

- (void)updateDims:(CGSize)dims edgeInsets:(UIEdgeInsets)edgeInsets;
- (CGPoint)clampPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
