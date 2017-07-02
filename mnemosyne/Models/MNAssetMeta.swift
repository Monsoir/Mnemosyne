//
//  MNAssetMeta.swift
//  mnemosyne
//
//  Created by Mon on 02/07/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation

enum MnemosyneAssetType: Int {
    case none
    case clip // 视频
    case gif // GIF
    case sound // 音频
    case pic // 图片
}

struct MNAssetMeta {
    var identifier = ""
    var nickName = ""
    var type = MnemosyneAssetType.none
    var location = ""
    var remark = ""
    
    var description: String {
        return "identifier: \(self.identifier)\nnickName:\(self.nickName)\ntype:\(self.type)\nlocation:\(self.location)\nremark:\(self.remark)"
    }
    
    init(identifier: String = "", nickName: String = "", type: MnemosyneAssetType = .none, location: String = "", remark: String = "") {
        self.identifier = identifier
        self.nickName = nickName
        self.type = type
        self.location = location
        self.remark = remark
    }
    
    func asset() -> MNAsset {
        var asset: MNAsset!
        switch type {
        case .none:
            asset = MNAsset()
        case .clip:
            asset = ClipAsset()
        case .gif:
            asset = ClipAsset()
        case .sound:
            asset = SoundAsset()
        case .pic:
            asset = PicAsset()
        }
        
        asset.identifier = identifier
        asset.nickName = nickName
        asset.type = type.rawValue
        asset.location = location
        asset.remark = remark
        
        return asset
    }
}
