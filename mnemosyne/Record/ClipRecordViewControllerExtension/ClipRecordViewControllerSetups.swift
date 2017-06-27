//
//  ClipRecordViewControllerSetups.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

extension ClipRecordViewController {
    func setupSubviews() {
        view.backgroundColor = .black
        
        view.addSubview(btnBack)
        view.addSubview(recordOperationContainer)
        recordOperationContainer.addSubview(btnHoldRecord)
        view.addSubview(btnFlipCamera)
        view.addSubview(btnLight)
        
        let btnLength = 50
        let containerLength = 70
        let btnSize = CGSize(width: btnLength, height: btnLength)
        let containerSize = CGSize(width: containerLength, height: containerLength)
        
        btnHoldRecord.layer.cornerRadius = CGFloat(btnLength / 2)
        btnHoldRecord.snp.makeConstraints { (make) in
            make.center.equalTo(recordOperationContainer)
            make.size.equalTo(btnSize)
        }
        
        recordOperationContainer.layer.cornerRadius = CGFloat(containerLength / 2)
        recordOperationContainer.snp.makeConstraints { (make) in
            make.size.equalTo(containerSize)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view).offset(-AppUIConstants.statusBarHeight)
        }
        
        btnBack.layer.cornerRadius = CGFloat(btnLength / 2)
        btnBack.snp.makeConstraints { (make) in
            make.size.equalTo(btnSize)
            make.centerX.equalTo(view).multipliedBy(0.3)
            make.centerY.equalTo(recordOperationContainer)
        }
        
        let accessoryLength = 45
        let margin = 5
        let accessorySize = CGSize(width: accessoryLength, height: accessoryLength)
        btnFlipCamera.layer.cornerRadius = CGFloat(accessoryLength / 2)
        btnFlipCamera.makeLayout(layouter: ClipRecordTopRightFirstBtnLayout(views: view, constants: (accessorySize, CGFloat(2 * margin + AppUIConstants.statusBarHeight), CGFloat(-margin))))
        
        btnLight.layer.cornerRadius = CGFloat(accessoryLength / 2)
        btnLight.makeLayout(layouter: ClipRecordTopRightRestBtnLayout(views: (view, btnFlipCamera), constants: (accessorySize, CGFloat(3 * margin), CGFloat(-margin))))
        
        view.addSubview(btnDiscard)
        view.addSubview(btnGIF)
        view.addSubview(btnDone)
        let bottomMargin = CGFloat(-2 * AppUIConstants.statusBarHeight)
        
        btnGIF.layer.cornerRadius = CGFloat(containerLength / 2)
        btnGIF.makeLayout(layouter: ClipRecordBottombtnLayout(views: view, constants: (containerSize, bottomMargin, CGFloat(1))))
        
        btnDiscard.layer.cornerRadius = CGFloat(containerLength / 2)
        btnDiscard.makeLayout(layouter: ClipRecordBottombtnLayout(views: view, constants: (containerSize, bottomMargin, CGFloat(0.3))))
        
        btnDone.layer.cornerRadius = CGFloat(containerLength / 2)
        btnDone.makeLayout(layouter: ClipRecordBottombtnLayout(views: view, constants: (containerSize, bottomMargin, CGFloat(1.7))))
    }
    
    func setupRecorder() {
        recorder.delegate = self
        recorder.prepareCapture { [unowned self, recorder] (success, error) in
            if success {
                recorder.captureSession?.startRunning()
                DispatchQueue.main.async {
                    let previewLayer = AVCaptureVideoPreviewLayer(session: recorder.captureSession!)
                    previewLayer.frame = self.view.bounds
                    self.recordingPreviewLayer = previewLayer;
                    self.view.layer.insertSublayer(self.recordingPreviewLayer!, at: 0)
                }
            } else {
                print("\(error!.localizedDescription)")
            }
        }
    }
    
    func setupObserver() {
        recordStatusObserver = MNKeyValueObserver.observeObject(object: self as AnyObject, keyPath: #keyPath(recordStatus), target: self as AnyObject, selector: #selector(ClipRecordViewController.recordingStatusDidChange(change:)), options: [.initial, .new, .old])
    }
    
    func unsetupObserver() {
        recordStatusObserver = nil
    }
}
