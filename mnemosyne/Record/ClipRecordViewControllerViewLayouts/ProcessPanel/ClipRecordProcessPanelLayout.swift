//
//  ClipRecordProcessPanelLayout.swift
//  mnemosyne
//
//  Created by Mon on 20/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import SnapKit

struct ClipRecordProcessPanelLayout: Layoutable {
    var views: (UIView)
    var constants: (panelHeight: CGFloat?, bottomOffset: CGFloat)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = self.views
        return { make in
            make.bottom.equalTo(superView).offset(self.constants.bottomOffset)
            make.left.right.equalTo(superView)
            make.height.equalTo(self.constants.panelHeight!)
        }
    }
    
    func layoutUpdater() -> (ConstraintMaker) -> Void {
        let superView = views
        return { make in
            make.bottom.equalTo(superView).offset(self.constants.bottomOffset)
        }
    }
}
