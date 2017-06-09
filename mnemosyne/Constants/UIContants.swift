//
//  UIContants.swift
//  mnemosyne
//
//  Created by Mon on 09/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

struct CollectionViewConstants {
    /// 一个 item 的大小度量
    static let itemMargin = CGFloat(5)
    static let itemWidth = CGFloat(UIScreen.main.bounds.width - 2 * CollectionViewConstants.itemMargin)
    static let itemHeight = CGFloat(200)
    static let itemSize = CGSize(width: CollectionViewConstants.itemWidth, height: CollectionViewConstants.itemHeight)
    
    /// item 之间的间隔
    static let itemLineSpacing = CGFloat(5)
}
