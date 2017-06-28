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
        guard let _ = change?[.oldKey] else {
            DispatchQueue.main.async { self.updateNotRecordingUI() }
            return
        }
        
        guard let c = change else { return }
        
        let status = ClipRecordStatus(rawValue: c[.newKey] as! Int)!
        let oldStatus = ClipRecordStatus(rawValue: c[.oldKey] as! Int)
        if status == oldStatus { return }
        
        switch status {
        case .notRecording:
            resetRecording()
            DispatchQueue.main.async { self.updateNotRecordingUI() }
        case .recording:
            startRecording()
            DispatchQueue.main.async { self.updateRecordingUI() }
        case .recorded:
            finishRecording()
            DispatchQueue.main.async { self.updateFinishRecordingUI() }
        }
    }
    
    /// 未进行录制的 UI 设置
    func updateNotRecordingUI() {
        make(them: [btnBack, recordOperationContainer, btnHoldRecord, btnFlipCamera, btnLight], enable: true)
        make(them: [btnDiscard, btnGIF, btnDone], enable: false)
        
        // 如果有录制完成后预览层，则移除
        if let p = recordedPreviewLayer {
            p.removeFromSuperlayer()
            recordedPreviewLayer = nil
        }
        
        // 如果有进度动画，撤销
        progressLayer.removeAnimation(forKey: ClipRecord.strokeProgressAnimationName)
        progressLayer.path = nil
    }
    
    /// 正在录制时的 UI 设置
    func updateRecordingUI() {
        make(them: [btnBack, btnFlipCamera, btnLight, btnDiscard, btnGIF, btnDone], enable: false)
        
        progressLayer.path = progressStroker!.cgPath
        progressLayer.strokeColor = UIColor.black.cgColor
        
        let animation: CABasicAnimation = {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = CFTimeInterval(ClipRecord.recordDuration)
            animation.delegate = self
            animation.isRemovedOnCompletion = false
            
            return animation
        }()
        progressLayer.add(animation, forKey: ClipRecord.strokeProgressAnimationName)
    }
    
    /// 录制完成时的 UI 设置
    func updateFinishRecordingUI() {
        make(them: [btnBack, recordOperationContainer, btnHoldRecord, btnFlipCamera, btnLight], enable: false)
        make(them: [btnDiscard, btnGIF, btnDone], enable: true)
    }
    
    fileprivate func make(them views: [UIView], enable able: Bool) {
        views.forEach { (aView) in
            aView.isHidden = !able
            if aView is UIButton {
                (aView as! UIButton).isEnabled = able
            }
        }
    }
}
