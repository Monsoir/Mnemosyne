//
//  SettingViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SettingViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: #imageLiteral(resourceName: "tab-bar-setting-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-setting-selected").withRenderingMode(.alwaysOriginal))
        return centerTabbarItemIcon(tabbarItem: item)
    }
}
