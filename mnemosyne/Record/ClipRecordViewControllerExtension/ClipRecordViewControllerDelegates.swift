//
//  ClipRecordViewControllerDelegates.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import MediaRecordKit
import FileManagerShortcutKit

// MARK: - CAAnimationDelegate
extension ClipRecordViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // 识别目标动画 -> 进度动画
        if flag && anim == progressLayer.animation(forKey: ClipRecord.strokeProgressAnimationName) {
            if recordStatus == .recording { recordStatus = .recorded }
            progressLayer.removeAnimation(forKey: ClipRecord.strokeProgressAnimationName)
        }
    }
}

// MARK: - VideoRecorderDelegate
extension ClipRecordViewController: VideoRecorderDelegate {
    func fileDidStartOutputToURL(_ fileURL: URL, fileName: String) {
        print("\(fileURL)")
        print("\(fileName)")
    }
    
    func fileDidFinishOutputToURL(_ outputFileURL: URL, fileName: String, error: Error?) {
        assetMeta.identifier = fileName
        assetMeta.nickName = fileName
        assetMeta.location = outputFileURL.absoluteString
        
        // 若此时状态为 .notRecording，则表示是在录制进行中取消
        if recordStatus == .notRecording {
            /**
             再重设状态，由于此函数的调用后于 resetRecording
             */
            if !assetMeta.location.isEmpty {
                FileManagerShortcuts.deleteItemAt(URL(string: assetMeta.location)!) { (result) in
                    #if DEBUG
                        print("cancel Recording")
                        print(result)
                    #endif
                }
            }
        } else {
            recorder.stopReceivingEnvironment()
        }
        
        #if DEBUG
            print(recordStatus.rawValue)
            print("\(outputFileURL)")
            print("\(fileName)")
            print(assetMeta)
        #endif
    }
}
