//
//  PicCollectionViewCell.swift
//  mnemosyne
//
//  Created by Mon on 09/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class PicCollectionViewCell: AssetPreviewCell {
    override var assetType: MnemosyneAssetType {
        get {
            return .pic
        }
    }
}
