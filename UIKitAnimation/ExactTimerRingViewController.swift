//
//  ExactTimerRingViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class ExactTimerRingViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 定时器环视图
    private let timerRingView = ExactTimerRingView()
    
    // 控制按钮
    private let increaseButton = UIButton(type: .system)
    private let decreaseButton = UIButton(type: .system)
    private let animateButton = UIButton(type: .system)
    
    // 状态
    private var progress: CGFloat = 0.3
    private var isAnimating = false
    private var displayLink: CADisplayLink?
    private var startTime: TimeInterval = 0
    private var animationDuration: TimeInterval = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        // 标题
        let titleLabel = UILabel()
        titleLabel.text = "精确环形计时器"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 环形计时器视图
        timerRingView.progress = progress
        timerRingView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timerRingView)
        
        // 控制按钮容器
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        // 增加按钮
        increaseButton.setTitle("增加进度", for: .normal)
        increaseButton.addTarget(self, action: #selector(increaseProgress), for: .touchUpInside)
        increaseButton.layer.borderWidth = 1
        increaseButton.layer.borderColor = UIColor.systemBlue.cgColor
        increaseButton.layer.cornerRadius = 8
        
        // 减少按钮
        decreaseButton.setTitle("减少进度", for: .normal)
        decreaseButton.addTarget(self, action: #selector(decreaseProgress), for: .touchUpInside)
        decreaseButton.layer.borderWidth = 1
        decreaseButton.layer.borderColor = UIColor.systemBlue.cgColor
        decreaseButton.layer.cornerRadius = 8
        
        buttonStackView.addArrangedSubview(increaseButton)
        buttonStackView.addArrangedSubview(decreaseButton)
        
        // 动画控制按钮
        animateButton.setTitle("开始动画", for: .normal)
        animateButton.addTarget(self, action: #selector(toggleAnimation), for: .touchUpInside)
        animateButton.backgroundColor = .systemBlue
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.layer.cornerRadius = 8
        animateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animateButton)
        
        // 说明标题
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.text = "实现说明"
        descriptionTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTitleLabel)
        
        // 说明文本
        let descriptionLabel = UILabel()
        descriptionLabel.text = "此视图使用Core Graphics和CAShapeLayer实现环形进度条，并使用精确的角度和样式参数。基于SwiftUI版本的设计，使用UIKit重新实现。"
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timerRingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            timerRingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timerRingView.widthAnchor.constraint(equalToConstant: 280),
            timerRingView.heightAnchor.constraint(equalToConstant: 280),
            
            buttonStackView.topAnchor.constraint(equalTo: timerRingView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 240),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            
            animateButton.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 30),
            animateButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animateButton.widthAnchor.constraint(equalToConstant: 160),
            animateButton.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: animateButton.bottomAnchor, constant: 30),
            descriptionTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - 动作回调
    
    @objc private func increaseProgress() {
        progress = min(1.0, progress + 0.1)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.timerRingView.progress = self.progress
        }
    }
    
    @objc private func decreaseProgress() {
        progress = max(0.0, progress - 0.1)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.timerRingView.progress = self.progress
        }
    }
    
    @objc private func toggleAnimation() {
        isAnimating.toggle()
        
        if isAnimating {
            animateButton.setTitle("停止动画", for: .normal)
            startAnimating()
        } else {
            animateButton.setTitle("开始动画", for: .normal)
            stopAnimating()
            
            // 恢复到初始进度
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.progress = 0.3
                self.timerRingView.progress = 0.3
            }
        }
    }
    
    private func startAnimating() {
        // 保存开始时间
        startTime = CACurrentMediaTime()
        
        // 创建和启动 CADisplayLink
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateAnimation() {
        // 计算动画的已经过时间
        let elapsedTime = CACurrentMediaTime() - startTime
        
        // 计算当前进度
        var currentProgress = elapsedTime / animationDuration
        
        // 如果超过了动画时间，则重新开始
        if currentProgress >= 1.0 {
            startTime = CACurrentMediaTime()
            currentProgress = 0.0
        }
        
        // 更新进度
        progress = currentProgress
        timerRingView.progress = progress
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 停止 DisplayLink
        stopAnimating()
    }
}

// MARK: - 精确环形计时器视图

class ExactTimerRingView: UIView {
    
    // 进度
    var progress: CGFloat = 0.3 {
        didSet {
            updateLayers()
        }
    }
    
    // 线宽
    private let lineWidth: CGFloat = 25
    
    // 层
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let timerImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        backgroundColor = .clear
        
        // 背景圆环层
        backgroundLayer.fillColor = nil
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round
        backgroundLayer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        layer.addSublayer(backgroundLayer)
        
        // 进度圆环层
        progressLayer.fillColor = nil
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        // 定时器图标
        if let timerImage = UIImage(systemName: "timer")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) {
            timerImageView.image = timerImage
            timerImageView.contentMode = .scaleAspectFit
            addSubview(timerImageView)
            timerImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                timerImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                timerImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                timerImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.55),
                timerImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.55)
            ])
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2 - 10
        
        // 构造圆形路径
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        )
        
        // 设置背景圆环层的路径
        backgroundLayer.path = circlePath.cgPath
        
        // 设置进度圆环层的路径
        progressLayer.path = circlePath.cgPath
        
        // 更新进度层
        updateLayers()
    }
    
    private func updateLayers() {
        // 从上方（-90度）开始进度
        let startAngle: CGFloat = -.pi / 2
        
        // 创建一个新的进度路径
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2 - 10
        
        let progressPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: startAngle + 2 * .pi * progress,
            clockwise: true
        )
        
        // 更新进度层的路径和进度
        CATransaction.begin()
        CATransaction.setDisableActions(true) // 禁用隐式动画
        progressLayer.path = progressPath.cgPath
        progressLayer.strokeEnd = 1.0
        CATransaction.commit()
    }
} 