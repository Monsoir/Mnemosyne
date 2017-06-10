//
//  AssetViewController.swift
//  mnemosyne
//
//  Created by Mon on 09/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class AssetViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    class var CollectionViewCellClass: AssetPreviewCell.Type {
        get {
            return AssetPreviewCell.self
        }
    }
    
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
        view.register(type(of: self).CollectionViewCellClass, forCellWithReuseIdentifier: type(of: self).CollectionViewCellClass.reuseIdentifier())
        
        return view
    }()
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
//        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetPreviewCell.reuseIdentifier(), for: indexPath) as? AssetPreviewCell else {
            fatalError("unexpected cell in collection view")
        }
        
        return cell
    }
}

extension AssetViewController: Listable {
    func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
    func setupNavigationBar() {
        title = navigationBarTitle
        tabBarItem.title = nil
        navigationItem.rightBarButtonItem = navigationBarRightButton
    }
}
