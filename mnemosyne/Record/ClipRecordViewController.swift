//
//  ClipRecordViewController.swift
//  mnemosyne
//
//  Created by Mon on 12/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import SnapKit

/// 录制视频方式
///
/// - tap: 点击录制
/// - hold: 按住录制
@objc enum ClipRecordMethod: Int {
    case tap
    case hold
}

/// 录制状态
///
/// - notRecording: 未开始录制
/// - recording: 录制中
/// - recorded: 录制完成
/// - cancelRecording: 取消录制
@objc enum ClipRecordStatus: Int {
    case notRecording
    case recording
    case recorded
    case cancelRecording
}

/// test constants
fileprivate let RecordMethodPrompt = NSLocalizedString("TapToRecord", comment: "")
fileprivate let RecordMethod = ClipRecordMethod.tap

fileprivate let StrokeWidth = CGFloat(3)
fileprivate let DeactivatedAlpha = CGFloat(0.4)
fileprivate let ActivatedAlpha = CGFloat(1.0)
fileprivate let PanelHeight = CGFloat(120)
fileprivate let StrokeProgressAnimationName = "Stroke progress"

class ClipRecordViewController: UIViewController {
    
    /// 录制状态
    @objc dynamic var recordStatus = ClipRecordStatus.notRecording
    var recordStatusObserver: MNKeyValueObserver?
    
    /// 录制方法
    @objc dynamic var recordMethod = ClipRecordMethod.tap
    var recordMethodObserver: MNKeyValueObserver?
    
    /// 进度 layer
    let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = StrokeWidth
        return layer
    }()
    
    /// 装载进度 layer 的 layer
    let progressContainerLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        return layer
    }()
    
    /// 用来画进度的路径
    fileprivate var progressStroker: UIBezierPath? = nil
    
    /// 点击录制按钮
    fileprivate lazy var btnTapRecord: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .red
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchDown(sender:)), for: .touchDown)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpInside(sender:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpOutside(sender:)), for: .touchUpOutside)
        return view
    }()
    
    /// 按住录制按钮
    fileprivate lazy var btnHoldRecord: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .red
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchDown(sender:)), for: .touchDown)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpInside(sender:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpOutside(sender:)), for: .touchUpOutside)
        return view
    }()
    
    /// 当前录制按钮，已选定录制方式的那种
    fileprivate weak var btnRecord: UIButton!
    
    /// 当前录制方式提示
    fileprivate lazy var lbRecordMethod: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = RecordMethodPrompt
        return view
    }()
    
    /// 点击录制选项
    fileprivate lazy var btnTapToRecord: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "tap-record").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionChangeRecordMethod(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 按住录制选项
    fileprivate lazy var btnHoldToRecord: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "hold-record").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionChangeRecordMethod(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 亮灯
    fileprivate lazy var btnLight: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "light").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionToggleLight(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 录制面板
    fileprivate lazy var panel: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 录制完成后的处理操作面板
    fileprivate lazy var processPanel: UIVisualEffectView = {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsetupObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        #if DEBUG
            print("\(type(of: self)) deinit")
        #endif
    }
    
    override func viewDidLayoutSubviews() {
        let btnRecordFrame = btnTapRecord.frame
        if btnRecordFrame.origin.x > 0 {
            
            /// 半径
            let radius = btnRecordFrame.size.width / 2 + StrokeWidth
            
            /// 设置 layer 的位置大小
            
            let frame: CGRect = {
                let x = btnRecordFrame.minX - StrokeWidth
                let y = btnRecordFrame.minY - StrokeWidth
                let length = 2 * radius
                return CGRect(x: x, y: y, width: length, height: length)
            }()
            
            progressContainerLayer.frame = frame
            progressLayer.frame = frame
            
            /// 圆心
            let center: CGPoint = {
                let centerX = btnRecordFrame.size.width / 2  + StrokeWidth
                let centerY = btnRecordFrame.size.height / 2 + StrokeWidth
                return CGPoint(x: centerX, y: centerY)
            }()
            
            let fillPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(3 / 2 * Double.pi), endAngle: CGFloat(7 / 2 * Double.pi), clockwise: true)
            progressContainerLayer.path = fillPath.cgPath
            
            /// 设置 stroke 路径
            progressStroker = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(3 / 2 * Double.pi), endAngle: CGFloat(7 / 2 * Double.pi), clockwise: true)
            
            /// 避免父视图的 subLayer 遮挡了 subView
            panel.contentView.layer.insertSublayer(progressContainerLayer, below: btnHoldRecord.layer)
            panel.contentView.layer.insertSublayer(progressLayer, below: btnHoldRecord.layer)
        }
    }
}

// MARK: - Views
extension ClipRecordViewController {
    func setupSubviews() {
        view.backgroundColor = .orange
        
        /// 底部面板
        view.addSubview(panel)
        
        /// 录制方法标签
        let subEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: panel.effect as! UIBlurEffect))
        panel.contentView.addSubview(subEffectView)
        subEffectView.contentView.addSubview(lbRecordMethod)
        
        let btnRecordLength = 60
        
        /// 按住录制按钮
        btnHoldRecord.layer.cornerRadius = CGFloat(btnRecordLength / 2)
        panel.contentView.addSubview(btnHoldRecord)
        
        /// 点击录制按钮
        btnTapRecord.layer.cornerRadius = CGFloat(btnRecordLength / 2)
        panel.contentView.addSubview(btnTapRecord)
        
        /// 录制方法选取按钮
        let btnRecordHeight = 30
        btnTapToRecord.layer.cornerRadius = CGFloat(btnRecordHeight / 2)
        btnTapToRecord.layer.borderWidth = 1
        btnTapToRecord.layer.borderColor = UIColor.black.cgColor
        btnHoldToRecord.layer.cornerRadius = CGFloat(btnRecordHeight / 2)
        btnHoldToRecord.layer.borderWidth = 1
        btnHoldToRecord.layer.borderColor = UIColor.black.cgColor
        panel.contentView.addSubview(btnTapToRecord)
        panel.contentView.addSubview(btnHoldToRecord)
        
        /// 亮灯按钮
        panel.contentView.addSubview(btnLight)
        
        /// 设置约束
        panel.makeLayout(layouter: ClipRecordPanelLayout(with: (view), constants: (PanelHeight, nil)))
        subEffectView.makeLayout(layouter: ClipRecordSubEffectLayout(with: (panel.contentView), constants: (10)))
        lbRecordMethod.makeLayout(layouter: ClipRecordMethodLayout(with: (subEffectView)))
        btnHoldRecord.makeLayout(layouter: ClipRecordBtnRecordLayout(with: (panel.contentView), constants: (-10, CGSize(width: btnRecordLength, height: btnRecordLength))))
        btnTapRecord.makeLayout(layouter: ClipRecordBtnRecordLayout(with: panel.contentView, constants: (-10, CGSize(width: btnRecordLength, height: btnRecordLength))))
        btnTapToRecord.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 0.3)))
        btnHoldToRecord.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 0.3 * 2)))
        btnLight.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 1.5)))
    }
    
    func setupProcessPanel() {
        
        /// 返回
        let btnBack: UIButton = {
            let view = UIButton(type: .system)
            view.setImage(#imageLiteral(resourceName: "process-back").withRenderingMode(.alwaysOriginal), for: .normal)
            view.addTarget(self, action: #selector(ClipRecordViewController.actionDiscardRecorded(sender:)), for: .touchUpInside)
            return view
        }()
        
        /// 确认
        let btnCheck: UIButton = {
            let view = UIButton(type: .system)
            view.setImage(#imageLiteral(resourceName: "process-check").withRenderingMode(.alwaysOriginal), for: .normal)
            view.addTarget(self, action: #selector(ClipRecordViewController.actionConfirmRecorded(sender:)), for: .touchUpInside)
            return view
        }()
        
        view.addSubview(processPanel)
        processPanel.contentView.addSubview(btnBack)
        processPanel.contentView.addSubview(btnCheck)
        
        /// 创建约束
        processPanel.contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(processPanel)
        }
        
        processPanel.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(PanelHeight)
            make.left.right.equalTo(view)
            make.height.equalTo(PanelHeight)
        }
        
        let btnLength = 50
        btnBack.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: btnLength, height: btnLength))
            make.centerY.equalTo(processPanel)
            make.centerX.equalTo(processPanel).multipliedBy(0.5)
        }
        
        btnCheck.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: btnLength, height: btnLength))
            make.centerY.equalTo(processPanel)
            make.centerX.equalTo(processPanel).multipliedBy(1.5)
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

// MARK: - KVO
extension ClipRecordViewController {
    func setupObserver() {
        recordStatusObserver = MNKeyValueObserver.observeObject(object: self as AnyObject, keyPath: #keyPath(recordStatus), target: self as AnyObject, selector: #selector(ClipRecordViewController.recordingStatusDidChange(change:)), options: [.initial, .new, .old])
        recordMethodObserver = MNKeyValueObserver.observeObject(object: self, keyPath: #keyPath(recordMethod), target: self, selector: #selector(ClipRecordViewController.recordMethodDidChange(change:)), options: [.initial, .new])
    }
    
    func unsetupObserver() {
        recordStatusObserver = nil
        recordMethodObserver = nil
    }
    
    func recordingStatusDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
        /// 页面第一次运行，忽略
        guard let _ = change?[.oldKey] else { return }
        
        guard let c = change else { return }
        
        let status = ClipRecordStatus(rawValue: c[.newKey] as! Int)!
        let oldStatus = ClipRecordStatus(rawValue: c[.oldKey] as! Int)
        if status == oldStatus { return }
        
        switch status {
            case .notRecording:
                DispatchQueue.main.async { self.updateNotRecordingUI() }
            case .recording:
                startRecording()
                DispatchQueue.main.async { self.updateRecordingUI() }
            case .recorded:
                finishRecording()
                DispatchQueue.main.async { self.updateFinishRecordingUI() }
            case .cancelRecording:
                cancelRecording()
        }
    }
    
    func recordMethodDidChange(change: [NSKeyValueChangeKey : Any]?) {
        guard let c = change else { return }
        
        let rm = ClipRecordMethod(rawValue: c[.newKey] as! Int)
        let isTap = rm == .tap
        DispatchQueue.main.async {
            self.btnTapRecord.isHidden = !isTap
            self.btnHoldRecord.isHidden = isTap
            self.btnRecord = isTap ? self.btnTapRecord : self.btnHoldRecord
            self.btnTapToRecord.alpha = isTap ? ActivatedAlpha : DeactivatedAlpha
            self.btnHoldToRecord.alpha = isTap ? DeactivatedAlpha : ActivatedAlpha
            self.lbRecordMethod.text = isTap ? NSLocalizedString("TapToRecord", comment: "") : NSLocalizedString("HoldToRecord", comment: "")
        }
    }
    
    /// 未进行录制的 UI 设置
    func updateNotRecordingUI() {
        /**
         更新内容包括：
         - 显示操作面板
         - 隐藏录制完成后的处理面板
         - 录制方式选取按钮的状态
         - 导航栏上的 title
         - 进度条
         **/
        
        togglePanel(on: true)
        
        lbRecordStatus.text = NSLocalizedString("StatusNotRecording", comment: "")
        btnTapToRecord.isEnabled = true
        btnTapToRecord.alpha = recordMethod == .tap ? ActivatedAlpha : DeactivatedAlpha
        btnHoldToRecord.isEnabled = true
        btnHoldToRecord.alpha = recordMethod == .hold ? ActivatedAlpha : DeactivatedAlpha
        
        progressLayer.path = nil
    }
    
    /// 正在录制时的 UI 设置
    func updateRecordingUI() {
        btnTapToRecord.isEnabled = false
        btnTapToRecord.alpha = recordMethod == .tap ? DeactivatedAlpha : 0
        btnHoldToRecord.isEnabled = false
        btnHoldToRecord.alpha = recordMethod == .hold ? DeactivatedAlpha : 0
        lbRecordStatus.text = NSLocalizedString("StatusRecording", comment: "")
        
        progressLayer.path = progressStroker!.cgPath
        progressLayer.strokeColor = UIColor.black.cgColor
        
        let animation: CABasicAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 2
            animation.delegate = self
            animation.isRemovedOnCompletion = false
            
            return animation
        }()
        progressLayer.add(animation, forKey: StrokeProgressAnimationName)
    }
    
    /// 录制完成时的 UI 设置
    func updateFinishRecordingUI() {
        /**
         更新内容包括：
         - 隐藏操作面板
         - 显示录制完成后的处理面板
         **/
        
        setupProcessPanelIfNeeded()
        togglePanel(on: false)
        lbRecordStatus.text = NSLocalizedString("StatusRecorded", comment: "")
    }
    
    fileprivate func togglePanel(on: Bool) {
        panel.updateLayout(layouter: ClipRecordPanelLayout(with: (view), constants: (nil, on ? 0 : PanelHeight)))
        
        setupProcessPanelIfNeeded()
        processPanel.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(on ? PanelHeight : 0)
        }
    }
    
    fileprivate func setupProcessPanelIfNeeded() {
        if !processPanel.isDescendant(of: view) {
            setupProcessPanel()
        }
    }
}

// MARK: - CAAnimationDelegate
extension ClipRecordViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // 识别目标动画 -> 进度动画
        if flag && anim == progressLayer.animation(forKey: StrokeProgressAnimationName) {
            if recordStatus == .recording { recordStatus = .recorded }
            progressLayer.removeAnimation(forKey: StrokeProgressAnimationName)
        }
    }
}

// MARK: - Actions
extension ClipRecordViewController {
    func actionBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func actionTouchUpInside(sender: UIButton) {
        sender.alpha = 1.0
        
        if sender == btnTapRecord {
            recordStatus = recordStatus == .recording ? .recorded : .recording
        } else if sender == btnHoldRecord {
            recordStatus = .recorded
        }
    }
    
    func actionTouchDown(sender: UIButton) {
        sender.alpha = 0.5
        
        if sender == btnHoldRecord {
            recordStatus = .recording
        }
    }
    
    func actionTouchUpOutside(sender: UIButton) {
        sender.alpha = 1.0
        
        if recordStatus == .recorded { return }
        recordStatus = .cancelRecording
    }
    
    func startRecording() {
        print("start recording")
    }
    
    func finishRecording() {
        print("stop recording")
    }
    
    func cancelRecording() {
        print("cancel recording")
        recordStatus = .notRecording
    }
    
    /// 改变录制方式
    func actionChangeRecordMethod(sender: UIButton) {
        recordMethod = sender == btnTapToRecord ? .tap : .hold
    }
    
    /// 开关灯
    func actionToggleLight(sender: UIButton) {
        recordStatus = .notRecording
    }
    
    /// 录制结果处理
    func actionDiscardRecorded(sender: UIButton) {
        recordStatus = .notRecording
    }
    
    func actionConfirmRecorded(sender: UIButton) {
        
    }
}
