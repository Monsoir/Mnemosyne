//
//  ClipRecordFakeNavigationBarLayout.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordFakeNavigationBarLayout: Layoutable {
    var views: (UIView)
    var constants: (barHeight: CGFloat?, topOffset: CGFloat?)
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = views
        let (barHeight, _) = constants
        return { make in
            make.top.left.right.equalTo(superView)
            make.height.equalTo(barHeight!)
        }
    }
    
    func layoutUpdater() -> (ConstraintMaker) -> Void {
        let superView = views
        let (_, topOffset) = constants
        return { make in
            make.top.equalTo(superView).offset(topOffset!)
        }
    }
}
