//
//  Tabbarable.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

protocol Tabbarable: class {
    
    /// 设置 ViewController 的 tab bar item 样式
    ///
    /// - Returns: View controller 的 tab bar item
    static func myTabbarItem() -> UITabBarItem
    
    /// 将 View controller 的 tab bar item 图标居中
    ///
    /// - Parameter tabbarItem: <#tabbarItem description#>
    /// - Returns: <#return value description#>
    static func centerTabbarItemIcon(tabbarItem: UITabBarItem) -> UITabBarItem
}

extension Tabbarable {
    static func centerTabbarItemIcon(tabbarItem: UITabBarItem) -> UITabBarItem {
        tabbarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        return tabbarItem
    }
}
