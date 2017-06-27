//
//  Clip.swift
//  mnemosyne
//
//  Created by Mon on 27/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordTopRightRestBtnLayout: Layoutable {
    var views: (superView: UIView, aboveView: UIView)
    var constants: (size: CGSize, topOffset: CGFloat, rightOffset: CGFloat)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        return { make in
            make.size.equalTo(self.constants.size)
            make.top.equalTo(self.views.aboveView.snp.bottom).offset(self.constants.topOffset)
            make.right.equalTo(self.views.superView).offset(self.constants.rightOffset)
        }
    }
}
