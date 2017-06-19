//
//  ClipRecordViewController.swift
//  mnemosyne
//
//  Created by Mon on 12/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import MediaRecordKit

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
let RecordMethodPrompt = NSLocalizedString("TapToRecord", comment: "")
let RecordMethod = ClipRecordMethod.tap

let StrokeWidth = CGFloat(3)
let DeactivatedAlpha = CGFloat(0.4)
let ActivatedAlpha = CGFloat(1.0)
let PanelHeight = CGFloat(120)
let BarHeight: Int = {
    let statusBarHeight = 20
    let navigationBarHeight = 44
    return statusBarHeight + navigationBarHeight
}()
let StrokeProgressAnimationName = "Stroke progress"

class ClipRecordViewController: UIViewController {
    
    /// 录制状态
    @objc dynamic var recordStatus = ClipRecordStatus.notRecording
    var recordStatusObserver: MNKeyValueObserver?
    
    /// 录制方法
    @objc dynamic var recordMethod = ClipRecordMethod.tap
    var recordMethodObserver: MNKeyValueObserver?
    
    let recorder: VideoRecorder = {
        let object = VideoRecorder()
        return object
    }()
    
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
    var progressStroker: UIBezierPath? = nil
    
    /// 点击录制按钮
    lazy var btnTapRecord: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .red
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchDown(sender:)), for: .touchDown)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpInside(sender:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpOutside(sender:)), for: .touchUpOutside)
        return view
    }()
    
    /// 按住录制按钮
    lazy var btnHoldRecord: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .red
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchDown(sender:)), for: .touchDown)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpInside(sender:)), for: .touchUpInside)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionTouchUpOutside(sender:)), for: .touchUpOutside)
        return view
    }()
    
    /// 当前录制按钮，已选定录制方式的那种
    weak var btnRecord: UIButton!
    
    /// 当前录制方式提示
    lazy var lbRecordMethod: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = RecordMethodPrompt
        return view
    }()
    
    /// 点击录制选项
    lazy var btnTapToRecord: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "tap-record").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionChangeRecordMethod(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 按住录制选项
    lazy var btnHoldToRecord: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "hold-record").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionChangeRecordMethod(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 亮灯
    lazy var btnLight: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "light").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionToggleLight(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 录制面板
    lazy var panel: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.layer.masksToBounds = true
        return view
    }()
    
    /// 录制完成后的处理操作面板
    lazy var processPanel: UIVisualEffectView = {
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
    
    /// 假的导航栏
    lazy var fakeNavigationBar: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.layer.masksToBounds = true
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
        setupRecorder()
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
