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
        
        #if DEBUG
            print("\(outputFileURL)")
            print("\(fileName)")
            print(assetMeta)
        #endif
    }
}
