//
//  ClipRecordSubEffectLayout.swift
//  mnemosyne
//
//  Created by Mon on 16/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordSubEffectLayout: Layoutable {
    
    var views: (UIView)
    var constants: (CGFloat)
    
    init(with views: (UIView), constants: (CGFloat)) {
        self.views = views
        self.constants = constants
    }
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = views
        let topOffset = constants
        return { make in
            make.centerX.equalTo(superView)
            make.top.equalTo(superView).offset(topOffset)
        }
    }
}
