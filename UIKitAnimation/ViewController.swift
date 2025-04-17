//
//  ViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class ViewController: UITableViewController {
    
    // 动画示例列表
    struct AnimationExample {
        let title: String
        let description: String
        let viewControllerClass: UIViewController.Type
    }
    
    let animations: [AnimationExample] = [
        AnimationExample(title: "基础动画", description: "基本的UIKit动画效果", viewControllerClass: BasicAnimationViewController.self),
        AnimationExample(title: "弹簧动画", description: "使用spring效果的动画", viewControllerClass: SpringAnimationViewController.self),
        AnimationExample(title: "重复动画", description: "循环重复的动画效果", viewControllerClass: RepeatAnimationViewController.self),
        AnimationExample(title: "渐变过渡", description: "组件之间的过渡效果", viewControllerClass: TransitionAnimationViewController.self),
        AnimationExample(title: "手势动画", description: "基于手势的交互动画", viewControllerClass: GestureAnimationViewController.self),
        AnimationExample(title: "组合动画", description: "复杂的组合动画效果", viewControllerClass: CombinedAnimationViewController.self),
        AnimationExample(title: "环形计时器", description: "进度环形动画效果", viewControllerClass: TimerRingViewController.self),
        AnimationExample(title: "精确计时器", description: "按图片代码实现的环形计时器", viewControllerClass: ExactTimerRingViewController.self),
        AnimationExample(title: "音频波纹", description: "语音识别波形动画效果", viewControllerClass: AudioWaveformViewController.self),
        AnimationExample(title: "翻译波浪", description: "水中倒影样式的波浪动效", viewControllerClass: ReflectionWaveformViewController.self)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "UIKit 动画效果"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let animation = animations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = animation.title
        content.secondaryText = animation.description
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let animation = animations[indexPath.row]
        let viewController = animation.viewControllerClass.init()
        viewController.title = animation.title
        navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

