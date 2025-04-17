//
//  TransitionAnimationViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class TransitionAnimationViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 过渡类型选择
    private let transitionSegmentedControl = UISegmentedControl()
    private let transitionNames = ["淡入淡出", "缩放", "滑动", "底部移入", "不对称过渡"]
    private var selectedTransition = 0
    
    // 卡片视图
    private let cardContainerView = UIView()
    private let placeholderCard = UIView()
    private let contentCard = UIView()
    private let cardButton = UIButton(type: .system)
    private var showCard = false
    
    // 通知视图
    private let notificationView = UIView()
    private var showNotification = false
    
    // 模态视图
    private let modalContainerView = UIView()
    private let modalContentView = UIView()
    private let dimmedView = UIView()
    private var showModal = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
        setupModalViews()
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
        titleLabel.text = "过渡动画效果"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 过渡类型选择器
        for (index, name) in transitionNames.enumerated() {
            transitionSegmentedControl.insertSegment(withTitle: name, at: index, animated: false)
        }
        transitionSegmentedControl.selectedSegmentIndex = 0
        transitionSegmentedControl.addTarget(self, action: #selector(transitionTypeChanged), for: .valueChanged)
        transitionSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(transitionSegmentedControl)
        
        // 卡片过渡标题
        let cardTitle = UILabel()
        cardTitle.text = "卡片过渡"
        cardTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        cardTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardTitle)
        
        // 卡片容器
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardContainerView)
        
        // 占位卡片
        placeholderCard.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
        placeholderCard.layer.cornerRadius = 10
        placeholderCard.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.addSubview(placeholderCard)
        
        // 内容卡片
        contentCard.backgroundColor = .systemBlue
        contentCard.layer.cornerRadius = 10
        contentCard.translatesAutoresizingMaskIntoConstraints = false
        contentCard.isHidden = true
        cardContainerView.addSubview(contentCard)
        
        // 卡片内容标签
        let cardContentLabel = UILabel()
        cardContentLabel.text = "卡片内容"
        cardContentLabel.textColor = .white
        cardContentLabel.textAlignment = .center
        cardContentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentCard.addSubview(cardContentLabel)
        
        // 卡片按钮
        cardButton.setTitle("显示卡片", for: .normal)
        cardButton.addTarget(self, action: #selector(cardButtonTapped), for: .touchUpInside)
        cardButton.layer.borderWidth = 1
        cardButton.layer.borderColor = UIColor.systemBlue.cgColor
        cardButton.layer.cornerRadius = 8
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardButton)
        
        // 通知按钮
        let notificationButton = UIButton(type: .system)
        notificationButton.setTitle("显示通知", for: .normal)
        notificationButton.addTarget(self, action: #selector(showNotificationTapped), for: .touchUpInside)
        notificationButton.layer.borderWidth = 1
        notificationButton.layer.borderColor = UIColor.systemBlue.cgColor
        notificationButton.layer.cornerRadius = 8
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(notificationButton)
        
        // 模态按钮
        let modalButton = UIButton(type: .system)
        modalButton.setTitle("显示模态", for: .normal)
        modalButton.addTarget(self, action: #selector(modalButtonTapped), for: .touchUpInside)
        modalButton.backgroundColor = .systemBlue
        modalButton.setTitleColor(.white, for: .normal)
        modalButton.layer.cornerRadius = 8
        modalButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(modalButton)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            transitionSegmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            transitionSegmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            transitionSegmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            cardTitle.topAnchor.constraint(equalTo: transitionSegmentedControl.bottomAnchor, constant: 30),
            cardTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            cardContainerView.topAnchor.constraint(equalTo: cardTitle.bottomAnchor, constant: 20),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardContainerView.heightAnchor.constraint(equalToConstant: 150),
            
            placeholderCard.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            placeholderCard.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            placeholderCard.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            placeholderCard.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            
            contentCard.topAnchor.constraint(equalTo: cardContainerView.topAnchor),
            contentCard.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
            contentCard.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
            contentCard.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor),
            
            cardContentLabel.centerXAnchor.constraint(equalTo: contentCard.centerXAnchor),
            cardContentLabel.centerYAnchor.constraint(equalTo: contentCard.centerYAnchor),
            
            cardButton.topAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: 20),
            cardButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cardButton.widthAnchor.constraint(equalToConstant: 120),
            cardButton.heightAnchor.constraint(equalToConstant: 40),
            
            notificationButton.topAnchor.constraint(equalTo: cardButton.bottomAnchor, constant: 30),
            notificationButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            notificationButton.widthAnchor.constraint(equalToConstant: 120),
            notificationButton.heightAnchor.constraint(equalToConstant: 40),
            
            modalButton.topAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: 30),
            modalButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            modalButton.widthAnchor.constraint(equalToConstant: 120),
            modalButton.heightAnchor.constraint(equalToConstant: 40),
            modalButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupNotificationView() {
        // 通知视图
        notificationView.backgroundColor = .systemGreen
        notificationView.layer.cornerRadius = 8
        notificationView.alpha = 0
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notificationView)
        
        // 通知图标
        let bellImageView = UIImageView()
        if let image = UIImage(systemName: "bell.fill") {
            bellImageView.image = image
            bellImageView.tintColor = .white
            bellImageView.contentMode = .scaleAspectFit
        }
        bellImageView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(bellImageView)
        
        // 通知文本
        let notificationLabel = UILabel()
        notificationLabel.text = "这是一条通知消息"
        notificationLabel.textColor = .white
        notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(notificationLabel)
        
        // 关闭按钮
        let closeButton = UIButton(type: .system)
        if let image = UIImage(systemName: "xmark") {
            closeButton.setImage(image, for: .normal)
            closeButton.tintColor = .white
        }
        closeButton.addTarget(self, action: #selector(closeNotificationTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(closeButton)
        
        // 通知视图约束
        NSLayoutConstraint.activate([
            notificationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            notificationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notificationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            notificationView.heightAnchor.constraint(equalToConstant: 50),
            
            bellImageView.leadingAnchor.constraint(equalTo: notificationView.leadingAnchor, constant: 16),
            bellImageView.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            bellImageView.widthAnchor.constraint(equalToConstant: 24),
            bellImageView.heightAnchor.constraint(equalToConstant: 24),
            
            notificationLabel.leadingAnchor.constraint(equalTo: bellImageView.trailingAnchor, constant: 12),
            notificationLabel.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: notificationView.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: notificationView.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupModalViews() {
        // 添加遮罩和模态容器到主视图
        view.addSubview(dimmedView)
        view.addSubview(modalContentView)
        
        // 遮罩视图
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmedView.alpha = 0
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissModal))
        dimmedView.addGestureRecognizer(tapGesture)
        
        // 模态内容视图
        modalContentView.backgroundColor = .white
        modalContentView.layer.cornerRadius = 15
        modalContentView.layer.shadowColor = UIColor.black.cgColor
        modalContentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        modalContentView.layer.shadowRadius = 10
        modalContentView.layer.shadowOpacity = 0.3
        modalContentView.alpha = 0
        modalContentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        modalContentView.translatesAutoresizingMaskIntoConstraints = false
        
        // 模态标题
        let modalTitleLabel = UILabel()
        modalTitleLabel.text = "模态内容"
        modalTitleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        modalTitleLabel.textAlignment = .center
        modalTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        modalContentView.addSubview(modalTitleLabel)
        
        // 模态提示标签
        let modalHintLabel = UILabel()
        modalHintLabel.text = "点击背景关闭"
        modalHintLabel.textColor = .secondaryLabel
        modalHintLabel.textAlignment = .center
        modalHintLabel.translatesAutoresizingMaskIntoConstraints = false
        modalContentView.addSubview(modalHintLabel)
        
        // 关闭按钮
        let closeModalButton = UIButton(type: .system)
        closeModalButton.setTitle("关闭", for: .normal)
        closeModalButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        closeModalButton.layer.borderWidth = 1
        closeModalButton.layer.borderColor = UIColor.systemBlue.cgColor
        closeModalButton.layer.cornerRadius = 8
        closeModalButton.translatesAutoresizingMaskIntoConstraints = false
        modalContentView.addSubview(closeModalButton)
        
        // 约束
        NSLayoutConstraint.activate([
            // 遮罩视图铺满整个屏幕
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // 模态内容视图居中
            modalContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalContentView.widthAnchor.constraint(equalToConstant: 300),
            modalContentView.heightAnchor.constraint(equalToConstant: 200),
            
            // 模态内容约束
            modalTitleLabel.topAnchor.constraint(equalTo: modalContentView.topAnchor, constant: 20),
            modalTitleLabel.centerXAnchor.constraint(equalTo: modalContentView.centerXAnchor),
            
            modalHintLabel.topAnchor.constraint(equalTo: modalTitleLabel.bottomAnchor, constant: 20),
            modalHintLabel.centerXAnchor.constraint(equalTo: modalContentView.centerXAnchor),
            
            closeModalButton.topAnchor.constraint(equalTo: modalHintLabel.bottomAnchor, constant: 20),
            closeModalButton.centerXAnchor.constraint(equalTo: modalContentView.centerXAnchor),
            closeModalButton.widthAnchor.constraint(equalToConstant: 100),
            closeModalButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    // MARK: - 动作回调
    
    @objc private func transitionTypeChanged() {
        selectedTransition = transitionSegmentedControl.selectedSegmentIndex
    }
    
    @objc private func cardButtonTapped() {
        showCard.toggle()
        
        if showCard {
            cardButton.setTitle("隐藏卡片", for: .normal)
            showCardWithTransition()
        } else {
            cardButton.setTitle("显示卡片", for: .normal)
            hideCardWithTransition()
        }
    }
    
    @objc private func showNotificationTapped() {
        showNotification = true
        showNotificationWithTransition()
        
        // 3秒后自动隐藏
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.closeNotificationTapped()
        }
    }
    
    @objc private func closeNotificationTapped() {
        showNotification = false
        hideNotificationWithTransition()
    }
    
    @objc private func modalButtonTapped() {
        showModal = true
        showModalWithTransition()
    }
    
    @objc private func dismissModal() {
        showModal = false
        hideModalWithTransition()
    }
    
    // MARK: - 过渡动画实现
    
    private func showCardWithTransition() {
        contentCard.isHidden = false
        
        // 根据选择的过渡类型执行动画
        switch selectedTransition {
        case 0: // 淡入淡出
            contentCard.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.contentCard.alpha = 1
            }
            
        case 1: // 缩放
            contentCard.alpha = 0
            contentCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
                self.contentCard.alpha = 1
                self.contentCard.transform = .identity
            }
            
        case 2: // 滑动
            contentCard.alpha = 0
            contentCard.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.contentCard.alpha = 1
                self.contentCard.transform = .identity
            }
            
        case 3: // 底部移入
            contentCard.alpha = 0
            contentCard.transform = CGAffineTransform(translationX: 0, y: 150)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.contentCard.alpha = 1
                self.contentCard.transform = .identity
            }
            
        case 4: // 不对称过渡
            contentCard.alpha = 0
            contentCard.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.contentCard.alpha = 1
                self.contentCard.transform = .identity
            }
            
        default:
            contentCard.alpha = 1
        }
    }
    
    private func hideCardWithTransition() {
        // 根据选择的过渡类型执行动画
        switch selectedTransition {
        case 0: // 淡入淡出
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.contentCard.alpha = 0
            }, completion: { _ in
                self.contentCard.isHidden = true
            })
            
        case 1: // 缩放
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: [], animations: {
                self.contentCard.alpha = 0
                self.contentCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }, completion: { _ in
                self.contentCard.isHidden = true
                self.contentCard.transform = .identity
            })
            
        case 2: // 滑动
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.contentCard.alpha = 0
                self.contentCard.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
            }, completion: { _ in
                self.contentCard.isHidden = true
                self.contentCard.transform = .identity
            })
            
        case 3: // 底部移入
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.contentCard.alpha = 0
                self.contentCard.transform = CGAffineTransform(translationX: 0, y: 150)
            }, completion: { _ in
                self.contentCard.isHidden = true
                self.contentCard.transform = .identity
            })
            
        case 4: // 不对称过渡
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.contentCard.alpha = 0
            }, completion: { _ in
                self.contentCard.isHidden = true
            })
            
        default:
            contentCard.isHidden = true
        }
    }
    
    private func showNotificationWithTransition() {
        // 重置通知视图状态
        notificationView.alpha = 0
        notificationView.transform = .identity
        
        // 根据选择的过渡类型执行动画
        switch selectedTransition {
        case 0: // 淡入淡出
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 1
            }
            
        case 1: // 缩放
            notificationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
                self.notificationView.alpha = 1
                self.notificationView.transform = .identity
            }
            
        case 2: // 滑动
            notificationView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 1
                self.notificationView.transform = .identity
            }
            
        case 3: // 底部移入
            notificationView.transform = CGAffineTransform(translationX: 0, y: -100)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 1
                self.notificationView.transform = .identity
            }
            
        case 4: // 不对称过渡
            notificationView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 1
                self.notificationView.transform = .identity
            }
            
        default:
            notificationView.alpha = 1
        }
    }
    
    private func hideNotificationWithTransition() {
        // 根据选择的过渡类型执行动画
        switch selectedTransition {
        case 0: // 淡入淡出
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 0
            }
            
        case 1: // 缩放
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
                self.notificationView.alpha = 0
                self.notificationView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            } completion: { _ in
                self.notificationView.transform = .identity
            }
            
        case 2: // 滑动
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 0
                self.notificationView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
            } completion: { _ in
                self.notificationView.transform = .identity
            }
            
        case 3: // 底部移入
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 0
                self.notificationView.transform = CGAffineTransform(translationX: 0, y: -100)
            } completion: { _ in
                self.notificationView.transform = .identity
            }
            
        case 4: // 不对称过渡
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.notificationView.alpha = 0
            }
            
        default:
            notificationView.alpha = 0
        }
    }
    
    private func showModalWithTransition() {
        // 显示遮罩
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 1
        }
        
        // 重置模态视图状态
        modalContentView.alpha = 0
        modalContentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        // 根据选择的过渡类型执行动画
        switch selectedTransition {
        case 0: // 淡入淡出
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 1
                self.modalContentView.transform = .identity
            }
            
        case 1: // 缩放
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
                self.modalContentView.alpha = 1
                self.modalContentView.transform = .identity
            }
            
        case 2: // 滑动
            modalContentView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 1
                self.modalContentView.transform = .identity
            }
            
        case 3: // 底部移入
            modalContentView.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 1
                self.modalContentView.transform = .identity
            }
            
        case 4: // 不对称过渡
            modalContentView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 1
                self.modalContentView.transform = .identity
            }
            
        default:
            modalContentView.alpha = 1
            modalContentView.transform = .identity
        }
    }
    
    private func hideModalWithTransition() {
        // 隐藏遮罩
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        }
        
        // 根据选择的过渡类型执行动画
        switch selectedTransition {
        case 0: // 淡入淡出
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 0
            }
            
        case 1: // 缩放
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 0
                self.modalContentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            
        case 2: // 滑动
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 0
                self.modalContentView.transform = CGAffineTransform(translationX: self.view.bounds.width, y: 0)
            }
            
        case 3: // 底部移入
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 0
                self.modalContentView.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            }
            
        case 4: // 不对称过渡
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
                self.modalContentView.alpha = 0
            }
            
        default:
            modalContentView.alpha = 0
        }
    }
} 
