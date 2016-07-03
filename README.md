# ZZPageViewController
## 使用
```
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
```
