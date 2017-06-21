//
//  ClipRecordViewControllerSetups.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import AVFoundation

extension ClipRecordViewController {
    func setupSubviews() {
        view.backgroundColor = .white
        
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
        
        /// 切换摄像头按钮
        panel.contentView.addSubview(btnFlipCamera)
        
        /// 设置约束
        panel.makeLayout(layouter: ClipRecordPanelLayout(with: (view), constants: (ClipRecord.panelHeight, nil)))
        subEffectView.makeLayout(layouter: ClipRecordSubEffectLayout(with: (panel.contentView), constants: (10)))
        lbRecordMethod.makeLayout(layouter: ClipRecordMethodLayout(with: (subEffectView)))
        btnHoldRecord.makeLayout(layouter: ClipRecordBtnRecordLayout(with: (panel.contentView), constants: (-10, CGSize(width: btnRecordLength, height: btnRecordLength))))
        btnTapRecord.makeLayout(layouter: ClipRecordBtnRecordLayout(with: panel.contentView, constants: (-10, CGSize(width: btnRecordLength, height: btnRecordLength))))
        btnTapToRecord.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 0.3)))
        btnHoldToRecord.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 0.3 * 2)))
        btnLight.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 1.5)))
        btnFlipCamera.makeLayout(layouter: ClipRecordBtnToRecordLayout(views: (btnTapRecord), constants: (CGSize(width: btnRecordHeight, height: btnRecordHeight), 1.8)))
    }
    
    func setupProcessPanel() {
        
        /// 返回
        let btnBack: UIButton = {
            let view = UIButton(type: .system)
            view.setImage(#imageLiteral(resourceName: "process-back").withRenderingMode(.alwaysOriginal), for: .normal)
            view.addTarget(self, action: #selector(ClipRecordViewController.actionDiscardRecorded(sender:)), for: .touchUpInside)
            return view
        }()
        
        /// 将视频转换为 GIF
        let btnConvertToGIF: UIButton = {
            let view = UIButton(type: .system)
            view.setImage(#imageLiteral(resourceName: "gif").withRenderingMode(.alwaysOriginal), for: .normal)
            view.addTarget(self, action: #selector(ClipRecordViewController.actionConvertToGIF(sender:)), for: .touchUpInside)
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
        processPanel.contentView.addSubview(btnConvertToGIF)
        processPanel.contentView.addSubview(btnCheck)
        
        /// 创建约束
        processPanel.makeLayout(layouter: ClipRecordProcessPanelLayout(views: view, constants: (ClipRecord.panelHeight, ClipRecord.panelHeight)))
        
        let btnLength = 50
        btnBack.makeLayout(layouter: ClipRecordProcessBtnLayout(views: processPanel, constants: (CGSize(width: btnLength, height: btnLength), 0.5)))
        btnConvertToGIF.makeLayout(layouter: ClipRecordProcessBtnLayout(views: processPanel, constants: (CGSize(width: btnLength, height: btnLength), 1.0)))
        btnCheck.makeLayout(layouter: ClipRecordProcessBtnLayout(views: processPanel, constants: (CGSize(width: btnLength, height: btnLength), 1.5)))
    }
    
    func setupFakeNavigationBar() {
        
        view.addSubview(fakeNavigationBar)
        
        /// title
        let subEffectView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: fakeNavigationBar.effect as! UIBlurEffect))
        fakeNavigationBar.contentView.addSubview(subEffectView)
        subEffectView.contentView.addSubview(lbRecordStatus)
        
        /// 返回按钮
        let btnBack = UIButton(type: .system)
        btnBack.setBackgroundImage(#imageLiteral(resourceName: "back"), for: .normal)
        subEffectView.contentView.addSubview(btnBack)
        btnBack.addTarget(self, action: #selector(ClipRecordViewController.actionBack), for: .touchUpInside)
        
        /// 建立约束
        fakeNavigationBar.makeLayout(layouter: ClipRecordFakeNavigationBarLayout(views: view, constants: (CGFloat(ClipRecord.barHeight), nil)))
        
        subEffectView.snp.makeConstraints { (make) in
            make.edges.equalTo(fakeNavigationBar)
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
    
    func setupRecorder() {
        recorder.delegate = self
        recorder.prepareCapture { [unowned self, recorder] (success, error) in
            if success {
                recorder.captureSession?.startRunning()
                DispatchQueue.main.async {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: recorder.captureSession!)
                    previewLayer.frame = self.view.bounds
                    self.view.layer.insertSublayer(previewLayer, below: self.fakeNavigationBar.layer)
                }
            } else {
                print("\(error!.localizedDescription)")
            }
        }
    }
    
    func setupObserver() {
        recordStatusObserver = MNKeyValueObserver.observeObject(object: self as AnyObject, keyPath: #keyPath(recordStatus), target: self as AnyObject, selector: #selector(ClipRecordViewController.recordingStatusDidChange(change:)), options: [.initial, .new, .old])
        recordMethodObserver = MNKeyValueObserver.observeObject(object: self, keyPath: #keyPath(recordMethod), target: self, selector: #selector(ClipRecordViewController.recordMethodDidChange(change:)), options: [.initial, .new])
    }
    
    func unsetupObserver() {
        recordStatusObserver = nil
        recordMethodObserver = nil
    }
}
