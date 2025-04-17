//
//  SpringAnimationViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class SpringAnimationViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 动画视图
    private let containerView = UIView()
    private let animatedView = UIView()
    
    // 控制滑块
    private let dampingSlider = UISlider()
    private let stiffnessSlider = UISlider()
    private let dampingLabel = UILabel()
    private let stiffnessLabel = UILabel()
    
    // 动画参数
    private var position: CGFloat = 0
    private var scale: CGFloat = 1.0
    private var dampingFraction: Double = 0.5
    private var stiffness: Double = 100
    
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
        titleLabel.text = "弹簧动画效果"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        // 容器视图（背景方块）
        containerView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        containerView.layer.cornerRadius = 15
        
        // 动画视图（蓝色方块）
        animatedView.backgroundColor = .systemBlue
        animatedView.layer.cornerRadius = 15
        
        // 阻尼系数控制
        let dampingTitleLabel = UILabel()
        dampingTitleLabel.font = .systemFont(ofSize: 16)
        dampingTitleLabel.textAlignment = .left
        dampingLabel.text = "阻尼系数: 0.50"
        
        dampingSlider.minimumValue = 0.1
        dampingSlider.maximumValue = 1.0
        dampingSlider.value = Float(dampingFraction)
        dampingSlider.addTarget(self, action: #selector(dampingSliderChanged), for: .valueChanged)
        
        // 刚度控制
        let stiffnessTitleLabel = UILabel()
        stiffnessTitleLabel.font = .systemFont(ofSize: 16)
        stiffnessTitleLabel.textAlignment = .left
        stiffnessLabel.text = "刚度: 100"
        
        stiffnessSlider.minimumValue = 50
        stiffnessSlider.maximumValue = 300
        stiffnessSlider.value = Float(stiffness)
        stiffnessSlider.addTarget(self, action: #selector(stiffnessSliderChanged), for: .valueChanged)
        
        // 按钮
        let bounceButton = UIButton(type: .system)
        bounceButton.setTitle("弹跳", for: .normal)
        bounceButton.addTarget(self, action: #selector(bounceButtonTapped), for: .touchUpInside)
        
        let scaleButton = UIButton(type: .system)
        scaleButton.setTitle("缩放", for: .normal)
        scaleButton.addTarget(self, action: #selector(scaleButtonTapped), for: .touchUpInside)
        
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("复位", for: .normal)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        
        // 设置按钮样式
        [bounceButton, scaleButton, resetButton].forEach { button in
            button.backgroundColor = .systemBackground
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemBlue.cgColor
            button.layer.cornerRadius = 8
        }
        
        // 说明标签
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.text = "说明"
        descriptionTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionTitleLabel.textAlignment = .left
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "• 阻尼系数(dampingFraction)：控制振动幅度的衰减速度，数值越小，振动越明显\n• 刚度(stiffness)：控制弹性强度，数值越大，弹力越强\n• 响应时间(response)：控制动画完成的时间，数值越小，动画越快\n• 质量(mass)：控制物体的惯性，数值越大，动画越迟缓\n• 初始速度(initialVelocity)：控制动画开始时的速度，正值表示向动画方向加速，负值表示初始反向运动"
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .left
        
        // 添加视图到容器
        [titleLabel, containerView, dampingTitleLabel, dampingLabel, dampingSlider,
         stiffnessTitleLabel, stiffnessLabel, stiffnessSlider, descriptionTitleLabel, descriptionLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        // 按钮水平排列
        let buttonStackView = UIStackView(arrangedSubviews: [bounceButton, scaleButton, resetButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        contentView.addSubview(buttonStackView)
        
        // 添加动画视图到容器
        containerView.addSubview(animatedView)
        animatedView.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            containerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            animatedView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            animatedView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            animatedView.widthAnchor.constraint(equalToConstant: 80),
            animatedView.heightAnchor.constraint(equalToConstant: 80),
            
            dampingTitleLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            dampingTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            dampingLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            dampingLabel.leadingAnchor.constraint(equalTo: dampingTitleLabel.trailingAnchor, constant: 8),
            
            dampingSlider.topAnchor.constraint(equalTo: dampingTitleLabel.bottomAnchor, constant: 10),
            dampingSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dampingSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            stiffnessTitleLabel.topAnchor.constraint(equalTo: dampingSlider.bottomAnchor, constant: 20),
            stiffnessTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            stiffnessLabel.topAnchor.constraint(equalTo: dampingSlider.bottomAnchor, constant: 20),
            stiffnessLabel.leadingAnchor.constraint(equalTo: stiffnessTitleLabel.trailingAnchor, constant: 8),
            
            stiffnessSlider.topAnchor.constraint(equalTo: stiffnessTitleLabel.bottomAnchor, constant: 10),
            stiffnessSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stiffnessSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            buttonStackView.topAnchor.constraint(equalTo: stiffnessSlider.bottomAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 300),
            buttonStackView.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 30),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // 初始化标签
        dampingTitleLabel.text = "阻尼系数:"
        stiffnessTitleLabel.text = "刚度:"
    }
    
    // MARK: - 动作回调
    
    @objc private func dampingSliderChanged() {
        dampingFraction = Double(dampingSlider.value)
        dampingLabel.text = String(format: "阻尼系数: %.2f", dampingFraction)
    }
    
    @objc private func stiffnessSliderChanged() {
        stiffness = Double(stiffnessSlider.value)
        stiffnessLabel.text = String(format: "刚度: %.0f", stiffness)
    }
    
    @objc private func bounceButtonTapped() {
        // 复位
        position = 0
        animatedView.transform = .identity
        
        // 使用弹性动画进行弹跳
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: []) {
            self.animatedView.transform = CGAffineTransform(translationX: 0, y: 100)
        }
    }
    
    @objc private func scaleButtonTapped() {
        // 复位缩放
        scale = 1.0
        animatedView.transform = .identity
        
        // 使用弹性动画进行缩放
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: CGFloat(dampingFraction), initialSpringVelocity: 0.5, options: []) {
            self.animatedView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
    }
    
    @objc private func resetButtonTapped() {
        // 使用弹性动画进行复位
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: CGFloat(dampingFraction), initialSpringVelocity: 0.0, options: []) {
            self.animatedView.transform = .identity
        }
    }
} 