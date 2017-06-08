//
//  ClipViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class ClipViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = NSLocalizedString("CLIP", comment: "")
        tabBarItem.title = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ClipViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab-bar-video-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-video-selected").withRenderingMode(.alwaysOriginal))
        
        return centerTabbarItemIcon(tabbarItem: item)
        
    }
}
