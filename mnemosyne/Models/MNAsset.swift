//
//  MNAsset.swift
//  mnemosyne
//
//  Created by Mon on 02/07/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import RealmSwift

class MNAsset: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var nickName = ""
    @objc dynamic var type = MnemosyneAssetType.none.rawValue
    @objc dynamic var location = ""
    @objc dynamic var remark = ""
    
    override static func primaryKey() -> String? {
        return "identifier"
    }
}

class ClipAsset: MNAsset {
    @objc dynamic var thumbnailLocation = ""
}

typealias SoundAsset = MNAsset
typealias PicAsset = MNAsset
