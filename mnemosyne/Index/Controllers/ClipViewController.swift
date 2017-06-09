//
//  ClipViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import SnapKit

class ClipViewController: AssetViewController {
    
    override class var CollectionViewCellClass: AssetPreviewCell.Type {
        get {
            return ClipCollectionViewCell.self
        }
    }
    
    override var navigationBarTitle: String {
        get {
            return NSLocalizedString("CLIP", comment: "")
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipCollectionViewCell.reuseIdentifier(), for: indexPath) as? ClipCollectionViewCell else {
            fatalError("unexpected cell in collection view")
        }
        
        return cell
    }

}

extension ClipViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab-bar-video-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-video-selected").withRenderingMode(.alwaysOriginal))
        
        return centerTabbarItemIcon(tabbarItem: item)
        
    }
}
