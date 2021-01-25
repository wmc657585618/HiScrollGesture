//
//  Deceleration.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Deceleration : NSObject

- (void)updateInitialValue:(CGPoint)initialValue initialVelocity:(CGPoint)initialVelocity;

/// 衰减滚动停止的点
- (CGPoint)destination;

/// 衰减动画时间
- (NSTimeInterval)duration;

- (CGPoint)valueAtTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
