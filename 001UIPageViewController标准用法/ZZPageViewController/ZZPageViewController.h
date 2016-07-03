//
//  ZZPageViewController.h
//  EBookDemo
//
//  Created by 尹中正 on 16/3/11.
//  Copyright © 2016年 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PageScrollStatusBlock)();

typedef void(^CompletedBlock)(NSInteger index);

@interface ZZPageViewController :  UIViewController
/**
 *  数据源
 */
@property (strong, nonatomic) NSArray<UIViewController *> *dataSourceArray;
/**
 *  PageViewController
 */
@property (strong, nonatomic) UIPageViewController *pageViewController;
/**
 *  设置pageviewcontroller
 *
 *  @param style                   UIPageViewControllerTransitionStyle
 *  @param frame                   frame
 *  @param array                   数据源
 *  @param willBeginDraggingBlock  将要滑动时回调
 *  @param didEndDeceleratingBlock 滑动结束后回调
 *  @param completed               视图真正切换后的回调
 */
-(void)setupWithTransitionStyle:(UIPageViewControllerTransitionStyle)style frame:(CGRect)frame dataSource:(NSArray<UIViewController *> *)array willBeginDragging:(PageScrollStatusBlock)willBeginDraggingBlock didEndDecelerating:(PageScrollStatusBlock)didEndDeceleratingBlock transitionCompleted:(CompletedBlock)completed;
/**
 *  设置滚动到第index个view controller
 *
 *  @param index 要滚动到的索引
 */
-(void)scrollToViewControllerWithIndex:(NSInteger)index animated:(BOOL)animated;
/**
 *  工具方法，返回传入view controller在数据源中的索引值
 *
 *  @param vc 需要查询的view controller
 *
 *  @return 索引
 */
-(NSInteger)getTheVCIndex:(UIViewController *)vc;

@end
