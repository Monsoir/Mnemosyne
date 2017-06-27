//
//  ClipRecordBottomBtnLayout.swift
//  mnemosyne
//
//  Created by Mon on 27/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordBottombtnLayout: Layoutable {
    var views: (UIView)
    var constants: (size: CGSize, bottomOffset: CGFloat, centerXMultiplier: CGFloat)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        return { make in
            make.centerX.equalTo(self.views).multipliedBy(self.constants.centerXMultiplier)
            make.bottom.equalTo(self.views).offset(self.constants.bottomOffset)
            make.size.equalTo(self.constants.size)
        }
    }
}
