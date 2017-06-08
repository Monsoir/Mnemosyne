//
//  PicViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class PicViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("PIC", comment: "")
        tabBarItem.title = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PicViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: #imageLiteral(resourceName: "tab-bar-picture-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-picture-selected").withRenderingMode(.alwaysOriginal))
        
        return centerTabbarItemIcon(tabbarItem: item)
    }
}
