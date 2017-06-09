//
//  UIContants.swift
//  mnemosyne
//
//  Created by Mon on 09/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

/// Collection view cell 的整体常量
struct CollectionViewConstants {
    /// 一个 item 的大小度量
    static let itemMargin = CGFloat(5)
    static let itemWidth = CGFloat(UIScreen.main.bounds.width - 2 * CollectionViewConstants.itemMargin)
    static let itemHeight = CGFloat(200)
    static let itemSize = CGSize(width: CollectionViewConstants.itemWidth, height: CollectionViewConstants.itemHeight)
    
    /// item 之间的间隔
    static let itemLineSpacing = CGFloat(5)
}

/// Collection view cell 的内部常量
struct PreviewCellConstants {
    
    /// 内部控件到边框的距离
    static let marginToFrame = 5
    
    /// 控件之间的间距
    static let controlMargin = 5
    
    /// 日历小图标
    struct LabelCalendar {
        static let length = 30
        static let size = CGSize(width: LabelCalendar.length, height: LabelCalendar.length)
    }
    
    /// 日期标签
    struct LabelDate {
        static let height = 40
    }
    
    /// 操作按钮
    struct ButtonOperations {
        static let length = 40
        static let size = CGSize(width: ButtonOperations.length, height: ButtonOperations.length)
    }
    
    struct PreviewLayer {
        static let height = 100
    }
}
