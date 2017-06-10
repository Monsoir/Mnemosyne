//
//  SettingViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {
    
    override var navigationBarTitle: String {
        get {
            return NSLocalizedString("SETTING", comment: "")
        }
    }
    
    fileprivate lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        
        view.delegate = self
        view.dataSource = self
        view.rowHeight = 100
        view.backgroundColor = .white
        
        return view
    }()
    
    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension SettingViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: #imageLiteral(resourceName: "tab-bar-setting-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-setting-selected").withRenderingMode(.alwaysOriginal))
        return centerTabbarItemIcon(tabbarItem: item)
    }
}

extension SettingViewController {
    func setupSubviews() {
        
    }
    
    func setupNavigationBar() {
        title = navigationBarTitle
        tabBarItem.title = nil
    }
}
