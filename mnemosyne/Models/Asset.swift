//
//  Asset.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import RealmSwift

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
    
    var description: String {
        return "identifier: \(self.identifier)\nnickName:\(self.nickName)\ntype:\(self.type)\nlocation:\(self.location)"
    }
    
    init(identifier: String = "", nickName: String = "", type: MnemosyneAssetType = .none, location: String = "") {
        self.identifier = identifier
        self.nickName = nickName
        self.type = type
        self.location = location
    }
}

class MNAsset: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var nickName = ""
    @objc dynamic var type = 0
    @objc dynamic var location = ""
    @objc dynamic var remark = ""
}

class ClipAssets: MNAsset {
    @objc dynamic var thumbnailLocation = ""
}

typealias SoundAsset = MNAsset
typealias PicAsset = MNAsset


