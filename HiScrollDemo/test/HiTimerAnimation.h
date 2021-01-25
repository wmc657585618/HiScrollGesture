//
//  HiTimerAnimation.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Animations)(CGFloat progress, NSTimeInterval time);
typedef void(^Completion)(BOOL finished);

@interface HiTimerAnimation : NSObject

- (void)statrWithDuration:(NSTimeInterval)duration animations:(Animations)animations completion:(Completion __nullable)completion;

- (void)invalidate;

@end
NS_ASSUME_NONNULL_END
