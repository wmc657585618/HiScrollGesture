//
//  ScrollAnimation.h
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Animations)(CGFloat progress, NSTimeInterval time);
typedef void(^Completion)(BOOL finished);

@interface ScrollAnimation : NSObject

- (instancetype)initWithAinmations:(Animations)animations completion:(__nullable Completion)completion;
- (instancetype)initWithAinmations:(Animations)animations;

- (void)startAnimationsWithDuration:(NSTimeInterval)duration;

- (void)invalidate;
@end

NS_ASSUME_NONNULL_END
