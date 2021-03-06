//
//  RubberBand.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
extern CGPoint hi_clampPointInEdgeInsets(CGPoint p, UIEdgeInsets e, CGSize d);
extern CGFloat hi_clampFloat(CGFloat f, CGFloat min, CGFloat max, CGFloat dism);

@interface RubberBand : NSObject

- (void)updateDims:(CGSize)dims edgeInsets:(UIEdgeInsets)edgeInsets;
- (CGPoint)clampPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
