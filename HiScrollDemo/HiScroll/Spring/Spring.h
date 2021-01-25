//
//  Spring.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "ScrollSpringBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScrollSpring : ScrollSpringBase

- (void)updateDisplacement:(CGPoint)displacement initialVelocity:(CGPoint)initialVelocity;
@end

NS_ASSUME_NONNULL_END
