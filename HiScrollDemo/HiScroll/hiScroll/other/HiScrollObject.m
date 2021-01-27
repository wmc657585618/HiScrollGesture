//
//  HiScrollObject.m
//  ScrollTest
//
//  Created by four on 2020/12/29.
//

#import "HiScrollObject.h"

@implementation HiScrollWeak

@end

@interface HiScrollGesture ()

@property (nonatomic, assign) BOOL addGesture;

@end

@implementation HiScrollGesture

/// MARK: - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    if ([self.delegate respondsToSelector:@selector(gesture:shouldReceiveTouch:)]) {
        return [self.delegate gesture:gestureRecognizer shouldReceiveTouch:touch];
    }
    return true;
}

- (void)panAction:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([self.delegate respondsToSelector:@selector(panGestureRecognizerAction:)]) {
        [self.delegate panGestureRecognizerAction:gestureRecognizer];
    }
}

- (void)tapClicked:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(tapGestureRecognizerAction:)]) {
        [self.delegate tapGestureRecognizerAction:tap];
    }
}


/// MARK: - public
- (BOOL)addGestureAtView:(UIView *)view {
    if (self.addGesture) return true;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    pan.delegate = self;
    pan.delaysTouchesBegan = true;
    [view addGestureRecognizer:pan];
    self.addGesture = true;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [view addGestureRecognizer:tap];
    [tap requireGestureRecognizerToFail:pan];
    return false;
}

@end

@implementation HiScrollNode

@end
