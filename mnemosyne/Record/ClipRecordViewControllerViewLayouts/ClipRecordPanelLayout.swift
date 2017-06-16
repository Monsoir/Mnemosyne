//
//  ClipRecordPanelLayout.swift
//  mnemosyne
//
//  Created by Mon on 16/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordPanelLayout: Layoutable {
    
    var views: (UIView)
    var constants: (panelHeight: CGFloat?, bottomOffset: CGFloat?)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = views
        let (panelHeight, _) = constants
        return { make in
            make.bottom.equalTo(superView)
            make.left.right.equalTo(superView)
            make.height.equalTo(panelHeight!)
        }
    }
    
    func layoutUpdater() -> (ConstraintMaker) -> Void {
        let superView = views
        let (_, bottomOffset) = constants
        return { make in
            make.bottom.equalTo(superView).offset(bottomOffset!)
        }
    }
    
    init(with views: (UIView), constants: (CGFloat?, CGFloat?)) {
        self.views = views
        self.constants = constants
    }
}
