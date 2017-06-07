//
//  Tabbarable.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

protocol Tabbarable: class {
    static func myTabbarItem() -> UITabBarItem
    static func centerTabbarItemIcon(tabbarItem: UITabBarItem) -> UITabBarItem
}

extension Tabbarable {
    static func centerTabbarItemIcon(tabbarItem: UITabBarItem) -> UITabBarItem {
        tabbarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        return tabbarItem
    }
}
