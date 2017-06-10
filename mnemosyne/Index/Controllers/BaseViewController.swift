//
//  BaseViewController.swift
//  mnemosyne
//
//  Created by Mon on 08/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    /// 导航栏 title
    var navigationBarTitle: String {
        get {
            return ""
        }
    }
    
    var navigationBarRightButton: UIBarButtonItem? {
        get {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 避免 tab bar item 再次出现 navigation bar title
        tabBarItem.title = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
