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
import AVFoundation

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
        #if DEBUG
            print("\(fileURL)")
            print("\(fileName)")
        #endif
    }
    
    func fileDidFinishOutputToURL(_ outputFileURL: URL, fileName: String, error: Error?) {
        assetMeta.identifier = fileName
        assetMeta.nickName = fileName
        assetMeta.location = outputFileURL.absoluteString
        recorder.stopReceivingEnvironment()
        
        // 预览已录制
        let player = AVPlayer(url: URL(string: assetMeta.location)!)
        player.actionAtItemEnd = .none
        recordedPreviewLayer = AVPlayerLayer(player: player)
        recordedPreviewLayer?.frame = view.bounds
        NotificationCenter.default.addObserver(self, selector: #selector(ClipRecordViewController.playerItemDidReachEnd(_:)), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        DispatchQueue.main.async {
            self.view.layer.insertSublayer(self.recordedPreviewLayer!, above: self.recordingPreviewLayer)
            player.play()
        }
    }
    
    /// 视频预览播放完成后的回调
    ///
    /// - Parameter notification: 消息内容
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        // 播放完之后，重新播放
        let playerItem = notification.object as! AVPlayerItem
        playerItem.seek(to: kCMTimeZero)
        
    }
}
