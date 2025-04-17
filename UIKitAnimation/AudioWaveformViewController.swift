//
//  AudioWaveformViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class AudioWaveformViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 波形视图
    private let waveformContainerView = UIView()
    private var waveLines: [UIView] = []
    private let waveLineCount = 20
    
    // 控制按钮
    private let startButton = UIButton(type: .system)
    private let stopButton = UIButton(type: .system)
    private let modeButton = UIButton(type: .system)
    
    // 动画状态
    private var isAnimating = false
    private var displayLink: CADisplayLink?
    private var animationMode: AnimationMode = .equalizer
    
    // 动画类型
    enum AnimationMode {
        case equalizer
        case speech
        case recording
        
        var title: String {
            switch self {
            case .equalizer: return "频谱均衡器"
            case .speech: return "语音识别"
            case .recording: return "录音模式"
            }
        }
    }
    
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
        titleLabel.text = "音频波形动画"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 波形容器
        waveformContainerView.layer.cornerRadius = 12
        waveformContainerView.backgroundColor = UIColor.systemGray6
        waveformContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(waveformContainerView)
        
        // 创建波形线
        setupWaveLines()
        
        // 模式标签
        let modeLabel = UILabel()
        modeLabel.text = "当前模式："
        modeLabel.font = .systemFont(ofSize: 16)
        modeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modeLabel)
        
        // 模式按钮
        modeButton.setTitle(animationMode.title, for: .normal)
        modeButton.addTarget(self, action: #selector(modeButtonTapped), for: .touchUpInside)
        modeButton.backgroundColor = .systemBackground
        modeButton.layer.borderWidth = 1
        modeButton.layer.borderColor = UIColor.systemBlue.cgColor
        modeButton.layer.cornerRadius = 8
        modeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modeButton)
        
        // 按钮容器
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 20
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(buttonStackView)
        
        // 启动按钮
        startButton.setTitle("开始", for: .normal)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.backgroundColor = .systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 8
        
        // 停止按钮
        stopButton.setTitle("停止", for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        stopButton.backgroundColor = .systemGray
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.layer.cornerRadius = 8
        
        buttonStackView.addArrangedSubview(startButton)
        buttonStackView.addArrangedSubview(stopButton)
        
        // 说明标题
        let descriptionTitleLabel = UILabel()
        descriptionTitleLabel.text = "动画说明"
        descriptionTitleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionTitleLabel.textAlignment = .center
        descriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTitleLabel)
        
        // 说明文本
        let descriptionLabel = UILabel()
        descriptionLabel.text = "此动画模拟了三种常见的音频可视化效果：\n\n1. 频谱均衡器：模拟音乐播放器中的频谱分析效果\n2. 语音识别：模拟语音助手的声波响应模式\n3. 录音模式：模拟录音应用的音量波动效果\n\n点击模式按钮可以切换不同的动画效果。"
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            waveformContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            waveformContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            waveformContainerView.widthAnchor.constraint(equalToConstant: 300),
            waveformContainerView.heightAnchor.constraint(equalToConstant: 200),
            
            modeLabel.topAnchor.constraint(equalTo: waveformContainerView.bottomAnchor, constant: 30),
            modeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            modeButton.centerYAnchor.constraint(equalTo: modeLabel.centerYAnchor),
            modeButton.leadingAnchor.constraint(equalTo: modeLabel.trailingAnchor, constant: 10),
            modeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            modeButton.heightAnchor.constraint(equalToConstant: 36),
            
            buttonStackView.topAnchor.constraint(equalTo: modeLabel.bottomAnchor, constant: 30),
            buttonStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: 240),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionTitleLabel.topAnchor.constraint(equalTo: buttonStackView.bottomAnchor, constant: 30),
            descriptionTitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupWaveLines() {
        // 清除现有的线条
        waveLines.forEach { $0.removeFromSuperview() }
        waveLines.removeAll()
        
        // 线条之间的间距
        let spacing: CGFloat = 8
        let lineWidth: CGFloat = 7
        
        // 计算总宽度
        let totalWidth = CGFloat(waveLineCount) * lineWidth + CGFloat(waveLineCount - 1) * spacing
        let startX = (300 - totalWidth) / 2
        
        // 创建新的线条
        for i in 0..<waveLineCount {
            let line = UIView()
            line.backgroundColor = .systemBlue
            line.layer.cornerRadius = 2
            
            waveformContainerView.addSubview(line)
            line.translatesAutoresizingMaskIntoConstraints = false
            
            let x = startX + CGFloat(i) * (lineWidth + spacing)
            let randomHeight: CGFloat = 10 + CGFloat.random(in: 0...30)
            
            NSLayoutConstraint.activate([
                line.bottomAnchor.constraint(equalTo: waveformContainerView.centerYAnchor, constant: 50),
                line.leftAnchor.constraint(equalTo: waveformContainerView.leftAnchor, constant: x),
                line.widthAnchor.constraint(equalToConstant: lineWidth),
                line.heightAnchor.constraint(equalToConstant: randomHeight)
            ])
            
            waveLines.append(line)
        }
    }
    
    // MARK: - 动作回调
    
    @objc private func startButtonTapped() {
        if !isAnimating {
            isAnimating = true
            startButton.backgroundColor = .systemGray
            stopButton.backgroundColor = .systemRed
            startAnimating()
        }
    }
    
    @objc private func stopButtonTapped() {
        if isAnimating {
            isAnimating = false
            startButton.backgroundColor = .systemBlue
            stopButton.backgroundColor = .systemGray
            stopAnimating()
        }
    }
    
    @objc private func modeButtonTapped() {
        // 切换动画模式
        switch animationMode {
        case .equalizer:
            animationMode = .speech
        case .speech:
            animationMode = .recording
        case .recording:
            animationMode = .equalizer
        }
        
        // 更新按钮标题
        modeButton.setTitle(animationMode.title, for: .normal)
        
        // 如果正在动画，重新启动以应用新的模式
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }
    
    // MARK: - 动画控制
    
    private func startAnimating() {
        // 根据当前模式选择不同的波形样式
        switch animationMode {
        case .equalizer:
            startEqualizerAnimation()
        case .speech:
            startSpeechAnimation()
        case .recording:
            startRecordingAnimation()
        }
    }
    
    private func stopAnimating() {
        // 停止所有动画
        displayLink?.invalidate()
        displayLink = nil
        
        // 重置波形
        UIView.animate(withDuration: 0.3) {
            for line in self.waveLines {
                line.transform = .identity
            }
        }
    }
    
    private func startEqualizerAnimation() {
        // 创建和启动 CADisplayLink
        displayLink = CADisplayLink(target: self, selector: #selector(updateEqualizerAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateEqualizerAnimation() {
        // 频谱均衡器效果：每根线以不同的高度跳动
        UIView.animate(withDuration: 0.2) {
            for line in self.waveLines {
                let randomScale = CGFloat.random(in: 1.0...5.0)
                line.transform = CGAffineTransform(scaleX: 1.0, y: randomScale)
            }
        }
    }
    
    private func startSpeechAnimation() {
        // 语音识别波形动画：中间高两侧低的波浪形
        displayLink = CADisplayLink(target: self, selector: #selector(updateSpeechAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateSpeechAnimation() {
        // 生成一个以中间为高点的波形
        UIView.animate(withDuration: 0.3) {
            for (index, line) in self.waveLines.enumerated() {
                let distanceFromCenter = abs(index - self.waveLineCount / 2)
                let maxScale: CGFloat = 4.0
                let minScale: CGFloat = 1.0
                
                // 中央高，向两侧递减，加上随机因素
                let randomFactor = CGFloat.random(in: 0.8...1.2)
                let scale = max(minScale, maxScale - CGFloat(distanceFromCenter) * 0.5) * randomFactor
                
                line.transform = CGAffineTransform(scaleX: 1.0, y: scale)
            }
        }
    }
    
    private func startRecordingAnimation() {
        // 录音模式动画：所有条一起上下移动
        displayLink = CADisplayLink(target: self, selector: #selector(updateRecordingAnimation))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    private var recordingPhase: CGFloat = 0
    
    @objc private func updateRecordingAnimation() {
        recordingPhase += 0.05
        
        // 使用正弦波生成高度变化
        let baseScale = sin(recordingPhase) * 0.5 + 2.5
        
        UIView.animate(withDuration: 0.1) {
            for (index, line) in self.waveLines.enumerated() {
                // 添加些许随机变化，使波形更自然
                let randomFactor = CGFloat.random(in: 0.9...1.1)
                // 相邻线条有轻微相位差
                let phaseOffset = CGFloat(index) * 0.1
                let scale = (sin(self.recordingPhase + phaseOffset) * 0.5 + baseScale) * randomFactor
                
                line.transform = CGAffineTransform(scaleX: 1.0, y: scale)
            }
        }
    }
    
    // MARK: - 视图生命周期
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 停止动画
        stopAnimating()
    }
} 