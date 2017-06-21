//
//  ClipRecordProcessBtnLayout.swift
//  mnemosyne
//
//  Created by Mon on 20/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import SnapKit

struct ClipRecordProcessBtnLayout: Layoutable {
    var views: (UIView)
    var constants: (size: CGSize, centerXMultiplier: CGFloat)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = views
        return { make in
            make.size.equalTo(self.constants.size)
            make.centerY.equalTo(superView)
            make.centerX.equalTo(superView).multipliedBy(self.constants.centerXMultiplier)
        }
    }
}
