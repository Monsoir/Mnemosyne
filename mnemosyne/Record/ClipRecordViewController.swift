//
//  ClipRecordViewController.swift
//  mnemosyne
//
//  Created by Mon on 12/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import MediaRecordKit
import AVFoundation

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
}

class ClipRecordViewController: UIViewController {
    
// MARK: UI - 控件
    
    // MARK: Layer
    
    /// 进度 layer
    let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = ClipRecord.progressStrokeWidth
        return layer
    }()
    
    /// 用来画进度的路径
    var progressStroker: UIBezierPath? = nil
    
    /// 录制中预览层
    var recordingPreviewLayer: AVCaptureVideoPreviewLayer? = nil
    
    /// 录制完成预览层
    var recordedPreviewLayer: AVPlayerLayer? = nil
    
    // MARK: View
    
    /// 退出录制
    lazy var btnBack: UIButton = {
        let view = UIButton(type: .system)
        view.setBackgroundImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
        view.backgroundColor = .white
        view.alpha = ClipRecord.buttonAlphaLevel1
        view.addTarget(self, action: #selector(ClipRecordViewController.actionBack), for: .touchUpInside)
        return view
    }()
    
    /// 录制按钮的容器，在上面将会绘制进度圈
    lazy var recordOperationContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
    
    /// 亮灯
    lazy var btnLight: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "light").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionToggleLight(sender:)), for: .touchUpInside)
        view.backgroundColor = .white
        view.alpha = ClipRecord.buttonAlphaLevel1
        return view
    }()
    
    /// 切换摄像头
    lazy var btnFlipCamera: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "flip-camera").withRenderingMode(.alwaysOriginal), for: .normal)
        view.addTarget(self, action: #selector(ClipRecordViewController.actionFlipCamera(sender:)), for: .touchUpInside)
        view.backgroundColor = .white
        view.alpha = ClipRecord.buttonAlphaLevel1
        return view
    }()
    
    /// 放弃录制结果
    lazy var btnDiscard: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "process-back").withRenderingMode(.alwaysOriginal), for: .normal)
        view.backgroundColor = .white
        view.alpha = ClipRecord.buttonAlphaLevel2
        view.addTarget(self, action: #selector(ClipRecordViewController.actionDiscardRecorded(sender:)), for: .touchUpInside)
        return view
    }()
    
    /// 转制成 GIF
    lazy var btnGIF: UIButton = {
        let view = UIButton(type: .system)
        view.backgroundColor = .white
        view.alpha = ClipRecord.buttonAlphaLevel2
        view.addTarget(self, action: #selector(ClipRecordViewController.actionConvertToGIF(sender:)), for: .touchUpInside)
        
        let attributedStringParagraphStyle = NSMutableParagraphStyle()
        attributedStringParagraphStyle.alignment = NSTextAlignment.center
        
        let attributedString = NSAttributedString(string: "GIF", attributes:[NSAttributedStringKey.foregroundColor:UIColor.black, NSAttributedStringKey.paragraphStyle:attributedStringParagraphStyle, NSAttributedStringKey.font:UIFont(name:"ChalkboardSE-Regular", size:32.0)!])
        view.setAttributedTitle(attributedString, for: .normal)
        
        return view
    }()
    
    /// 完成录制
    lazy var btnDone: UIButton = {
        let view = UIButton(type: .system)
        view.setImage(#imageLiteral(resourceName: "process-check").withRenderingMode(.alwaysOriginal), for: .normal)
        view.backgroundColor = .white
        view.alpha = ClipRecord.buttonAlphaLevel2
        view.addTarget(self, action: #selector(ClipRecordViewController.actionConfirmRecorded(sender:)), for: .touchUpInside)
        return view
    }()
    
// MARK: - 数据
    
    /// 录制状态
    @objc dynamic var recordStatus = ClipRecordStatus.notRecording
    var recordStatusObserver: MNKeyValueObserver?
    
    /// 视频录制器
    let recorder: VideoRecorder = {
        let object = VideoRecorder()
        return object
    }()
    
    /// 视频描述数据
    var assetMeta = MNAssetMeta()
    
    /// 预览线程
    let previewQ = DispatchQueue(label: "com.wenyongyang.mnemosyne.preview")
    
// MARK: - 系统方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubviews()
        setupRecorder()
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
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLayoutSubviews() {
        let theFrame = recordOperationContainer.frame
        if theFrame.origin.x > 0 {
            
            /// 半径
            let radius = theFrame.size.width / 2
            
            /// 设置 layer 的位置大小
            progressLayer.frame = recordOperationContainer.bounds
            
            /// 圆心
            let center: CGPoint = {
                let centerX = theFrame.size.width / 2
                let centerY = theFrame.size.height / 2
                return CGPoint(x: centerX, y: centerY)
            }()
            
            /// 设置 stroke 路径
            progressStroker = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(3 / 2 * Double.pi), endAngle: CGFloat(7 / 2 * Double.pi), clockwise: true)
            recordOperationContainer.layer.insertSublayer(progressLayer, at: 0)
        }
    }
}
