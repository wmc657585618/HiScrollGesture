//
//  HiObjectRunTime.m
//  HiScrollDemo
//
//  Created by four on 2021/1/26.
//

#import "HiObjectRunTime.h"
#import <objc/runtime.h>

@interface HiObjectRunTimeWeak : NSObject

@property (nonatomic, weak) id weak;

@end

@implementation HiObjectRunTimeWeak

@end

@implementation NSObject (HiObjectRunTime)

- (id)getAssociatedObjectForKey:(const void * _Nonnull)key {
    id objc = objc_getAssociatedObject(self, key);
    if ([objc isKindOfClass:HiObjectRunTimeWeak.class] && [objc respondsToSelector:@selector(week)]) return [objc weak];
    return objc;
}

- (void)setASSIGN:(id _Nullable)value key:(const void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setRETAIN_NONATOMIC:(id _Nullable)value key:(const void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setCOPY_NONATOMIC:(id _Nullable)value key:(const void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setRETAIN:(id _Nullable)value key:(const void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)setCOPY:(id _Nullable)value key:(const void * _Nonnull)key {
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY);
}

- (void)setWEAK:(id _Nullable)value key:(const void * _Nonnull)key {
    HiObjectRunTimeWeak *weak = [self getAssociatedObjectForKey:key];
    if (!weak) {
        weak = [[HiObjectRunTimeWeak alloc] init];
        objc_setAssociatedObject(self, key, weak, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    weak.weak = value;
}

+ (void)hi_class_getInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector {
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method altMetthod = class_getInstanceMethod(self, newSelector);
    
    if (originalMethod && altMetthod) {
        method_exchangeImplementations(originalMethod, altMetthod);
    }
}

@end
