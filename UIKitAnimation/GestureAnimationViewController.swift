//
//  GestureAnimationViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class GestureAnimationViewController: UIViewController {
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // 拖拽卡片
    private let cardContainer = UIView()
    private let dragCard = UIView()
    private let dragLabel = UILabel()
    private var isDragging = false
    private var initialCardCenter: CGPoint = .zero
    
    // 缩放图片
    private let imageContainer = UIView()
    private let imageView = UIImageView()
    private let pinchLabel = UILabel()
    
    // 旋转图标
    private let rotateContainer = UIView()
    private let rotateCircle = UIView()
    private let rotateImageView = UIImageView()
    private let rotateLabel = UILabel()
    
    // 自由移动方块
    private let moveContainer = UIView()
    private let moveSquare = UIView()
    private let moveLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
        setupGestures()
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
        titleLabel.text = "手势动画效果"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        // 拖拽卡片部分
        let dragTitle = UILabel()
        dragTitle.text = "拖拽卡片"
        dragTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        dragTitle.textAlignment = .center
        dragTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dragTitle)
        
        cardContainer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
        cardContainer.layer.cornerRadius = 15
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardContainer)
        
        dragCard.backgroundColor = .systemBlue
        dragCard.layer.cornerRadius = 15
        dragCard.translatesAutoresizingMaskIntoConstraints = false
        cardContainer.addSubview(dragCard)
        
        dragLabel.text = "拖拽我"
        dragLabel.textColor = .white
        dragLabel.textAlignment = .center
        dragLabel.translatesAutoresizingMaskIntoConstraints = false
        dragCard.addSubview(dragLabel)
        
        // 缩放图片部分
        let pinchTitle = UILabel()
        pinchTitle.text = "缩放图片"
        pinchTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        pinchTitle.textAlignment = .center
        pinchTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pinchTitle)
        
        imageContainer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
        imageContainer.layer.cornerRadius = 10
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageContainer)
        
        if let image = UIImage(systemName: "photo") {
            imageView.image = image
            imageView.tintColor = .label
            imageView.contentMode = .scaleAspectFit
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(imageView)
        
        pinchLabel.text = "捏合缩放"
        pinchLabel.textColor = .secondaryLabel
        pinchLabel.textAlignment = .center
        pinchLabel.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(pinchLabel)
        
        // 旋转部分
        let rotateTitle = UILabel()
        rotateTitle.text = "旋转手势"
        rotateTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        rotateTitle.textAlignment = .center
        rotateTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rotateTitle)
        
        rotateContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rotateContainer)
        
        rotateCircle.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.2)
        rotateCircle.layer.cornerRadius = 70 // 设置为宽高的一半以形成圆形
        rotateCircle.translatesAutoresizingMaskIntoConstraints = false
        rotateContainer.addSubview(rotateCircle)
        
        if let image = UIImage(systemName: "arrow.triangle.2.circlepath") {
            rotateImageView.image = image
            rotateImageView.tintColor = .systemOrange
            rotateImageView.contentMode = .scaleAspectFit
        }
        rotateImageView.translatesAutoresizingMaskIntoConstraints = false
        rotateContainer.addSubview(rotateImageView)
        
        rotateLabel.text = "旋转我"
        rotateLabel.textColor = .secondaryLabel
        rotateLabel.textAlignment = .center
        rotateLabel.translatesAutoresizingMaskIntoConstraints = false
        rotateContainer.addSubview(rotateLabel)
        
        // 自由移动部分
        let moveTitle = UILabel()
        moveTitle.text = "自由移动"
        moveTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        moveTitle.textAlignment = .center
        moveTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moveTitle)
        
        moveContainer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
        moveContainer.layer.cornerRadius = 10
        moveContainer.clipsToBounds = true
        moveContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(moveContainer)
        
        moveSquare.backgroundColor = .systemPurple
        moveSquare.layer.cornerRadius = 10
        moveSquare.translatesAutoresizingMaskIntoConstraints = false
        moveContainer.addSubview(moveSquare)
        
        moveLabel.text = "移动"
        moveLabel.textColor = .white
        moveLabel.font = .systemFont(ofSize: 12)
        moveLabel.textAlignment = .center
        moveLabel.translatesAutoresizingMaskIntoConstraints = false
        moveSquare.addSubview(moveLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 拖拽卡片约束
            dragTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            dragTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            cardContainer.topAnchor.constraint(equalTo: dragTitle.bottomAnchor, constant: 10),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardContainer.heightAnchor.constraint(equalToConstant: 200),
            
            dragCard.centerXAnchor.constraint(equalTo: cardContainer.centerXAnchor),
            dragCard.centerYAnchor.constraint(equalTo: cardContainer.centerYAnchor),
            dragCard.widthAnchor.constraint(equalToConstant: 150),
            dragCard.heightAnchor.constraint(equalToConstant: 150),
            
            dragLabel.centerXAnchor.constraint(equalTo: dragCard.centerXAnchor),
            dragLabel.centerYAnchor.constraint(equalTo: dragCard.centerYAnchor),
            
            // 缩放图片约束
            pinchTitle.topAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: 20),
            pinchTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            imageContainer.topAnchor.constraint(equalTo: pinchTitle.bottomAnchor, constant: 10),
            imageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageContainer.heightAnchor.constraint(equalToConstant: 150),
            
            imageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            pinchLabel.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            pinchLabel.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -10),
            
            // 旋转手势约束
            rotateTitle.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 20),
            rotateTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            rotateContainer.topAnchor.constraint(equalTo: rotateTitle.bottomAnchor, constant: 10),
            rotateContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rotateContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rotateContainer.heightAnchor.constraint(equalToConstant: 180),
            
            rotateCircle.centerXAnchor.constraint(equalTo: rotateContainer.centerXAnchor),
            rotateCircle.topAnchor.constraint(equalTo: rotateContainer.topAnchor, constant: 20),
            rotateCircle.widthAnchor.constraint(equalToConstant: 140),
            rotateCircle.heightAnchor.constraint(equalToConstant: 140),
            
            rotateImageView.centerXAnchor.constraint(equalTo: rotateCircle.centerXAnchor),
            rotateImageView.centerYAnchor.constraint(equalTo: rotateCircle.centerYAnchor),
            rotateImageView.widthAnchor.constraint(equalToConstant: 40),
            rotateImageView.heightAnchor.constraint(equalToConstant: 40),
            
            rotateLabel.centerXAnchor.constraint(equalTo: rotateContainer.centerXAnchor),
            rotateLabel.bottomAnchor.constraint(equalTo: rotateContainer.bottomAnchor, constant: -10),
            
            // 自由移动约束
            moveTitle.topAnchor.constraint(equalTo: rotateContainer.bottomAnchor, constant: 20),
            moveTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            moveContainer.topAnchor.constraint(equalTo: moveTitle.bottomAnchor, constant: 10),
            moveContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moveContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moveContainer.heightAnchor.constraint(equalToConstant: 250),
            moveContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            moveSquare.widthAnchor.constraint(equalToConstant: 80),
            moveSquare.heightAnchor.constraint(equalToConstant: 80),
            // 不设置moveSquare的位置约束，因为它将在viewDidLayoutSubviews中设置
            
            moveLabel.centerXAnchor.constraint(equalTo: moveSquare.centerXAnchor),
            moveLabel.centerYAnchor.constraint(equalTo: moveSquare.centerYAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 初始化可移动方块的位置
        if moveSquare.center == .zero {
            moveSquare.center = CGPoint(x: moveContainer.bounds.midX, y: moveContainer.bounds.midY)
        }
    }
    
    private func setupGestures() {
        // 拖拽卡片手势
        let dragPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragGesture(_:)))
        dragCard.addGestureRecognizer(dragPanGesture)
        dragCard.isUserInteractionEnabled = true
        
        // 缩放图片手势
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        imageContainer.addGestureRecognizer(pinchGesture)
        imageContainer.isUserInteractionEnabled = true
        
        // 旋转手势
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        rotateContainer.addGestureRecognizer(rotationGesture)
        rotateContainer.isUserInteractionEnabled = true
        
        // 自由移动手势
        let movePanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleMovePanGesture(_:)))
        moveSquare.addGestureRecognizer(movePanGesture)
        moveSquare.isUserInteractionEnabled = true
    }
    
    // MARK: - 手势处理方法
    
    @objc private func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: cardContainer)
        
        switch gesture.state {
        case .began:
            initialCardCenter = dragCard.center
            isDragging = true
            UIView.animate(withDuration: 0.3) {
                self.dragCard.backgroundColor = .systemGreen
            }
            
        case .changed:
            dragCard.center = CGPoint(
                x: initialCardCenter.x + translation.x,
                y: initialCardCenter.y + translation.y
            )
            
        case .ended, .cancelled:
            isDragging = false
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
                self.dragCard.center = self.initialCardCenter
                self.dragCard.backgroundColor = .systemBlue
            }
            
        default:
            break
        }
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed:
            imageView.transform = CGAffineTransform(scaleX: gesture.scale, y: gesture.scale)
            
        case .ended:
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: []) {
                self.imageView.transform = .identity
            }
            
        default:
            break
        }
    }
    
    @objc private func handleRotationGesture(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .changed:
            rotateImageView.transform = CGAffineTransform(rotationAngle: gesture.rotation)
            
        case .ended:
            // 可以选择保持旋转角度或重置
             UIView.animate(withDuration: 0.3) {
                 self.rotateImageView.transform = .identity
             }
            
        default:
            break
        }
    }
    
    @objc private func handleMovePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: moveContainer)
        
        // 确保方块不会移出容器
        let halfWidth = moveSquare.bounds.width / 2
        let halfHeight = moveSquare.bounds.height / 2
        let containerWidth = moveContainer.bounds.width
        let containerHeight = moveContainer.bounds.height
        
        var newX = location.x
        var newY = location.y
        
        if newX < halfWidth {
            newX = halfWidth
        } else if newX > containerWidth - halfWidth {
            newX = containerWidth - halfWidth
        }
        
        if newY < halfHeight {
            newY = halfHeight
        } else if newY > containerHeight - halfHeight {
            newY = containerHeight - halfHeight
        }
        
        UIView.animate(withDuration: 0.1) {
            self.moveSquare.center = CGPoint(x: newX, y: newY)
        }
    }
} 
