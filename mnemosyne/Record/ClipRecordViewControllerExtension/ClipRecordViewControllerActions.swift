//
//  ClipRecordViewControllerActions.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import Regift
import FileManagerShortcutKit

extension ClipRecordViewController {
    @objc func actionBack() {
        dismissAndDeleteTmpIfNeeded()
    }
    
    @objc func actionTouchUpInside(sender: UIButton) {
        sender.alpha = 1.0
        recordStatus = .recorded
    }
    
    @objc func actionTouchDown(sender: UIButton) {
        sender.alpha = 0.5
        recordStatus = .recording
    }
    
    @objc func actionTouchUpOutside(sender: UIButton) {
        sender.alpha = 1.0
        
        if recordStatus == .recording {
            recorder.stopRecording()
            recordStatus = .recorded
        }
    }
    
    func resetRecording() {
        recorder.startReceivingEnvironment()
    }
    
    /// 开始录制
    func startRecording() {
        assetMeta = MNAssetMeta()
        assetMeta.type = .clip
        // 设置 assetMeta 属性在回调方法中
        recorder.startRecording(forDuration: TimeInterval(ClipRecord.recordDuration))
    }
    
    /// 结束录制
    func finishRecording() {
        recorder.stopRecording()
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
        let destURL = FolderURL.clipVideoURL.appendingPathComponent(fileNameWithExtension!)
        
        var tempAssetMeta = self.assetMeta
        // 移动文件
        FileManagerShortcuts.moveItemAt(srcURL!, to: destURL) { (result) in
            #if DEBUG
                print("saveFileAsMOV")
                print("\(result)")
            #endif
            
            // 生成封面，存储到文件系统
            ClipUtils.thumbnailFromVideo(url: destURL, completion: { (thumbnail) in
                guard let thumbnail = thumbnail else { return }
                let thumbnailName = "\(tempAssetMeta.identifier)"
                let thumbnailPath = FolderURL.clipThumbnail.appendingPathComponent(thumbnailName).appendingPathExtension("png")
                let thumbnailData = UIImagePNGRepresentation(thumbnail)
                try? thumbnailData?.write(to: thumbnailPath)
                
                // 存储到数据库
                tempAssetMeta.location = destURL.absoluteString
                RealmUtils.realmUpdateQ.async {
                    let asset = tempAssetMeta.asset() as! ClipAsset
                    asset.thumbnailLocation = thumbnailPath.absoluteString
                    let realm = try! RealmUtils.updateRealm()!
                    try! realm.write {
                        realm.add(asset)
                    }
                }
            })
            
            completion()
        }
    }
    
    /// 将视频文件转为 GIF 并进行存储
    func saveFileAsGIF(completion: @escaping () -> Void) {
        let srcURL = URL(string: assetMeta.location)
        let asset = assetMeta
        
        /// 一个 GIF 中含有的帧数
        let frameCount = 16
        
        /// 每帧之间的时间间隔
        let delayTime = Float(0.2)
        
        Regift.createGIFFromSource(srcURL!, frameCount: frameCount, delayTime: delayTime) { (tempURL) in
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
