//
//  ClipRecordViewController.swift
//  mnemosyne
//
//  Created by Mon on 12/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import SnapKit

fileprivate let StrokeWidth = CGFloat(3)

class ClipRecordViewController: UIViewController {
    
    /// 进度 layer
    let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = StrokeWidth
        return layer
    }()
    
    /// 录制按钮
    fileprivate lazy var btnRecord: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .red
        view.addTarget(self, action: #selector(ClipRecordViewController.actionRecord(sender:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(ClipRecordViewController.blur(sender:)), for: .touchDown)
        view.addTarget(self, action: #selector(ClipRecordViewController.restore(sender:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(ClipRecordViewController.restore(sender:)), for: .touchUpOutside)
        return view
    }()
    
    /// 录制面板
    fileprivate lazy var panel: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 录制状态标签
    lazy var lbRecordStatus: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("StatusNotRecording", comment: "")
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 20)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupFakeNavigationBar()
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let btnRecordFrame = btnRecord.frame
        if btnRecordFrame.origin.x > 0 {
            
            /// 半径
            let radius = btnRecordFrame.size.width / 2 + StrokeWidth
            
            /// 设置 layer 的位置大小
            progressLayer.frame = {
                let x = btnRecordFrame.minX - StrokeWidth
                let y = btnRecordFrame.minY - StrokeWidth
                let length = 2 * radius
                return CGRect(x: x, y: y, width: length, height: length)
            }()
            
            /// 圆心
            let center: CGPoint = {
                let centerX = btnRecordFrame.size.width / 2  + StrokeWidth
                let centerY = btnRecordFrame.size.height / 2 + StrokeWidth
                return CGPoint(x: centerX, y: centerY)
            }()
            
            /// 设置 stroke 路径
            let strokePath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(3 / 2 * Double.pi), endAngle: CGFloat(7 / 2 * Double.pi), clockwise: true)
            progressLayer.path = strokePath.cgPath
            
            panel.contentView.layer.addSublayer(progressLayer)
        }
    }
}

// MARK: - Views
extension ClipRecordViewController {
    func setupSubviews() {
        view.backgroundColor = .orange
        
        /// 底部面板
        let panelHeight = 150
        view.addSubview(panel)
        
        /// 录制按钮
        let btnRecordLength = 60
        btnRecord.layer.cornerRadius = CGFloat(btnRecordLength / 2)
        panel.contentView.addSubview(btnRecord)
        
        panel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.height.equalTo(panelHeight)
        }
        
        btnRecord.snp.makeConstraints { (make) in
            make.center.equalTo(panel)
            make.size.equalTo(CGSize(width: btnRecordLength, height: btnRecordLength))
        }
    }
    
    func setupFakeNavigationBar() {
        let barHeight: Int = {
            let statusBarHeight = 20
            let navigationBarHeight = 44
            return statusBarHeight + navigationBarHeight
        }()
        
        /// 底层模糊 view
        let bar = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        bar.layer.masksToBounds = true
        view.addSubview(bar)
        
        /// title
        let subEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: bar.effect as! UIBlurEffect))
        bar.contentView.addSubview(subEffectView)
        subEffectView.contentView.addSubview(lbRecordStatus)
        
        /// 返回按钮
        let btnBack = UIButton(type: .system)
        btnBack.setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal)
        subEffectView.contentView.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(ClipRecordViewController.actionBack), for: .touchUpInside)
        
        /// 建立约束
        bar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(barHeight)
        }
        
        subEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(bar)
        }
        
        lbRecordStatus.snp.makeConstraints { (make) in
            make.centerX.equalTo(subEffectView)
            make.centerY.equalTo(subEffectView).offset(5)
        }
        
        btnBack.snp.makeConstraints { (make) in
            make.centerY.equalTo(lbRecordStatus)
            make.left.equalTo(subEffectView).offset(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }
}

// MARK: - Actions
extension ClipRecordViewController {
    func actionBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func actionRecord(sender: UIButton) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 2
        progressLayer.strokeColor = UIColor.white.cgColor
        progressLayer.add(animation, forKey: "Stroke progress")
    }
    
    func blur(sender: UIButton) {
        sender.alpha = 0.5
    }
    
    func restore(sender: UIButton) {
        sender.alpha = 1.0
    }
}
