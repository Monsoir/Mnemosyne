//
//  AssetPreviewCell.swift
//  mnemosyne
//
//  Created by Mon on 09/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

class AssetPreviewCell: UICollectionViewCell, CollectionViewPreviewable {
    
    var assetType: MnemosyneAssetType {
        get {
            return .none
        }
    }
    
    /// 日期小图标
    fileprivate lazy var ivCalendar: UIImageView = {
        let view = UIImageView()
        view.image = #imageLiteral(resourceName: "calendar")
        return view
    }()
    
    /// 日期标签
    fileprivate lazy var lbDate: UILabel = {
        let view = UILabel()
        view.text = "2017-01-01"
        return view
    }()
    
    /// 操作按钮
    fileprivate lazy var btnOperations: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        let attributedString = NSAttributedString(string: "· · ·", attributes:[NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont(name:"Helvetica-Bold", size:23.0)!])
        view.setAttributedTitle(attributedString, for: .normal)
        return view
    }()
    
    /// 预览层
    fileprivate var preview: UIView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        get {
            return true
        }
    }
    
    override func updateConstraints() {
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        ivCalendar.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).offset(PreviewCellConstants.marginToFrame)
            make.centerY.equalTo(lbDate)
            make.size.equalTo(PreviewCellConstants.LabelCalendar.size)
        }
        
        lbDate.snp.makeConstraints { (make) in
            make.top.equalTo(contentView).offset(PreviewCellConstants.marginToFrame)
            make.left.equalTo(ivCalendar.snp.right).offset(PreviewCellConstants.controlMargin)
            make.height.equalTo(PreviewCellConstants.LabelDate.height)
        }
        
        btnOperations.snp.makeConstraints { (make) in
            make.centerY.equalTo(lbDate)
            make.right.equalTo(contentView).offset(-PreviewCellConstants.marginToFrame)
            make.size.equalTo(PreviewCellConstants.ButtonOperations.size)
        }
        
        if let p = preview {
            p.snp.makeConstraints { (make) in
                make.top.equalTo(lbDate.snp.bottom).offset(PreviewCellConstants.controlMargin)
                make.left.equalTo(contentView).offset(PreviewCellConstants.marginToFrame)
                make.right.equalTo(contentView).offset(-PreviewCellConstants.marginToFrame)
                make.bottom.equalTo(contentView).offset(-PreviewCellConstants.marginToFrame)
            }
        }
        
        super.updateConstraints()
    }
}

private extension AssetPreviewCell {
    func setupSubviews() {
        
        func createPreviewFrom(_ type: MnemosyneAssetType) -> UIView? {
            var view: UIView? = nil
            switch type {
                case .clip:
                    view = UIView()
                    view?.backgroundColor = .gray
                case .sound:
                    view = UIView()
                    view?.backgroundColor = .gray
                case .pic:
                    view = UIImageView()
                    view?.contentMode = .scaleAspectFill
                    (view as? UIImageView)?.image = #imageLiteral(resourceName: "testImage.jpg")
                    view?.clipsToBounds = true
                default:
                    return view
            }
            
            return view
        }
        
        contentView.addSubview(ivCalendar)
        contentView.addSubview(lbDate)
        contentView.addSubview(btnOperations)
        
        preview = createPreviewFrom(assetType)
        if let p = preview {
            contentView.addSubview(p)
        }
    }
}

extension AssetPreviewCell {
    class func reuseIdentifier() -> String {
        return String(describing: type(of: self))
    }
}
