//
//  MnemosyneViewable.swift
//  mnemosyne
//
//  Created by Mon on 09/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

protocol CollectionViewPreviewable {
    
    var assetType: MnemosyneAssetType { get }
    
    /// 缩略图预览
    func thumbnailPreview()
    
    /// 3D Touch 预览
    func threeDTouchPreview()
}

extension CollectionViewPreviewable where Self: UICollectionViewCell {
    
    func thumbnailPreview() {
        
    }
    
    func threeDTouchPreview() {
        
    }
}
