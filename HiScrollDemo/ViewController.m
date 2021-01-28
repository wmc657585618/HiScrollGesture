//
//  ViewController.m
//  HiScrollDemo
//
//  Created by four on 2021/1/4.
//

#import "ViewController.h"
#import "HiScrollView.h"
#import "VerticalViewController.h"
#import "HorizontalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    CGFloat height = 44.0;
    CGFloat width = 100.0;
    CGFloat x = (self.view.frame.size.width - width) * 0.5;
    CGFloat y = self.view.frame.size.height * 0.5;
    
    UIButton *vertical = [UIButton buttonWithType:UIButtonTypeCustom];
    [vertical setTitle:@"vertical" forState:UIControlStateNormal];
    
    vertical.frame = CGRectMake(x, y - height, width, height);
    [vertical setTitleColor:UIColor.magentaColor forState:UIControlStateNormal];
    [self.view addSubview:vertical];
    
    
    UIButton *horizonal = [UIButton buttonWithType:UIButtonTypeCustom];
    [horizonal setTitle:@"horizonal" forState:UIControlStateNormal];
    
    horizonal.frame = CGRectMake(x, y + height, width, height);
    [horizonal setTitleColor:UIColor.magentaColor forState:UIControlStateNormal];
    [self.view addSubview:horizonal];
    
    [vertical addTarget:self action:@selector(vertical) forControlEvents:UIControlEventTouchUpInside];
    [horizonal addTarget:self action:@selector(horizonal) forControlEvents:UIControlEventTouchUpInside];
}

- (void)vertical {
    [self.navigationController pushViewController:[[VerticalViewController alloc] init] animated:true];
}

- (void)horizonal {
    [self.navigationController pushViewController:[[HorizontalViewController alloc] init] animated:true];
}

@end

//@interface ViewController ()
//
//@property (nonatomic, strong) UIScrollView *scrollView;
//
//@end
//
//
//@implementation ViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    [self.scrollView hi_scrollWithScrollDirection:HiScrollViewDirectionVertical];
//    UIImage *img = [UIImage imageNamed:@"scheme"];
//    UIImageView *imgView = [[UIImageView alloc] init];
//    imgView.image = img;
//    imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
//    imgView.backgroundColor = UIColor.redColor;
//
//    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.16 alpha:1];
//
//    [self.view addSubview:self.scrollView];
//    self.scrollView.frame = self.view.bounds;
//    [self.scrollView addSubview:imgView];
//    self.scrollView.contentSize = img.size;
//}
//
//- (UIScrollView *)scrollView {
//    if (!_scrollView) {
//        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.scrollEnabled = false;
//    }
//    return _scrollView;
//}
//
//@end
