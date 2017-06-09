//
//  ClipViewController.swift
//  mnemosyne
//
//  Created by Mon on 07/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import SnapKit

class ClipViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        [unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CollectionViewConstants.itemSize
        flowLayout.minimumLineSpacing = CollectionViewConstants.itemLineSpacing
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .white
        view.bounces = true
        
        view.delegate = self
        view.dataSource = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return view
    }()

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

extension ClipViewController: Tabbarable {
    static func myTabbarItem() -> UITabBarItem {
        let item = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab-bar-video-normal").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "tab-bar-video-selected").withRenderingMode(.alwaysOriginal))
        
        return centerTabbarItemIcon(tabbarItem: item)
        
    }
}

extension ClipViewController: Listable {
    func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupNavigationBar() {
        title = NSLocalizedString("CLIP", comment: "")
        tabBarItem.title = nil
    }
}

extension ClipViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? UICollectionViewCell else {
            fatalError("unexpected cell in collection view")
        }
        
        cell.backgroundColor = .yellow
        return cell
    }
}
