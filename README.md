# iOSPlayerVerticalAndHorizontalScreenDemo
这是一个iOS中播放器横竖屏切换的demo。
所有的视频类App都会面临一个播放器横竖屏切换的问题，之前一直使用KVO强制修改设备方向达到竖屏转为横屏。
```
UIDevice.current.setValue(value, forKey: "orientation")
```
目前看来，优酷视频貌似依然使用的这个方法，具体表现为statusBar会跟着屏幕做旋转动画，而且播放器下的其他控件会转到横屏布局。
但是这个方法是非官方提供的API，随着系统版本的更迭有可能会失效。
所以许多公司采用了modal出一个只支持横屏的控制器来达到横竖屏切换的目的。
## 思路
有以下两种方法实现。
### 方法1
竖屏转横屏时：由竖屏控制器做一个播放器由小变大，并且旋转为横屏的动画，动画结束时做一个无动画的present
横屏转竖屏时：做一个无动画的dimiss,dimiss完成后，依然由竖屏控制器做播放器由大变小并且旋转回原处的动画。
目前看来，爱奇艺和bilibili貌似使用这个方式，具体表现为竖屏切横屏时，播放器动画完成后，statusBar无动画转为横屏；横屏切竖屏时，statusBar先无动画转为竖屏，然后才开始播放器动画。
#### 这种方法的坑
#### 问题
但是目前这个方法有一个问题，就是在横屏转竖屏时，画面偶尔会闪一下。
#### 问题分析
画面偶尔会闪一下，是在默认的模式下，控制器的.modalPresentationStyle = UIModalPresentationStyle.fullScreen,此时，当控制器A present 出控制器B，完成present动作后，控制器B的view会添加进一个UITransitionView类型的View中（即我们在自定义转场动画时的transitionContext.containerView），UITransitionView是直接添加在Window上的，而控制器A的view会暂时从视图层级中移除。当无动画dimiss时，UITransitionView先从Window移除，然后控制器A的View在添加到window上，在这中间有可能会造成闪动。
所以只要保证完成present动作后，控制器A的view依然保持在视图层级中即可。
#### 解决方案
##### 解决方案1
在UIModalPresentationStyle中有一个枚举类型：.overFullScreen，这个方式的作用就是保证完成present动作后，控制器A的view依然保持在视图层级中。
所以我们设置控制器B的.modalPresentationStyle = .overFullScreen，测试证明这个属性可以保证完成present动作后，控制器A的view依然保持在视图层级中，但是重力感应的方向不会发生改变。所以这个方案不可用。
##### 解决方案2
既然系统没有可以使用的，那我们可以在presen完成后，自己手动把控制器A 的View插入到控制器BView的下边。有两种方式，
方式一：
将控制器A的view直接插入到UITransitionView内的控制器B的View下
```
// 方式一：将当前控制器的view插入到 横屏view的下方
controller.view.superview?.insertSubview(strongSelf.view, belowSubview: controller.view)
```
方式二：
将window的rootViewController的View插入到Window之上，UITransitionView之下，这种方式的效果和.overFullScreen的效果一样。
这两种方式都可以，可以根据实际情况来选择使用
```
// 方式二：.overFullScreen的实际效果
if let keyWindow = UIApplication.shared.keyWindow,let rootViewController = UIApplication.shared.keyWindow?.rootViewController, let containerView = controller.view.superview  {
                    keyWindow.insertSubview(rootViewController.view, belowSubview: containerView)
                }
```

### 方法2
自定义转场动画！
目前看来，腾讯视频有可能使用这个方式。
但是这个方式也有一个问题，就是自动转场动画后，从横屏返回竖屏，本该竖屏的控制器不能变回竖屏，这应该是苹果的一个bug，目前我的解决方式是在将要展现的生命周期方法中强行设置为正确的fram
```
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("Tabbar - WillAppear",view.frame)
    // 因为 presented 完成后，控制器的view的frame会错乱，需要每次将要展现的时候强制设置一下
    view.frame = UIScreen.main.bounds
}
```
## 效果图
![](Resource/Demonstration.gif)

