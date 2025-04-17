//
//  CombinedAnimationViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class CombinedAnimationViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 动画控制状态
    private var isAnimating = false
    private var showingLoader = false
    private var showingNotification = false
    private var progress: CGFloat = 0.0
    
    // 加载动画
    private let loaderContainer = UIView()
    private let loaderView = LoaderView()
    private let loaderButton = UIButton(type: .system)
    
    // 进度条动画
    private let progressContainer = UIView()
    private let progressTrack = UIView()
    private let progressBar = UIView()
    private let resetButton = UIButton(type: .system)
    private let loadButton = UIButton(type: .system)
    private let stepButton = UIButton(type: .system)
    
    // 卡片翻转动画
    private let flipCardContainer = UIView()
    private let frontCardView = CardFrontView()
    private let backCardView = CardBackView()
    private let flipButton = UIButton(type: .system)
    private var isFlipped = false
    
    // 动感按钮
    private let animatedButton = UIButton(type: .system)
    
    // 通知视图
    private let notificationView = UIView()
    private let notificationIconView = UIImageView()
    private let notificationLabel = UILabel()
    private let notificationCloseButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
        setupNotificationView()
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
        titleLabel.text = "组合动画效果"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 加载动画部分
        setupLoaderSection()
        
        // 进度条动画部分
        setupProgressSection()
        
        // 卡片翻转部分
        setupFlipCardSection()
        
        // 动感按钮部分
        setupAnimatedButton()
        
        // 设置标题约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 加载动画容器约束
            loaderContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            loaderContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loaderContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 进度条容器约束
            progressContainer.topAnchor.constraint(equalTo: loaderContainer.bottomAnchor, constant: 20),
            progressContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // 卡片翻转容器约束
            flipCardContainer.topAnchor.constraint(equalTo: progressContainer.bottomAnchor, constant: 20),
            flipCardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            flipCardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            flipCardContainer.heightAnchor.constraint(equalToConstant: 200),
            
            // 动感按钮约束
            animatedButton.topAnchor.constraint(equalTo: flipCardContainer.bottomAnchor, constant: 30),
            animatedButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            animatedButton.heightAnchor.constraint(equalToConstant: 50),
            animatedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupLoaderSection() {
        loaderContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loaderContainer)
        
        // 标题
        let loaderTitle = UILabel()
        loaderTitle.text = "自定义加载动画"
        loaderTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        loaderTitle.textAlignment = .center
        loaderTitle.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.addSubview(loaderTitle)
        
        // 加载视图
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.isHidden = true
        loaderContainer.addSubview(loaderView)
        
        // 控制按钮
        loaderButton.setTitle("显示加载器", for: .normal)
        loaderButton.addTarget(self, action: #selector(toggleLoader), for: .touchUpInside)
        loaderButton.layer.borderWidth = 1
        loaderButton.layer.borderColor = UIColor.systemBlue.cgColor
        loaderButton.layer.cornerRadius = 8
        loaderButton.translatesAutoresizingMaskIntoConstraints = false
        loaderContainer.addSubview(loaderButton)
        
        NSLayoutConstraint.activate([
            loaderTitle.topAnchor.constraint(equalTo: loaderContainer.topAnchor),
            loaderTitle.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            
            loaderView.topAnchor.constraint(equalTo: loaderTitle.bottomAnchor, constant: 20),
            loaderView.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 100),
            loaderView.heightAnchor.constraint(equalToConstant: 100),
            
            loaderButton.topAnchor.constraint(equalTo: loaderView.bottomAnchor, constant: 20),
            loaderButton.centerXAnchor.constraint(equalTo: loaderContainer.centerXAnchor),
            loaderButton.widthAnchor.constraint(equalToConstant: 120),
            loaderButton.heightAnchor.constraint(equalToConstant: 36),
            loaderButton.bottomAnchor.constraint(equalTo: loaderContainer.bottomAnchor)
        ])
    }
    
    private func setupProgressSection() {
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(progressContainer)
        
        // 标题
        let progressTitle = UILabel()
        progressTitle.text = "进度条动画"
        progressTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        progressTitle.textAlignment = .center
        progressTitle.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(progressTitle)
        
        // 进度条轨道
        progressTrack.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        progressTrack.layer.cornerRadius = 10
        progressTrack.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(progressTrack)
        
        // 进度条填充
        progressBar.layer.cornerRadius = 10
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        // 创建渐变层
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        progressBar.layer.insertSublayer(gradientLayer, at: 0)
        progressTrack.addSubview(progressBar)
        
        // 按钮容器
        let buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 15
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        progressContainer.addSubview(buttonStackView)
        
        // 按钮
        resetButton.setTitle("重置", for: .normal)
        resetButton.addTarget(self, action: #selector(resetProgress), for: .touchUpInside)
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.systemBlue.cgColor
        resetButton.layer.cornerRadius = 8
        
        loadButton.setTitle("加载", for: .normal)
        loadButton.addTarget(self, action: #selector(loadProgress), for: .touchUpInside)
        loadButton.layer.borderWidth = 1
        loadButton.layer.borderColor = UIColor.systemBlue.cgColor
        loadButton.layer.cornerRadius = 8
        
        stepButton.setTitle("步进", for: .normal)
        stepButton.addTarget(self, action: #selector(stepProgress), for: .touchUpInside)
        stepButton.layer.borderWidth = 1
        stepButton.layer.borderColor = UIColor.systemBlue.cgColor
        stepButton.layer.cornerRadius = 8
        
        buttonStackView.addArrangedSubview(resetButton)
        buttonStackView.addArrangedSubview(loadButton)
        buttonStackView.addArrangedSubview(stepButton)
        
        NSLayoutConstraint.activate([
            progressTitle.topAnchor.constraint(equalTo: progressContainer.topAnchor),
            progressTitle.centerXAnchor.constraint(equalTo: progressContainer.centerXAnchor),
            
            progressTrack.topAnchor.constraint(equalTo: progressTitle.bottomAnchor, constant: 20),
            progressTrack.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor, constant: 20),
            progressTrack.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor, constant: -20),
            progressTrack.heightAnchor.constraint(equalToConstant: 20),
            
            progressBar.leadingAnchor.constraint(equalTo: progressTrack.leadingAnchor),
            progressBar.topAnchor.constraint(equalTo: progressTrack.topAnchor),
            progressBar.bottomAnchor.constraint(equalTo: progressTrack.bottomAnchor),
            // 宽度将在updateProgressBar方法中动态设置
            
            buttonStackView.topAnchor.constraint(equalTo: progressTrack.bottomAnchor, constant: 20),
            buttonStackView.leadingAnchor.constraint(equalTo: progressContainer.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: progressContainer.trailingAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 36),
            buttonStackView.bottomAnchor.constraint(equalTo: progressContainer.bottomAnchor)
        ])
    }
    
    private func setupFlipCardSection() {
        flipCardContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(flipCardContainer)
        
        // 标题
        let cardTitle = UILabel()
        cardTitle.text = "卡片翻转"
        cardTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        cardTitle.textAlignment = .center
        cardTitle.translatesAutoresizingMaskIntoConstraints = false
        flipCardContainer.addSubview(cardTitle)
        
        // 卡片容器视图
        let cardContainerView = UIView()
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        flipCardContainer.addSubview(cardContainerView)
        
        // 添加正面卡片和背面卡片
        frontCardView.translatesAutoresizingMaskIntoConstraints = false
        backCardView.translatesAutoresizingMaskIntoConstraints = false
        backCardView.isHidden = true
        cardContainerView.addSubview(frontCardView)
        cardContainerView.addSubview(backCardView)
        
        // 翻转按钮
        flipButton.setTitle("翻转卡片", for: .normal)
        flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
        flipButton.layer.borderWidth = 1
        flipButton.layer.borderColor = UIColor.systemBlue.cgColor
        flipButton.layer.cornerRadius = 8
        flipButton.translatesAutoresizingMaskIntoConstraints = false
        flipCardContainer.addSubview(flipButton)
        
        NSLayoutConstraint.activate([
            cardTitle.topAnchor.constraint(equalTo: flipCardContainer.topAnchor),
            cardTitle.centerXAnchor.constraint(equalTo: flipCardContainer.centerXAnchor),
            
            cardContainerView.topAnchor.constraint(equalTo: cardTitle.bottomAnchor, constant: 10),
            cardContainerView.leadingAnchor.constraint(equalTo: flipCardContainer.leadingAnchor),
            cardContainerView.trailingAnchor.constraint(equalTo: flipCardContainer.trailingAnchor),
            cardContainerView.heightAnchor.constraint(equalToConstant: 120),
            
            frontCardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            frontCardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            frontCardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            frontCardView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            
            backCardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            backCardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            backCardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            backCardView.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            
            flipButton.topAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: 10),
            flipButton.centerXAnchor.constraint(equalTo: flipCardContainer.centerXAnchor),
            flipButton.widthAnchor.constraint(equalToConstant: 120),
            flipButton.heightAnchor.constraint(equalToConstant: 36),
            flipButton.bottomAnchor.constraint(equalTo: flipCardContainer.bottomAnchor)
        ])
    }
    
    private func setupAnimatedButton() {
        // 设置动感按钮
        animatedButton.setTitle("动感按钮", for: .normal)
        animatedButton.setTitleColor(.white, for: .normal)
        animatedButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        
        // 设置渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 10
        animatedButton.layer.insertSublayer(gradientLayer, at: 0)
        
        // 设置阴影
        animatedButton.layer.shadowColor = UIColor.systemBlue.withAlphaComponent(0.5).cgColor
        animatedButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        animatedButton.layer.shadowRadius = 8
        animatedButton.layer.shadowOpacity = 1
        
        animatedButton.layer.cornerRadius = 10
        animatedButton.addTarget(self, action: #selector(animatedButtonTapped), for: .touchUpInside)
        animatedButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(animatedButton)
        
        NSLayoutConstraint.activate([
            animatedButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setupNotificationView() {
        // 设置通知视图
        notificationView.backgroundColor = .systemGreen
        notificationView.layer.cornerRadius = 10
        notificationView.layer.shadowColor = UIColor.black.cgColor
        notificationView.layer.shadowOffset = CGSize(width: 0, height: 2)
        notificationView.layer.shadowRadius = 5
        notificationView.layer.shadowOpacity = 0.2
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.alpha = 0
        view.addSubview(notificationView)
        
        // 通知图标
        if let checkmarkImage = UIImage(systemName: "checkmark.circle.fill") {
            notificationIconView.image = checkmarkImage
            notificationIconView.tintColor = .white
            notificationIconView.contentMode = .scaleAspectFit
        }
        notificationIconView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(notificationIconView)
        
        // 通知文本
        notificationLabel.text = "操作成功！"
        notificationLabel.textColor = .white
        notificationLabel.font = .systemFont(ofSize: 15)
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(notificationLabel)
        
        // 关闭按钮
        if let closeImage = UIImage(systemName: "xmark") {
            notificationCloseButton.setImage(closeImage, for: .normal)
            notificationCloseButton.tintColor = .white
        }
        notificationCloseButton.addTarget(self, action: #selector(hideNotification), for: .touchUpInside)
        notificationCloseButton.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(notificationCloseButton)
        
        NSLayoutConstraint.activate([
            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notificationView.heightAnchor.constraint(equalToConstant: 50),
            
            notificationIconView.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 15),
            notificationIconView.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            notificationIconView.widthAnchor.constraint(equalToConstant: 24),
            notificationIconView.heightAnchor.constraint(equalToConstant: 24),
            
            notificationLabel.leadingAnchor.constraint(equalTo: notificationIconView.trailingAnchor, constant: 10),
            notificationLabel.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            
            notificationCloseButton.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -15),
            notificationCloseButton.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            notificationCloseButton.widthAnchor.constraint(equalToConstant: 24),
            notificationCloseButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 更新渐变层的位置
        if let gradientLayer = progressBar.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = progressBar.bounds
        }
        
        if let gradientLayer = animatedButton.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = animatedButton.bounds
        }
        
        updateProgressBar()
    }
    
    // MARK: - 动作回调
    
    @objc private func toggleLoader() {
        showingLoader.toggle()
        
        if showingLoader {
            loaderButton.setTitle("隐藏加载器", for: .normal)
            showLoaderWithAnimation()
        } else {
            loaderButton.setTitle("显示加载器", for: .normal)
            hideLoaderWithAnimation()
        }
    }
    
    @objc private func resetProgress() {
        progress = 0.0
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.updateProgressBar()
        }
    }
    
    @objc private func loadProgress() {
        progress = 1.0
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut) {
            self.updateProgressBar()
        }
    }
    
    @objc private func stepProgress() {
        progress = min(1.0, progress + 0.2)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
            self.updateProgressBar()
        }
    }
    
    @objc private func flipCard() {
        isFlipped.toggle()
        
        let transitionOptions: UIView.AnimationOptions = isFlipped ?
            [.transitionFlipFromRight] : [.transitionFlipFromLeft]
        
        UIView.transition(
            from: isFlipped ? frontCardView : backCardView,
            to: isFlipped ? backCardView : frontCardView,
            duration: 0.4,
            options: transitionOptions
        ) { _ in
            self.frontCardView.isHidden = self.isFlipped
            self.backCardView.isHidden = !self.isFlipped
        }
    }
    
    @objc private func animatedButtonTapped() {
        // 按下动画
        UIView.animate(withDuration: 0.1, animations: {
            self.animatedButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.animatedButton.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.animatedButton.layer.shadowRadius = 2
        }) { _ in
            // 恢复动画
            UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseOut) {
                self.animatedButton.transform = .identity
                self.animatedButton.layer.shadowOffset = CGSize(width: 0, height: 4)
                self.animatedButton.layer.shadowRadius = 8
            }
            
            // 显示通知
            self.showNotification()
            
            // 3秒后隐藏通知
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.hideNotification()
            }
        }
    }
    
    @objc private func hideNotification() {
        showingNotification = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.notificationView.alpha = 0
            self.notificationView.transform = CGAffineTransform(translationX: 0, y: -20)
        } completion: { _ in
            self.notificationView.transform = .identity
        }
    }
    
    // MARK: - 辅助方法
    
    private func showLoaderWithAnimation() {
        loaderView.isHidden = false
        loaderView.alpha = 0
        loaderView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
            self.loaderView.alpha = 1
            self.loaderView.transform = .identity
        }
        
        loaderView.startAnimating()
    }
    
    private func hideLoaderWithAnimation() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.loaderView.alpha = 0
            self.loaderView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            self.loaderView.isHidden = true
            self.loaderView.stopAnimating()
        }
    }
    
    private func updateProgressBar() {
        // 计算进度条宽度
        let maxWidth = progressTrack.bounds.width
        let barWidth = maxWidth * progress
        
        // 设置进度条宽度
        var frame = progressBar.frame
        frame.size.width = barWidth
        progressBar.frame = frame
    }
    
    private func showNotification() {
        showingNotification = true
        
        notificationView.transform = CGAffineTransform(translationX: 0, y: -20)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.notificationView.alpha = 1
            self.notificationView.transform = .identity
        }
    }
}

// MARK: - 加载动画视图
class LoaderView: UIView {
    
    private let circleLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let animationLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // 背景圆环
        circleLayer.lineWidth = 10
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
        layer.addSublayer(circleLayer)
        
        // 渐变层
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.addSublayer(gradientLayer)
        
        // 动画圆环
        animationLayer.lineWidth = 10
        animationLayer.fillColor = nil
        animationLayer.strokeColor = UIColor.black.cgColor
        animationLayer.lineCap = .round
        animationLayer.strokeStart = 0
        animationLayer.strokeEnd = 0.7
        gradientLayer.mask = animationLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 10
        
        // 背景圆环路径
        let circlePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        circleLayer.path = circlePath.cgPath
        circleLayer.frame = bounds
        
        // 动画圆环路径
        let animationPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        animationLayer.path = animationPath.cgPath
        
        // 渐变层位置
        gradientLayer.frame = bounds
    }
    
    func startAnimating() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = .infinity
        rotationAnimation.isRemovedOnCompletion = false
        
        animationLayer.add(rotationAnimation, forKey: "rotation")
    }
    
    func stopAnimating() {
        animationLayer.removeAllAnimations()
    }
}

// MARK: - 卡片视图
class CardFrontView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // 设置卡片背景
        layer.cornerRadius = 15
        
        // 创建渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 15
        layer.insertSublayer(gradientLayer, at: 0)
        
        // 添加文本
        let titleLabel = UILabel()
        titleLabel.text = "正面"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // 添加图标
        let iconImageView = UIImageView()
        if let image = UIImage(systemName: "star.fill") {
            iconImageView.image = image
            iconImageView.tintColor = .systemYellow
            iconImageView.contentMode = .scaleAspectFit
        }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
}

class CardBackView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // 设置卡片背景
        layer.cornerRadius = 15
        
        // 创建渐变背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemOrange.cgColor, UIColor.systemRed.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 15
        layer.insertSublayer(gradientLayer, at: 0)
        
        // 添加文本
        let titleLabel = UILabel()
        titleLabel.text = "背面"
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        // 添加图标
        let iconImageView = UIImageView()
        if let image = UIImage(systemName: "moon.fill") {
            iconImageView.image = image
            iconImageView.tintColor = .systemYellow
            iconImageView.contentMode = .scaleAspectFit
        }
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
} 