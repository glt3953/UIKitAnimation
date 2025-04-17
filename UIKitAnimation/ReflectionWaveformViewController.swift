//
//  ReflectionWaveformViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class ReflectionWaveformViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 波浪视图
    private let waveContainer = UIView()
    private let waterTopView = UIView()
    private let waterBottomView = UIView()
    
    // 波浪层
    private let waveLayer = CAShapeLayer()
    private let reflectionLayer = CAShapeLayer()
    
    // 配置参数
    private let waveColor = UIColor.systemBlue
    private var wavePhase: CGFloat = 0
    private var waveHeight: CGFloat = 10
    private var waveFrequency: CGFloat = 10
    
    // 控制按钮
    private let animateButton = UIButton(type: .system)
    private let heightSlider = UISlider()
    private let frequencySlider = UISlider()
    
    // 动画状态
    private var isAnimating = false
    private var displayLink: CADisplayLink?
    
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
        titleLabel.text = "水中倒影波浪动画"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 波浪容器
        waveContainer.layer.cornerRadius = 12
        waveContainer.layer.masksToBounds = true
        waveContainer.backgroundColor = .systemGray6
        waveContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(waveContainer)
        
        // 上半部分水面
        waterTopView.backgroundColor = .clear
        waterTopView.translatesAutoresizingMaskIntoConstraints = false
        waveContainer.addSubview(waterTopView)
        
        // 下半部分水面（倒影）
        waterBottomView.backgroundColor = .clear
        waterBottomView.translatesAutoresizingMaskIntoConstraints = false
        waveContainer.addSubview(waterBottomView)
        
        // 分隔线
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        waveContainer.addSubview(dividerView)
        
        // 设置控件约束
        NSLayoutConstraint.activate([
            waterTopView.topAnchor.constraint(equalTo: waveContainer.topAnchor),
            waterTopView.leadingAnchor.constraint(equalTo: waveContainer.leadingAnchor),
            waterTopView.trailingAnchor.constraint(equalTo: waveContainer.trailingAnchor),
            waterTopView.heightAnchor.constraint(equalTo: waveContainer.heightAnchor, multiplier: 0.5),
            
            dividerView.topAnchor.constraint(equalTo: waterTopView.bottomAnchor),
            dividerView.leadingAnchor.constraint(equalTo: waveContainer.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: waveContainer.trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            waterBottomView.topAnchor.constraint(equalTo: dividerView.bottomAnchor),
            waterBottomView.leadingAnchor.constraint(equalTo: waveContainer.leadingAnchor),
            waterBottomView.trailingAnchor.constraint(equalTo: waveContainer.trailingAnchor),
            waterBottomView.bottomAnchor.constraint(equalTo: waveContainer.bottomAnchor)
        ])
        
        // 波浪高度控制
        let heightLabel = UILabel()
        heightLabel.text = "波浪高度"
        heightLabel.font = .systemFont(ofSize: 16)
        heightLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(heightLabel)
        
        heightSlider.minimumValue = 2
        heightSlider.maximumValue = 30
        heightSlider.value = Float(waveHeight)
        heightSlider.addTarget(self, action: #selector(heightSliderChanged), for: .valueChanged)
        heightSlider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(heightSlider)
        
        // 波浪频率控制
        let frequencyLabel = UILabel()
        frequencyLabel.text = "波浪频率"
        frequencyLabel.font = .systemFont(ofSize: 16)
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(frequencyLabel)
        
        frequencySlider.minimumValue = 5
        frequencySlider.maximumValue = 20
        frequencySlider.value = Float(waveFrequency)
        frequencySlider.addTarget(self, action: #selector(frequencySliderChanged), for: .valueChanged)
        frequencySlider.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(frequencySlider)
        
        // 动画控制按钮
        animateButton.setTitle("开始动画", for: .normal)
        animateButton.addTarget(self, action: #selector(animateButtonTapped), for: .touchUpInside)
        animateButton.backgroundColor = .systemBlue
        animateButton.setTitleColor(.white, for: .normal)
        animateButton.layer.cornerRadius = 8
        animateButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animateButton)
        
        // 说明标题
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.text = "动画说明"
        descriptionTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTitleLabel)
        
        // 说明文本
        let descriptionLabel = UILabel()
        descriptionLabel.text = "此动画模拟了水中倒影的波纹效果：\n\n• 上半部分是原始波浪\n• 下半部分是波浪的倒影\n• 波浪高度：控制波浪振幅\n• 波浪频率：控制波浪的密度\n\n这种效果常用于文字倒影、水面反射等场景，是一种经典的视觉效果。"
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // 添加一些示例内容到波浪视图
        addContentToWaveView()
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            waveContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            waveContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            waveContainer.widthAnchor.constraint(equalToConstant: 300),
            waveContainer.heightAnchor.constraint(equalToConstant: 240),
            
            heightLabel.topAnchor.constraint(equalTo: waveContainer.bottomAnchor, constant: 30),
            heightLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            heightSlider.topAnchor.constraint(equalTo: heightLabel.bottomAnchor, constant: 10),
            heightSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            heightSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            frequencyLabel.topAnchor.constraint(equalTo: heightSlider.bottomAnchor, constant: 20),
            frequencyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            frequencySlider.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 10),
            frequencySlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            frequencySlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            animateButton.topAnchor.constraint(equalTo: frequencySlider.bottomAnchor, constant: 30),
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
        
        // 设置波浪层
        setupWaveLayers()
    }
    
    private func addContentToWaveView() {
        // 上半部分添加文字
        let topLabel = UILabel()
        topLabel.text = "水面上的文字"
        topLabel.textAlignment = .center
        topLabel.font = .systemFont(ofSize: 24, weight: .bold)
        topLabel.textColor = .systemBlue
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        waterTopView.addSubview(topLabel)
        
        // 下半部分添加倒影文字
        let bottomLabel = UILabel()
        bottomLabel.text = "水面上的文字"
        bottomLabel.textAlignment = .center
        bottomLabel.font = .systemFont(ofSize: 24, weight: .bold)
        bottomLabel.textColor = .systemBlue.withAlphaComponent(0.7)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        waterBottomView.addSubview(bottomLabel)
        
        NSLayoutConstraint.activate([
            topLabel.centerXAnchor.constraint(equalTo: waterTopView.centerXAnchor),
            topLabel.centerYAnchor.constraint(equalTo: waterTopView.centerYAnchor, constant: -20),
            
            bottomLabel.centerXAnchor.constraint(equalTo: waterBottomView.centerXAnchor),
            bottomLabel.centerYAnchor.constraint(equalTo: waterBottomView.centerYAnchor, constant: 20)
        ])
        
        // 给下半部分的标签添加上下翻转效果
        bottomLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    private func setupWaveLayers() {
        // 设置上半部分波浪
        waveLayer.fillColor = waveColor.withAlphaComponent(0.3).cgColor
        waveLayer.strokeColor = waveColor.withAlphaComponent(0.5).cgColor
        waveLayer.lineWidth = 1
        waterTopView.layer.mask = waveLayer
        
        // 设置下半部分波浪（倒影）
        reflectionLayer.fillColor = waveColor.withAlphaComponent(0.2).cgColor
        reflectionLayer.strokeColor = waveColor.withAlphaComponent(0.4).cgColor
        reflectionLayer.lineWidth = 1
        waterBottomView.layer.mask = reflectionLayer
        
        // 初次绘制波浪
        updateWavePath()
    }
    
    private func updateWavePath() {
        let width = waveContainer.bounds.width
        
        // 为上半部分创建波浪路径
        let topPath = UIBezierPath()
        topPath.move(to: CGPoint(x: 0, y: waterTopView.bounds.height))
        
        // 创建波浪
        var x: CGFloat = 0
        while x <= width {
            let y = waveHeight * sin((x / width) * .pi * waveFrequency + wavePhase)
            let point = CGPoint(x: x, y: waterTopView.bounds.height - y) // 从底部开始计算
            topPath.addLine(to: point)
            x += 1
        }
        
        // 闭合路径
        topPath.addLine(to: CGPoint(x: width, y: waterTopView.bounds.height))
        topPath.addLine(to: CGPoint(x: 0, y: waterTopView.bounds.height))
        topPath.close()
        
        // 更新上半部分波浪层
        waveLayer.path = topPath.cgPath
        
        // 为下半部分创建倒影波浪路径
        let bottomPath = UIBezierPath()
        bottomPath.move(to: CGPoint(x: 0, y: 0))
        
        // 创建倒影波浪（注意y坐标的计算方式不同）
        x = 0
        while x <= width {
            let y = waveHeight * sin((x / width) * .pi * waveFrequency + wavePhase)
            let point = CGPoint(x: x, y: y) // 从顶部开始计算
            bottomPath.addLine(to: point)
            x += 1
        }
        
        // 闭合路径
        bottomPath.addLine(to: CGPoint(x: width, y: 0))
        bottomPath.addLine(to: CGPoint(x: 0, y: 0))
        bottomPath.close()
        
        // 更新下半部分波浪层
        reflectionLayer.path = bottomPath.cgPath
    }
    
    // MARK: - 动作回调
    
    @objc private func heightSliderChanged() {
        waveHeight = CGFloat(heightSlider.value)
        updateWavePath()
    }
    
    @objc private func frequencySliderChanged() {
        waveFrequency = CGFloat(frequencySlider.value)
        updateWavePath()
    }
    
    @objc private func animateButtonTapped() {
        isAnimating.toggle()
        
        if isAnimating {
            animateButton.setTitle("停止动画", for: .normal)
            startAnimating()
        } else {
            animateButton.setTitle("开始动画", for: .normal)
            stopAnimating()
        }
    }
    
    // MARK: - 动画控制
    
    private func startAnimating() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateAnimation() {
        wavePhase += 0.05
        if wavePhase > .pi * 2 {
            wavePhase = 0
        }
        
        updateWavePath()
    }
    
    // MARK: - 视图布局
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateWavePath()
    }
    
    // MARK: - 视图生命周期
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimating()
    }
} 