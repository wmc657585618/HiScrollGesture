//
//  ViewController.m
//  HiScrollDemo
//
//  Created by four on 2021/1/4.
//

#import "ViewController.h"
#import "HiScrollView.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.scrollView hi_scrollWithScrollDirection:HiScrollViewDirectionVertical];
    UIImage *img = [UIImage imageNamed:@"scheme"];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = img;
    imgView.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    imgView.backgroundColor = UIColor.redColor;
    
    self.scrollView.backgroundColor = [UIColor colorWithWhite:0.16 alpha:1];

    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    [self.scrollView addSubview:imgView];
    self.scrollView.contentSize = img.size;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.scrollEnabled = false;
    }
    return _scrollView;
}



@end
