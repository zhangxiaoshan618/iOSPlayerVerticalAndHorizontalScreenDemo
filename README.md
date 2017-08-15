# iOSPlayerVerticalAndHorizontalScreenDemo
这是一个iOS中播放器横竖屏切换的demo。
所有的视频类App都会面临一个播放器横竖屏切换的问题，之前一直使用KVO强制修改设备方向达到竖屏转为横屏。
```
UIDevice.current.setValue(value, forKey: "orientation")
```
但是这个方法是非官方提供的API，随着系统版本的更迭有可能会失效。
所以许多公司采用了modal出一个只支持横屏的控制器来达到横竖屏切换的目的。
## 思路
有以下两种方法实现。
### 方法1
竖屏转横屏时：由竖屏控制器做一个播放器由小变大，并且旋转为横屏的动画，动画结束时做一个无动画的present
横屏转竖屏时：做一个无动画的dimiss,dimiss完成后，依然由竖屏控制器做播放器由大变小并且旋转回原处的动画。
### 方法2
自定义转场动画！
## 效果图


