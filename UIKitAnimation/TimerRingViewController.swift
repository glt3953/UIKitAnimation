//
//  TimerRingViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class TimerRingViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 计时器视图
    private let timerRingView = TimerRingView()
    private let timerSlider = UISlider()
    private let percentageLabel = UILabel()
    
    // 控制按钮
    private let startButton = UIButton(type: .system)
    private let resetButton = UIButton(type: .system)
    private let loopButton = UIButton(type: .system)
    
    // 状态
    private var progress: CGFloat = 0.0
    private var isAnimating = false
    private var animationTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timerRingView.setNeedsDisplay()
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
        titleLabel.text = "环形计时器动画"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 环形计时器视图
        timerRingView.translatesAutoresizingMaskIntoConstraints = false
        timerRingView.backgroundColor = .clear
        contentView.addSubview(timerRingView)
        
        // 控制按钮容器
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        // 开始按钮
        startButton.setTitle("开始", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.systemBlue.cgColor
        startButton.layer.cornerRadius = 8
        
        // 重置按钮
        resetButton.setTitle("重置", for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.systemBlue.cgColor
        resetButton.layer.cornerRadius = 8
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(resetButton)
        
        // 进度控制滑块标签
        let sliderTitleLabel = UILabel()
        sliderTitleLabel.text = "手动调整进度:"
        sliderTitleLabel.font = .systemFont(ofSize: 16)
        sliderTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sliderTitleLabel)
        
        // 进度百分比标签
        percentageLabel.text = "0%"
        percentageLabel.textAlignment = .right
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(percentageLabel)
        
        // 进度滑块
        timerSlider.minimumValue = 0.0
        timerSlider.maximumValue = 1.0
        timerSlider.value = 0.0
        timerSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        timerSlider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timerSlider)
        
        // 循环动画按钮
        loopButton.setTitle("自动循环", for: .normal)
        loopButton.addTarget(self, action: #selector(loopButtonTapped), for: .touchUpInside)
        loopButton.backgroundColor = .systemBlue
        loopButton.setTitleColor(.white, for: .normal)
        loopButton.layer.cornerRadius = 8
        loopButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loopButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            timerRingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            timerRingView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            timerRingView.widthAnchor.constraint(equalToConstant: 250),
            timerRingView.heightAnchor.constraint(equalToConstant: 250),
            
            buttonStackView.topAnchor.constraint(equalTo: timerRingView.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 200),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            
            sliderTitleLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 30),
            sliderTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            percentageLabel.centerYAnchor.constraint(equalTo: sliderTitleLabel.centerYAnchor),
            percentageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            percentageLabel.widthAnchor.constraint(equalToConstant: 50),
            
            timerSlider.topAnchor.constraint(equalTo: sliderTitleLabel.bottomAnchor, constant: 15),
            timerSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timerSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            loopButton.topAnchor.constraint(equalTo: timerSlider.bottomAnchor, constant: 30),
            loopButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loopButton.widthAnchor.constraint(equalToConstant: 150),
            loopButton.heightAnchor.constraint(equalToConstant: 44),
            loopButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: - 动作回调
    
    @objc private func startButtonTapped() {
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut) {
            self.progress = 1.0
            self.timerRingView.progress = 1.0
            self.timerSlider.value = 1.0
            self.updatePercentageLabel()
        }
    }
    
    @objc private func resetButtonTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.progress = 0.0
            self.timerRingView.progress = 0.0
            self.timerSlider.value = 0.0
            self.updatePercentageLabel()
        }
    }
    
    @objc private func sliderValueChanged() {
        progress = CGFloat(timerSlider.value)
        timerRingView.progress = progress
        updatePercentageLabel()
    }
    
    @objc private func loopButtonTapped() {
        isAnimating.toggle()
        
        if isAnimating {
            loopButton.setTitle("停止循环", for: .normal)
            startLoopingAnimation()
        } else {
            loopButton.setTitle("自动循环", for: .normal)
            animationTimer?.invalidate()
            animationTimer = nil
        }
    }
    
    private func updatePercentageLabel() {
        percentageLabel.text = "\(Int(progress * 100))%"
    }
    
    private func startLoopingAnimation() {
        // 重置进度
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut) {
            self.progress = 0.0
            self.timerRingView.progress = 0.0
            self.timerSlider.value = 0.0
            self.updatePercentageLabel()
        }
        
        // 延迟后开始动画
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if self.isAnimating {
                UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseInOut) {
                    self.progress = 1.0
                    self.timerRingView.progress = 1.0
                    self.timerSlider.value = 1.0
                    self.updatePercentageLabel()
                }
                
                // 完成后再次调用
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    if self.isAnimating {
                        self.startLoopingAnimation()
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 停止动画计时器
        animationTimer?.invalidate()
        animationTimer = nil
    }
}

// MARK: - 环形计时器视图

class TimerRingView: UIView {
    
    // 进度
    var progress: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    // 根据进度返回颜色
    private func colorForProgress(_ progress: CGFloat) -> UIColor {
        if progress < 0.3 {
            return .systemBlue
        } else if progress < 0.7 {
            return .systemGreen
        } else {
            return .systemOrange
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 25 // 圆环半径
        let lineWidth: CGFloat = 25 // 圆环宽度
        
        // 绘制表示时间图标
        if let timerImage = UIImage(systemName: "timer")?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal) {
            let imageRect = CGRect(
                x: center.x - 40,
                y: center.y - 40,
                width: 80,
                height: 80
            )
            timerImage.draw(in: imageRect)
        }
        
        // 绘制底层圆环
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.systemGray.withAlphaComponent(0.1).cgColor)
        context.setLineCap(.round)
        
        context.addArc(
            center: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: false
        )
        context.strokePath()
        
        // 绘制进度圆环
        if progress > 0 {
            context.setLineWidth(lineWidth)
            context.setStrokeColor(colorForProgress(progress).cgColor)
            context.setLineCap(.round)
            
            // 从顶部开始绘制进度
            let startAngle: CGFloat = -.pi / 2
            let endAngle: CGFloat = startAngle + (2 * .pi * progress)
            
            context.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false
            )
            context.strokePath()
        }
    }
} 