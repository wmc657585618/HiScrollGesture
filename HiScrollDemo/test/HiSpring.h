//
//  HiSpring.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface HiSpring : NSObject
- (instancetype)initWithMass:(CGFloat)mass stiffness:(CGFloat)stiffness dampingRatio:(CGFloat)dampingRatio;

@property (nonatomic, assign) CGFloat mass;
@property (nonatomic, assign) CGFloat stiffness;
@property (nonatomic, assign) CGFloat dampingRatio;

@property (nonatomic, assign, readonly) CGFloat damping;
@property (nonatomic, assign, readonly) CGFloat beta;
@property (nonatomic, assign, readonly) CGFloat dampedNaturalFrequency;

@end


NS_ASSUME_NONNULL_END
