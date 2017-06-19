//
//  ClipRecordViewControllerDelegates.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import MediaRecordKit

// MARK: - CAAnimationDelegate
extension ClipRecordViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // 识别目标动画 -> 进度动画
        if flag && anim == progressLayer.animation(forKey: StrokeProgressAnimationName) {
            if recordStatus == .recording { recordStatus = .recorded }
            progressLayer.removeAnimation(forKey: StrokeProgressAnimationName)
        }
    }
}

// MARK: - VideoRecorderDelegate
extension ClipRecordViewController: VideoRecorderDelegate {
    
}
