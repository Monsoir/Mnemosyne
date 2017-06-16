//
//  ClipRecordBtnToRecordLayout.swift
//  mnemosyne
//
//  Created by Mon on 16/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordBtnToRecordLayout: Layoutable {
    var views: (UIView)
    var constants: (size: CGSize, centerXMultiplier: CGFloat)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let sibiling = views
        let (size, centerXMutiplier) = constants
        return { make in
            make.size.equalTo(size)
            make.centerY.equalTo(sibiling)
            make.centerX.equalTo(sibiling).multipliedBy(centerXMutiplier)
        }
    }
}
