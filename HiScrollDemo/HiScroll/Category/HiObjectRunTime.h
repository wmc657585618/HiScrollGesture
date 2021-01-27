//
//  HiObjectRunTime.h
//  HiScrollDemo
//
//  Created by four on 2021/1/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HiObjectRunTime)

- (id _Nonnull)getAssociatedObjectForKey:(const void * _Nonnull)key;
- (void)setASSIGN:(id _Nullable)value key:(const void * _Nonnull)key;
- (void)setRETAIN_NONATOMIC:(id _Nullable)value key:(const void * _Nonnull)key;
- (void)setCOPY_NONATOMIC:(id _Nullable)value key:(const void * _Nonnull)key;
- (void)setRETAIN:(id _Nullable)value key:(const void * _Nonnull)key;
- (void)setCOPY:(id _Nullable)value key:(const void * _Nonnull)key;
- (void)setWEAK:(id _Nullable)value key:(const void * _Nonnull)key;

+ (void)hi_class_getInstanceMethod:(SEL)originalSelector newSelector:(SEL)newSelector;

@end

NS_ASSUME_NONNULL_END
