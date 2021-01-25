//
//  HiTimerAnimation.m
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import "HiTimerAnimation.h"

@interface HiTimerAnimation ()
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) Animations animations;
@property (nonatomic, copy) Completion completion;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval firstFrameTimestamp;
@property (nonatomic, assign) BOOL running;

@end

@implementation HiTimerAnimation

- (void)handleFrame:(CADisplayLink *)displayLink {
    
    if (self.running) {
        NSTimeInterval elapsed = CACurrentMediaTime() - self.firstFrameTimestamp;
        if (elapsed >= self.duration) {
            if (self.animations) self.animations(1, self.duration);
            self.running = false;
            if (self.completion) self.completion(true);
            [self.displayLink invalidate];
            
        }else {
            if (self.animations) self.animations(elapsed / self.duration, elapsed);
        }
    }
}

- (void)statrWithDuration:(NSTimeInterval)duration animations:(Animations)animations completion:(Completion)completion {
    
    [self invalidate];
    self.duration = duration;
    self.animations = animations;
    self.completion = completion;
    self.running = true;
    self.firstFrameTimestamp = CACurrentMediaTime();
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleFrame:)];
    [displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink = displayLink;
}


- (void)invalidate {
    if (!self.running) {
        self.running = false;
        if (self.completion) self.completion(false);
        [self.displayLink invalidate];
    }
}

- (void)dealloc
{
    [self invalidate];
}
@end
