//
//  HiScrollObject.h
//  ScrollTest
//
//  Created by four on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HiScrollObject.h"

NS_ASSUME_NONNULL_BEGIN
@protocol HiScrollGestureDelegate <NSObject>
@optional
- (BOOL)gesture:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)tapGestureRecognizerAction:(UITapGestureRecognizer *)gestureRecognizer;

@end

@interface HiScrollWeak : NSObject

@property (nonatomic, weak) id objc;

@end

@interface HiScrollGesture : NSObject<UIGestureRecognizerDelegate>

- (BOOL)addGestureAtView:(UIView *)view;

@property (nonatomic, weak) id<HiScrollGestureDelegate> delegate;

@end

@interface HiScrollNode : NSObject

@property (nonatomic, strong) HiScrollNode * __nullable lastNode;
@property (nonatomic, strong) HiScrollNode * __nullable nextNode;
@property (nonatomic, weak) UIScrollView *object;

@end

NS_ASSUME_NONNULL_END
