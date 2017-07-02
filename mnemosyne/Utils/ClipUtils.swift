//
//  ClipUtils.swift
//  mnemosyne
//
//  Created by Mon on 02/07/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import AVFoundation

class ClipUtils: NSObject {
    
    /// 从视频中生成一张截图，暂时定为一秒时的截图，此方法内置异步调用
    ///
    /// - Parameters:
    ///   - aURL: 视频地址
    ///   - completion: 截图生成后的回调
    static func thumbnailFromVideo(url aURL: URL, completion: @escaping ((_ thumbnail: UIImage?) -> Void)) {
        
        let queue = DispatchQueue.global(qos: .default)
        queue.async {
            let asset = AVURLAsset(url: aURL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            do {
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(1, 1), actualTime: nil)
                let thumbnail = UIImage(cgImage: cgImage)
                completion(thumbnail)
            } catch {
                #if DEBUG
                    print("creating thumbnail failed")
                #endif
                completion(nil)
            }
        }
    }
}
