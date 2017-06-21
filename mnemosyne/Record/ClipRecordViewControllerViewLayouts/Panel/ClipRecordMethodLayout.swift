//
//  ClipRecordMethodLayout.swift
//  mnemosyne
//
//  Created by Mon on 16/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

struct ClipRecordMethodLayout: Layoutable {
    var views: (UIView)
    
    init(with views: (UIView)) {
        self.views = views
    }
    
    func layoutMaker() -> (ConstraintMaker) -> Void {
        let superView = views
        return { make in
            make.edges.equalTo(superView)
        }
    }
}
