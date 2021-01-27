//
//  HiScrollViewProperty.h
//  ScrollTest
//
//  Created by four on 2021/1/15.
//

#import <UIKit/UIKit.h>
#import "HiScrollObject.h"
#import "HiScrollViewDefine.h"
#import "HiScrollViewPublic.h"
#import "HiScrollViewPrivate.h"

NS_ASSUME_NONNULL_BEGIN

extern HiScrollNode * hi_nodesSort(HiScrollNode *head, BOOL revert, HiScrollViewProperty direction);

@interface UIScrollView (HiScrollViewProperty)<HiScrollGestureDelegate>

@property (nonatomic, strong, readonly) HiScrollWeak *actionScrollViewWeak;
@property (nonatomic, strong, readonly) HiScrollGesture *scrollGesture;

@property (nonatomic, weak) UIScrollView *actionScrollView; // 本次处理滚动的 scrollview

@property (nonatomic, strong) HiScrollNode *topNode;
@property (nonatomic, strong) HiScrollNode *bottomNode;
@property (nonatomic, strong) HiScrollNode *leftNode;
@property (nonatomic, strong) HiScrollNode *rightNode;
@property (nonatomic, assign) HiScrollViewDirection scrollDirection;
@property (nonatomic, assign) BOOL hi_draggin;

@end

NS_ASSUME_NONNULL_END
