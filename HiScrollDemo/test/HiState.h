//
//  HiState.h
//  HiScrollDemo
//
//  Created by four on 2021/1/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    StateDefault,
    StateDraggin,
} HiStateType;

@interface HiState : NSObject

@property (nonatomic, assign) HiStateType state;
@property (nonatomic, assign) CGPoint initialOffset;

@end

NS_ASSUME_NONNULL_END
