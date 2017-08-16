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
但是目前这个方法有一个问题，就是在横屏转竖屏时，画面偶尔会闪一下（这是一个需要优化的地方），不知道爱奇艺是如何解决的。
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

