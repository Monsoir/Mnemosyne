//
//  ClipRecordViewControllerKVO.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

extension ClipRecordViewController {
    
    @objc func recordingStatusDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
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
    
    @objc func recordMethodDidChange(change: [NSKeyValueChangeKey : Any]?) {
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
        
        fakeNavigationBar.updateLayout(layouter: ClipRecordFakeNavigationBarLayout(views: view, constants: (nil, 0)))
        
        progressLayer.path = nil
    }
    
    /// 正在录制时的 UI 设置
    func updateRecordingUI() {
        btnTapToRecord.isEnabled = false
        btnTapToRecord.alpha = recordMethod == .tap ? DeactivatedAlpha : 0
        btnHoldToRecord.isEnabled = false
        btnHoldToRecord.alpha = recordMethod == .hold ? DeactivatedAlpha : 0
        lbRecordStatus.text = NSLocalizedString("StatusRecording", comment: "")
        
        fakeNavigationBar.updateLayout(layouter: ClipRecordFakeNavigationBarLayout(views: view, constants: (nil, CGFloat(-BarHeight))))
        
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
        fakeNavigationBar.updateLayout(layouter: ClipRecordFakeNavigationBarLayout(views: view, constants: (nil, 0)))
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
