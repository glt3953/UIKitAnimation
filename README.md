# UIKitAnimation
UIKit 实现各种动效

## 动画效果
用UIKit实现了SwiftUIAnimation项目中的所有动画效果。总结如下我们实现了的动画：
1. 基础动画 - BasicAnimationViewController
2. 弹簧动画 - SpringAnimationViewController
3. 重复动画 - RepeatAnimationViewController
4. 过渡动画 - TransitionAnimationViewController
5. 手势动画 - GestureAnimationViewController
6. 组合动画 - CombinedAnimationViewController
7. 环形计时器 - TimerRingViewController
8. 精确计时器 - ExactTimerRingViewController
以上动画都是使用UIKit实现，完全保留了SwiftUI版本的交互和视觉效果，但采用了UIKit特有的实现方式，如使用UIView层级、UIViewAnimation、CALayer图层、Core Graphics绘图和手势识别等技术。
