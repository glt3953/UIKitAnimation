//
//  RepeatAnimationViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class RepeatAnimationViewController: UIViewController {
    
    // 动画视图
    private let pulseCircleView = UIView()
    private let rotationImageView = UIImageView()
    private let waveContainerView = UIView()
    private var waveCapsules: [UIView] = []
    
    // 动画控制按钮
    private let pulseButton = UIButton(type: .system)
    private let rotateButton = UIButton(type: .system)
    private let waveButton = UIButton(type: .system)
    private let allAnimationsButton = UIButton(type: .system)
    
    // 动画状态
    private var isPulsing = false
    private var isRotating = false
    private var isWaving = false
    private var isAnimating = false
    
    // 动画引用
    private var pulseAnimator: UIViewPropertyAnimator?
    private var rotateAnimator: CADisplayLink?
    private var waveAnimators: [UIViewPropertyAnimator?] = []
    
    // 旋转动画角度
    private var rotationDegrees: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupViews()
        
        // 初次加载时展示动画效果
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startAllAnimations()
        }
    }
    
    private func setupViews() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "重复动画效果"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 脉冲效果视图
        let pulseTitle = UILabel()
        pulseTitle.text = "脉冲效果"
        pulseTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        pulseTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pulseTitle)
        
        pulseCircleView.backgroundColor = .systemRed
        pulseCircleView.layer.cornerRadius = 50
        pulseCircleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pulseCircleView)
        
        pulseButton.setTitle("开始", for: .normal)
        pulseButton.addTarget(self, action: #selector(pulseButtonTapped), for: .touchUpInside)
        pulseButton.layer.borderWidth = 1
        pulseButton.layer.borderColor = UIColor.systemBlue.cgColor
        pulseButton.layer.cornerRadius = 8
        pulseButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pulseButton)
        
        // 旋转效果视图
        let rotateTitle = UILabel()
        rotateTitle.text = "旋转效果"
        rotateTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        rotateTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rotateTitle)
        
        if let image = UIImage(systemName: "arrow.clockwise.circle") {
            rotationImageView.image = image
            rotationImageView.tintColor = .label
            rotationImageView.contentMode = .scaleAspectFit
        }
        rotationImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rotationImageView)
        
        rotateButton.setTitle("开始", for: .normal)
        rotateButton.addTarget(self, action: #selector(rotateButtonTapped), for: .touchUpInside)
        rotateButton.layer.borderWidth = 1
        rotateButton.layer.borderColor = UIColor.systemBlue.cgColor
        rotateButton.layer.cornerRadius = 8
        rotateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rotateButton)
        
        // 波浪效果视图
        let waveTitle = UILabel()
        waveTitle.text = "波浪效果"
        waveTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        waveTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(waveTitle)
        
        waveContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(waveContainerView)
        
        // 创建5个波浪胶囊
        for i in 0..<5 {
            let capsule = UIView()
            capsule.backgroundColor = .systemBlue
            capsule.layer.cornerRadius = 10
            capsule.translatesAutoresizingMaskIntoConstraints = false
            waveContainerView.addSubview(capsule)
            waveCapsules.append(capsule)
            
            NSLayoutConstraint.activate([
                capsule.centerYAnchor.constraint(equalTo: waveContainerView.centerYAnchor),
                capsule.widthAnchor.constraint(equalToConstant: 20),
                capsule.heightAnchor.constraint(equalToConstant: 60),
                capsule.leadingAnchor.constraint(equalTo: waveContainerView.leadingAnchor, constant: CGFloat(i * 30))
            ])
        }
        
        waveButton.setTitle("开始", for: .normal)
        waveButton.addTarget(self, action: #selector(waveButtonTapped), for: .touchUpInside)
        waveButton.layer.borderWidth = 1
        waveButton.layer.borderColor = UIColor.systemBlue.cgColor
        waveButton.layer.cornerRadius = 8
        waveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(waveButton)
        
        // 所有动画的控制按钮
        allAnimationsButton.setTitle("启动所有动画", for: .normal)
        allAnimationsButton.addTarget(self, action: #selector(allAnimationsButtonTapped), for: .touchUpInside)
        allAnimationsButton.backgroundColor = .systemBlue
        allAnimationsButton.setTitleColor(.white, for: .normal)
        allAnimationsButton.layer.cornerRadius = 8
        allAnimationsButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(allAnimationsButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 脉冲效果约束
            pulseTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            pulseTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            pulseCircleView.topAnchor.constraint(equalTo: pulseTitle.bottomAnchor, constant: 20),
            pulseCircleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pulseCircleView.widthAnchor.constraint(equalToConstant: 100),
            pulseCircleView.heightAnchor.constraint(equalToConstant: 100),
            
            pulseButton.topAnchor.constraint(equalTo: pulseCircleView.bottomAnchor, constant: 20),
            pulseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pulseButton.widthAnchor.constraint(equalToConstant: 100),
            pulseButton.heightAnchor.constraint(equalToConstant: 36),
            
            // 旋转效果约束
            rotateTitle.topAnchor.constraint(equalTo: pulseButton.bottomAnchor, constant: 40),
            rotateTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            rotationImageView.topAnchor.constraint(equalTo: rotateTitle.bottomAnchor, constant: 20),
            rotationImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rotationImageView.widthAnchor.constraint(equalToConstant: 70),
            rotationImageView.heightAnchor.constraint(equalToConstant: 70),
            
            rotateButton.topAnchor.constraint(equalTo: rotationImageView.bottomAnchor, constant: 20),
            rotateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rotateButton.widthAnchor.constraint(equalToConstant: 100),
            rotateButton.heightAnchor.constraint(equalToConstant: 36),
            
            // 波浪效果约束
            waveTitle.topAnchor.constraint(equalTo: rotateButton.bottomAnchor, constant: 40),
            waveTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            waveContainerView.topAnchor.constraint(equalTo: waveTitle.bottomAnchor, constant: 20),
            waveContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            waveContainerView.widthAnchor.constraint(equalToConstant: 150),
            waveContainerView.heightAnchor.constraint(equalToConstant: 100),
            
            waveButton.topAnchor.constraint(equalTo: waveContainerView.bottomAnchor, constant: 20),
            waveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            waveButton.widthAnchor.constraint(equalToConstant: 100),
            waveButton.heightAnchor.constraint(equalToConstant: 36),
            
            // 所有动画按钮约束
            allAnimationsButton.topAnchor.constraint(equalTo: waveButton.bottomAnchor, constant: 40),
            allAnimationsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            allAnimationsButton.widthAnchor.constraint(equalToConstant: 200),
            allAnimationsButton.heightAnchor.constraint(equalToConstant: 44),
            allAnimationsButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - 动画控制
    
    private func startPulseAnimation() {
        isPulsing = true
        pulseButton.setTitle("停止", for: .normal)
        
        // 清除之前的动画
        pulseCircleView.layer.removeAllAnimations()
        
        // 创建缩放动画
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 0.8
        animation.toValue = 1.2
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        pulseCircleView.layer.add(animation, forKey: "pulse")
        
        // 创建透明度动画
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.6
        opacityAnimation.toValue = 1.0
        opacityAnimation.duration = 1.0
        opacityAnimation.autoreverses = true
        opacityAnimation.repeatCount = .infinity
        pulseCircleView.layer.add(opacityAnimation, forKey: "opacity")
    }
    
    private func stopPulseAnimation() {
        isPulsing = false
        pulseButton.setTitle("开始", for: .normal)
        pulseCircleView.layer.removeAllAnimations()
    }
    
    private func startRotateAnimation() {
        isRotating = true
        rotateButton.setTitle("停止", for: .normal)
        
        // 使用CADisplayLink实现平滑旋转
        rotateAnimator = CADisplayLink(target: self, selector: #selector(updateRotation))
        rotateAnimator?.add(to: .current, forMode: .common)
    }
    
    @objc private func updateRotation() {
        rotationDegrees += 2 // 每帧旋转2度
        rotationImageView.transform = CGAffineTransform(rotationAngle: rotationDegrees * .pi / 180)
    }
    
    private func stopRotateAnimation() {
        isRotating = false
        rotateButton.setTitle("开始", for: .normal)
        rotateAnimator?.invalidate()
        rotateAnimator = nil
    }
    
    private func startWaveAnimation() {
        isWaving = true
        waveButton.setTitle("停止", for: .normal)
        
        // 停止现有的波浪动画
        stopWaveAnimation(keepState: true)
        
        // 为每个胶囊创建波浪动画
        for (index, capsule) in waveCapsules.enumerated() {
            // 清除现有变换
            capsule.transform = .identity
            
            // 创建上下移动的动画
            let animation = CABasicAnimation(keyPath: "transform.translation.y")
            animation.fromValue = 0
            animation.toValue = -20
            animation.duration = 0.5
            animation.autoreverses = true
            animation.repeatCount = .infinity
            animation.beginTime = CACurrentMediaTime() + Double(index) * 0.1
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            capsule.layer.add(animation, forKey: "wave")
        }
    }
    
    private func stopWaveAnimation(keepState: Bool = false) {
        if !keepState {
            isWaving = false
            waveButton.setTitle("开始", for: .normal)
        }
        
        // 停止所有波浪动画
        for capsule in waveCapsules {
            capsule.layer.removeAllAnimations()
            if !keepState {
                capsule.transform = .identity
            }
        }
    }
    
    private func startAllAnimations() {
        isAnimating = true
        allAnimationsButton.setTitle("停止所有动画", for: .normal)
        
        startPulseAnimation()
        startRotateAnimation()
        startWaveAnimation()
    }
    
    private func stopAllAnimations() {
        isAnimating = false
        allAnimationsButton.setTitle("启动所有动画", for: .normal)
        
        stopPulseAnimation()
        stopRotateAnimation()
        stopWaveAnimation()
    }
    
    // MARK: - 按钮回调
    
    @objc private func pulseButtonTapped() {
        if isPulsing {
            stopPulseAnimation()
        } else {
            startPulseAnimation()
        }
    }
    
    @objc private func rotateButtonTapped() {
        if isRotating {
            stopRotateAnimation()
        } else {
            startRotateAnimation()
        }
    }
    
    @objc private func waveButtonTapped() {
        if isWaving {
            stopWaveAnimation()
        } else {
            startWaveAnimation()
        }
    }
    
    @objc private func allAnimationsButtonTapped() {
        if isAnimating {
            stopAllAnimations()
        } else {
            startAllAnimations()
        }
    }
    
    // MARK: - 清理
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 停止所有动画以防止内存泄漏
        stopPulseAnimation()
        stopRotateAnimation()
        stopWaveAnimation()
    }
} 