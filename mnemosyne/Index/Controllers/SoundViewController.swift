//
//  SoundViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class SoundViewController: AssetViewController {
    
    override class var CollectionViewCellClass: AssetPreviewCell.Type {
        get {
            return SoundCollectionViewCell.self
        }
    }
    
    override var navigationBarTitle: String {
        get {
            return NSLocalizedString("SOUND", comment: "")
        }
    }
    
    override var navigationBarRightButton: UIBarButtonItem? {
        get {
            return UIBarButtonItem(image: #imageLiteral(resourceName: "nav-take-audio").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(SoundViewController.record))
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SoundCollectionViewCell.reuseIdentifier(), for: indexPath) as? SoundCollectionViewCell else {
            fatalError("unexpected cell in collection view")
        }
        
        return cell
    }

}

extension SoundViewController {
    func record() {
        
    }
}

extension SoundViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: "", image: #imageLiteral(resourceName: "tab-bar-audio-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-audio-selected").withRenderingMode(.alwaysOriginal))
        return centerTabbarItemIcon(tabbarItem: item)
    }
}
