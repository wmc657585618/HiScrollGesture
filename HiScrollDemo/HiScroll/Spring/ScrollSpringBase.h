//
//  ScrollSpringBase.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 弹性参数
struct Spring {
    /// 质量
    CGFloat mass;
    /// 刚度
    CGFloat stiffness;
    /// 阻尼比
    CGFloat dampingRatio;
    /// 阻尼
    CGFloat damping;
    CGFloat beta;
    CGFloat dampedNaturalFrequency;
};

typedef struct Spring Spring;

@interface ScrollSpringBase : NSObject

@property (nonatomic, assign, readonly) Spring spring;

/// 位移
@property (nonatomic, assign) CGPoint displacement;

/// 初始速度
@property (nonatomic, assign) CGPoint initialVelocity;

/// 求动画时间的变化量阈值
@property (nonatomic, assign, readonly) CGFloat threshold;

/// 得到越界之前的动画时间
- (NSTimeInterval)durationToValue:(CGPoint)value;

/// 得到越界瞬间的动画速度
- (CGPoint)valueAtTime:(NSTimeInterval)time;

@property (nonatomic, assign, readonly) NSTimeInterval duration;

@end

NS_ASSUME_NONNULL_END
