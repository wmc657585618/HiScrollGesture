//
//  ScrollAnimation.m
//  HiScrollDemo
//
//  Created by four on 2021/1/21.
//

#import "ScrollAnimation.h"

@interface ScrollAnimationLink : NSObject

@property (nonatomic, copy) Animations animations;
@property (nonatomic, copy) Completion completion;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) CFTimeInterval firstFrameTimestamp;
@end

@implementation ScrollAnimationLink

- (void)_handleFrame:(CADisplayLink *)link {
    CGFloat elapsed = CACurrentMediaTime() - self.firstFrameTimestamp;
    if (elapsed >= self.duration) {
        if (self.animations) self.animations(1, self.duration);
        if (self.completion) self.completion(true);
        [link invalidate];
    } else {
        if (self.animations) {
            if (self.duration > 0) {
                self.animations(elapsed / self.duration, elapsed);
                
            } else {
                self.animations(1, self.duration);
                if (self.completion) self.completion(true);
                [link invalidate];
            }
        }
    }
}

@end
@interface ScrollAnimation ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, strong) ScrollAnimationLink *linkDelegate;

@end

@implementation ScrollAnimation

- (ScrollAnimationLink *)linkDelegate {
    if (!_linkDelegate) _linkDelegate = [[ScrollAnimationLink alloc] init];
    return _linkDelegate;
}

- (instancetype)initWithAinmations:(Animations)animations completion:(Completion)completion
{
    self = [super init];
    if (self) {
        self.linkDelegate.completion = completion;
        self.linkDelegate.animations = animations;
    }
    return self;
}

- (instancetype)initWithAinmations:(Animations)animations {
    return [self initWithAinmations:animations completion:nil];
}

- (void)startAnimationsWithDuration:(NSTimeInterval)duration {
    self.linkDelegate.duration = duration;
    self.linkDelegate.firstFrameTimestamp = CACurrentMediaTime();
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self.linkDelegate selector:@selector(_handleFrame:)];
    [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
}

- (void)invalidate {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)dealloc {
    [self.displayLink invalidate];
}

@end
