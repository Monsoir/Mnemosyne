//
//  ClipRecordBtnRecordLayout.swift
//  mnemosyne
//
//  Created by Mon on 16/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordBtnRecordLayout: Layoutable {
    
    var views: (UIView)
    var constants: (bottomOffset: CGFloat, size: CGSize)
    
    init(with views: (UIView), constants: (CGFloat, CGSize)) {
        self.views = views
        self.constants = constants
    }
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = views
        let (bottomOffset, size) = constants
        return { make in
            make.centerX.equalTo(superView)
            make.bottom.equalTo(superView).offset(bottomOffset)
            make.size.equalTo(size)
        }
    }
}
