//
//  ZZPageViewController.m
//  EBookDemo
//
//  Created by 尹中正 on 16/3/11.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import "ZZPageViewController.h"

@interface ZZPageViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>
/**
 *  将要滑动时回调，设置调用setViewControllers:direction:animated:completion:接口的控件的userInteractionEnabled为NO，防止崩溃
 */
@property (nonatomic, copy) PageScrollStatusBlock willBeginDraggingBlock;
/**
 *  滑动结束后回调，设置调用setViewControllers:direction:animated:completion:接口的控件的userInteractionEnabled为YES，防止崩溃
 */
@property (nonatomic, copy) PageScrollStatusBlock didEndDeceleratingBlock;
/**
 *  pageViewController确定滑动到上/下个界面时回调
 */
@property (nonatomic, copy) CompletedBlock completedBlock;

@end

@implementation ZZPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 设置
-(void)setupWithTransitionStyle:(UIPageViewControllerTransitionStyle)style frame:(CGRect)frame dataSource:(NSArray<UIViewController *> *)array willBeginDragging:(PageScrollStatusBlock)willBeginDraggingBlock didEndDecelerating:(PageScrollStatusBlock)didEndDeceleratingBlock transitionCompleted:(CompletedBlock)completed {
    self.dataSourceArray = array;
    [self createPageViewControllerWithTransitionStyle:style frame:frame];
    self.willBeginDraggingBlock = willBeginDraggingBlock;
    self.didEndDeceleratingBlock = didEndDeceleratingBlock;
    self.completedBlock = completed;
}

#pragma mark - UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self getTheVCIndex:viewController];
    return index ? _dataSourceArray[index - 1] : nil;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self getTheVCIndex:viewController];
    return (index + 1 >= _dataSourceArray.count) ? nil : _dataSourceArray[index + 1];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (pageViewController.viewControllers.firstObject != previousViewControllers.firstObject) {
        NSInteger index = [self getTheVCIndex:self.pageViewController.viewControllers.firstObject];
        if (_completedBlock) {
            _completedBlock(index);
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_willBeginDraggingBlock) {
        _willBeginDraggingBlock();
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_didEndDeceleratingBlock) {
        _didEndDeceleratingBlock();
    }
}

#pragma mark - 设置滚动到第index个view controller
-(void)scrollToViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated {
    NSInteger currentIndex = [self getTheVCIndex:self.pageViewController.viewControllers.firstObject];
    if (currentIndex == index) {
        return;
    }
    UIPageViewControllerNavigationDirection direction = currentIndex < index ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[_dataSourceArray[index]] direction:direction animated:animated completion:nil];
}

#pragma mark - 工具方法
-(NSInteger)getTheVCIndex:(UIViewController *)vc {
    return [_dataSourceArray indexOfObject:vc];
}

#pragma mark - 私有方法
-(void)createPageViewControllerWithTransitionStyle:(UIPageViewControllerTransitionStyle)style frame:(CGRect)frame {
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:style navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    _pageViewController.view.frame = frame;
    [_pageViewController setViewControllers:@[_dataSourceArray.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self setPageViewControllerScrollViewDelegate];
}
/**
 *  设置PageViewController的ScrollViewDelegate的代理，当滑动开始和结束时触发代理，控制其它控件在这时不能操作PageViewController，防止崩溃
 */
-(void)setPageViewControllerScrollViewDelegate {
    [self.pageViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView *)obj).delegate = self;
        }
    }];
}

@end
