//
//  BasicAnimationViewController.swift
//  UIKitAnimation
//
//  Created by 宁侠 on 2025/4/17.
//

import UIKit

class BasicAnimationViewController: UIViewController {
    
    // 动画视图
    private let scaleView = UIView()
    private let rotationView = UIView()
    private let opacityView = UIView()
    private let offsetView = UIView()
    private let colorView = UIView()
    private let morphView = UIView()
    private let textLabel = UILabel()
    
    // 状态变量
    private var scale: CGFloat = 1.0
    private var rotation: CGFloat = 0
    private var opacity: CGFloat = 1.0
    private var offset: CGFloat = 0
    private var colorChanged = false
    private var morphed = false
    private var textEnlarged = false
    
    // 滚动视图
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupScrollView()
        setupViews()
        setupButtons()
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
        let titleLabel = UILabel()
        titleLabel.text = "基础动画效果"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        
        // 缩放视图
        let scaleTitle = UILabel()
        scaleTitle.text = "缩放"
        scaleTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        scaleView.backgroundColor = .systemBlue
        scaleView.layer.cornerRadius = 10
        
        // 旋转视图
        let rotationTitle = UILabel()
        rotationTitle.text = "旋转"
        rotationTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        rotationView.backgroundColor = .systemGreen
        rotationView.layer.cornerRadius = 10
        
        // 透明度视图
        let opacityTitle = UILabel()
        opacityTitle.text = "透明度"
        opacityTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        opacityView.backgroundColor = .systemOrange
        opacityView.layer.cornerRadius = 10
        
        // 位移视图
        let offsetTitle = UILabel()
        offsetTitle.text = "位移"
        offsetTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        offsetView.backgroundColor = .systemPurple
        offsetView.layer.cornerRadius = 10
        
        // 颜色变化视图
        let colorTitle = UILabel()
        colorTitle.text = "颜色变化"
        colorTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        colorView.backgroundColor = .systemBlue
        colorView.layer.cornerRadius = 10
        
        // 添加颜色切换手势
        let colorTapGesture = UITapGestureRecognizer(target: self, action: #selector(colorViewTapped))
        colorView.addGestureRecognizer(colorTapGesture)
        colorView.isUserInteractionEnabled = true
        
        // 路径变形视图
        let morphTitle = UILabel()
        morphTitle.text = "形状变形"
        morphTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        morphView.backgroundColor = .systemYellow
        morphView.layer.cornerRadius = 10
        
        // 添加形状变形手势
        let morphTapGesture = UITapGestureRecognizer(target: self, action: #selector(morphViewTapped))
        morphView.addGestureRecognizer(morphTapGesture)
        morphView.isUserInteractionEnabled = true
        
        // 文本动画
        let textTitle = UILabel()
        textTitle.text = "文本动画"
        textTitle.font = .systemFont(ofSize: 18, weight: .semibold)
        
        textLabel.text = "UIKit 动画"
        textLabel.font = .systemFont(ofSize: 16, weight: .bold)
        textLabel.textColor = .systemBlue
        textLabel.textAlignment = .center
        
        // 添加文本动画手势
        let textTapGesture = UITapGestureRecognizer(target: self, action: #selector(textLabelTapped))
        textLabel.addGestureRecognizer(textTapGesture)
        textLabel.isUserInteractionEnabled = true
        
        let tapInstructionLabel = UILabel()
        tapInstructionLabel.text = "点击文本"
        tapInstructionLabel.font = .systemFont(ofSize: 12)
        tapInstructionLabel.textAlignment = .center
        
        // 添加视图到contentView
        contentView.addSubview(titleLabel)
        
        // 缩放部分
        contentView.addSubview(scaleTitle)
        contentView.addSubview(scaleView)
        contentView.addSubview(createButton(title: "缩放动画", action: #selector(scaleButtonTapped)))
        
        // 旋转部分
        contentView.addSubview(rotationTitle)
        contentView.addSubview(rotationView)
        contentView.addSubview(createButton(title: "旋转动画", action: #selector(rotationButtonTapped)))
        
        // 透明度部分
        contentView.addSubview(opacityTitle)
        contentView.addSubview(opacityView)
        contentView.addSubview(createButton(title: "透明度动画", action: #selector(opacityButtonTapped)))
        
        // 位移部分
        contentView.addSubview(offsetTitle)
        contentView.addSubview(offsetView)
        contentView.addSubview(createButton(title: "位移动画", action: #selector(offsetButtonTapped)))
        
        // 颜色变化部分
        contentView.addSubview(colorTitle)
        contentView.addSubview(colorView)
        
        // 形状变形部分
        contentView.addSubview(morphTitle)
        contentView.addSubview(morphView)
        
        // 文本动画部分
        contentView.addSubview(textTitle)
        contentView.addSubview(textLabel)
        contentView.addSubview(tapInstructionLabel)
        
        // 设置视图约束
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scaleTitle.translatesAutoresizingMaskIntoConstraints = false
        scaleView.translatesAutoresizingMaskIntoConstraints = false
        rotationTitle.translatesAutoresizingMaskIntoConstraints = false
        rotationView.translatesAutoresizingMaskIntoConstraints = false
        opacityTitle.translatesAutoresizingMaskIntoConstraints = false
        opacityView.translatesAutoresizingMaskIntoConstraints = false
        offsetTitle.translatesAutoresizingMaskIntoConstraints = false
        offsetView.translatesAutoresizingMaskIntoConstraints = false
        colorTitle.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        morphTitle.translatesAutoresizingMaskIntoConstraints = false
        morphView.translatesAutoresizingMaskIntoConstraints = false
        textTitle.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        tapInstructionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 排列视图并设置约束
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 缩放视图约束
            scaleTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            scaleTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scaleView.topAnchor.constraint(equalTo: scaleTitle.bottomAnchor, constant: 10),
            scaleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scaleView.widthAnchor.constraint(equalToConstant: 100),
            scaleView.heightAnchor.constraint(equalToConstant: 100),
            
            // 旋转视图约束
            rotationTitle.topAnchor.constraint(equalTo: scaleView.bottomAnchor, constant: 30),
            rotationTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            rotationView.topAnchor.constraint(equalTo: rotationTitle.bottomAnchor, constant: 10),
            rotationView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rotationView.widthAnchor.constraint(equalToConstant: 100),
            rotationView.heightAnchor.constraint(equalToConstant: 100),
            
            // 透明度视图约束
            opacityTitle.topAnchor.constraint(equalTo: rotationView.bottomAnchor, constant: 30),
            opacityTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            opacityView.topAnchor.constraint(equalTo: opacityTitle.bottomAnchor, constant: 10),
            opacityView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            opacityView.widthAnchor.constraint(equalToConstant: 100),
            opacityView.heightAnchor.constraint(equalToConstant: 100),
            
            // 位移视图约束
            offsetTitle.topAnchor.constraint(equalTo: opacityView.bottomAnchor, constant: 30),
            offsetTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            offsetView.topAnchor.constraint(equalTo: offsetTitle.bottomAnchor, constant: 10),
            offsetView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            offsetView.widthAnchor.constraint(equalToConstant: 100),
            offsetView.heightAnchor.constraint(equalToConstant: 100),
            
            // 颜色变化视图约束
            colorTitle.topAnchor.constraint(equalTo: offsetView.bottomAnchor, constant: 30),
            colorTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            colorView.topAnchor.constraint(equalTo: colorTitle.bottomAnchor, constant: 10),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 100),
            colorView.heightAnchor.constraint(equalToConstant: 100),
            
            // 形状变形视图约束
            morphTitle.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 30),
            morphTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            morphView.topAnchor.constraint(equalTo: morphTitle.bottomAnchor, constant: 10),
            morphView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            morphView.widthAnchor.constraint(equalToConstant: 100),
            morphView.heightAnchor.constraint(equalToConstant: 100),
            
            // 文本动画约束
            textTitle.topAnchor.constraint(equalTo: morphView.bottomAnchor, constant: 30),
            textTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: textTitle.bottomAnchor, constant: 10),
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.heightAnchor.constraint(equalToConstant: 44),
            
            tapInstructionLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 5),
            tapInstructionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            tapInstructionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupButtons() {
        // 按钮已在setupViews()中创建和布局
    }
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        button.backgroundColor = .systemBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 8
        
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // 找到相应动画视图
        var animationView: UIView?
        
        switch action {
        case #selector(scaleButtonTapped):
            animationView = scaleView
        case #selector(rotationButtonTapped):
            animationView = rotationView
        case #selector(opacityButtonTapped):
            animationView = opacityView
        case #selector(offsetButtonTapped):
            animationView = offsetView
        default:
            break
        }
        
        if let animationView = animationView {
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 10),
                button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
                button.heightAnchor.constraint(equalToConstant: 36)
            ])
        }
        
        return button
    }
    
    // MARK: - 动画回调方法
    
    @objc private func scaleButtonTapped() {
        scale = scale == 1.0 ? 1.5 : 1.0
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.scaleView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        }
    }
    
    @objc private func rotationButtonTapped() {
        rotation += CGFloat.pi / 2 // 旋转90度
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.rotationView.transform = CGAffineTransform(rotationAngle: self.rotation)
        }
    }
    
    @objc private func opacityButtonTapped() {
        opacity = opacity == 1.0 ? 0.2 : 1.0
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.opacityView.alpha = self.opacity
        }
    }
    
    @objc private func offsetButtonTapped() {
        offset = offset == 0 ? 100 : 0
        
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            self.offsetView.transform = CGAffineTransform(translationX: self.offset, y: 0)
        }
    }
    
    @objc private func colorViewTapped() {
        colorChanged.toggle()
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) {
            self.colorView.backgroundColor = self.colorChanged ? .systemRed : .systemBlue
        }
    }
    
    @objc private func morphViewTapped() {
        morphed.toggle()
        
        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            if self.morphed {
                self.morphView.layer.cornerRadius = 50 // 变成圆形
                self.morphView.backgroundColor = .systemGreen
            } else {
                self.morphView.layer.cornerRadius = 10 // 变回圆角矩形
                self.morphView.backgroundColor = .systemYellow
            }
        }.startAnimation()
    }
    
    @objc private func textLabelTapped() {
        textEnlarged.toggle()
        
        // 第一段动画：0-180°旋转
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            // 旋转到180°
            self.textLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }) { _ in
            // 第二段动画：180-360°旋转
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                // 旋转到360°
                self.textLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            }) { _ in
                // 两段旋转完成后，执行字体大小变化
                UIView.animate(withDuration: 0.3) {
                    if self.textEnlarged {
                        self.textLabel.font = .systemFont(ofSize: 30, weight: .bold)
                    } else {
                        self.textLabel.font = .systemFont(ofSize: 16, weight: .bold)
                        self.textLabel.transform = .identity
                    }
                }
            }
        }
    }
} 
