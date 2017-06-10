//
//  PicViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class PicViewController: AssetViewController {
    
    override class var CollectionViewCellClass: AssetPreviewCell.Type {
        get {
            return PicCollectionViewCell.self
        }
    }
    
    override var navigationBarTitle: String {
        get {
            return NSLocalizedString("PIC", comment: "")
        }
    }
    
    override var navigationBarRightButton: UIBarButtonItem? {
        get {
            return UIBarButtonItem(image: #imageLiteral(resourceName: "nav-take-picture").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(PicViewController.record))
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicCollectionViewCell.reuseIdentifier(), for: indexPath) as? PicCollectionViewCell else {
            fatalError("unexpected cell in collection view")
        }
        
        return cell
    }

}

extension PicViewController {
    func record() {
        
    }
}

extension PicViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: #imageLiteral(resourceName: "tab-bar-picture-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-picture-selected").withRenderingMode(.alwaysOriginal))
        
        return centerTabbarItemIcon(tabbarItem: item)
    }
}
