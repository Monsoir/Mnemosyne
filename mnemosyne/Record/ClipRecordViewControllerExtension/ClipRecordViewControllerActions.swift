//
//  ClipRecordViewControllerActions.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import NSGIF
import FileManagerShortcutKit

extension ClipRecordViewController {
    @objc func actionBack() {
        dismissAndDeleteTmpIfNeeded()
    }
    
    @objc func actionTouchUpInside(sender: UIButton) {
        sender.alpha = 1.0
        
        if sender == btnTapRecord {
            recordStatus = recordStatus == .recording ? .recorded : .recording
        } else if sender == btnHoldRecord {
            recordStatus = .recorded
        }
    }
    
    @objc func actionTouchDown(sender: UIButton) {
        sender.alpha = 0.5
        
        if sender == btnHoldRecord {
            recordStatus = .recording
        }
    }
    
    @objc func actionTouchUpOutside(sender: UIButton) {
        sender.alpha = 1.0
        
        if recordStatus == .recording {
            recorder.stopRecording()
        }
        recordStatus = .cancelRecording
    }
    
    func resetRecording() {
        recorder.startReceivingEnvironment()
    }
    
    /// 开始录制
    func startRecording() {
        assetMeta = MNAssetMeta()
        assetMeta.type = .clip
        // 设置 assetMeta 在回调方法中
        recorder.startRecording(forDuration: TimeInterval(ClipRecord.recordDuration))
    }
    
    /// 结束录制
    func finishRecording() {
        recorder.stopRecording()
    }
    
    /// 取消录制
    func cancelRecording() {
        recordStatus = .notRecording
    }
    
    /// 改变录制方式
    @objc func actionChangeRecordMethod(sender: UIButton) {
        recordMethod = sender == btnTapToRecord ? .tap : .hold
    }
    
    /// 开关灯
    @objc func actionToggleLight(sender: UIButton) {
        recorder.toggleTorch()
    }
    
    @objc func actionFlipCamera(sender: UIButton) {
        recorder.switchCamera()
    }
    
    /// 录制结果处理
    @objc func actionDiscardRecorded(sender: UIButton) {
        // 删除已录制的
        recordStatus = .notRecording
        FileManagerShortcuts.deleteItemAt(URL(string: assetMeta.location)!) { (result) in
            #if DEBUG
                print("actionDiscardRecorded")
                print("\(result)")
            #endif
        }
    }
    
    /// 将视频转换为 GIF
    @objc func actionConvertToGIF(sender: UIButton) {
        saveFileAsGIF {
            DispatchQueue.main.async {
                self.dismissAndDeleteTmpIfNeeded()
            }
        }
    }
    
    /// 直接存储
    @objc func actionConfirmRecorded(sender: UIButton) {
        saveFileAsMOV {
            DispatchQueue.main.async {
                self.dismissAndDeleteTmpIfNeeded()
            }
        }
    }
    
    /// 支撑函数们
    
    /// Dismiss 当前 controller 并删除暂存文件
    func dismissAndDeleteTmpIfNeeded() {
        dismiss(animated: true) {
            self.deleteTmpIfNeeded()
        }
    }
    
    /// 删除暂存文件，若暂存文件存在
    func deleteTmpIfNeeded() {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: NSTemporaryDirectory())
            let urls: [URL] = {
                var temp: [URL] = []
                for file in files {
                    temp.append(URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).appendingPathComponent(file))
                }
                return temp
            }()
            
            FileManagerShortcuts.deleteItemsAt(urls) { (result) in
                #if DEBUG
                    print("deleteTmpIfNeeded")
                    print("\(result)")
                #endif
            }
            
        } catch {
            #if DEBUG
                print("\(error.localizedDescription)")
            #endif
        }
    }
    
    /// 将文件存储为视频形式
    func saveFileAsMOV(completion: @escaping () -> Void) {
        let srcURL = URL(string: assetMeta.location)
        let fileNameWithExtension = srcURL?.lastPathComponent
        let destURL = FolderURL.clipURL.appendingPathComponent(fileNameWithExtension!)
        
        FileManagerShortcuts.moveItemAt(srcURL!, to: destURL) { (result) in
            #if DEBUG
                print("saveFileAsMOV")
                print("\(result)")
            #endif
            completion()
        }
    }
    
    /// 将视频文件转为 GIF 并进行存储
    func saveFileAsGIF(completion: @escaping () -> Void) {
        let srcURL = URL(string: assetMeta.location)
        let asset = assetMeta
        NSGIF.optimalGIFfromURL(srcURL, loopCount: 0) { (tempURL) in
            let extensionName = tempURL?.pathExtension
            let destURL: URL = {
                let temp = FolderURL.clipURL.appendingPathComponent(asset.identifier).appendingPathExtension(extensionName!)
                return temp
            }()
            
            FileManagerShortcuts.moveItemAt(tempURL!, to: destURL, completion: { (result) in
                #if DEBUG
                    print("saveFileAsGIF")
                    print("\(result)")
                #endif
                completion()
            })
        }
    }
}
