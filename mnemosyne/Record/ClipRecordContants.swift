//
//  ClipRecordContants.swift
//  mnemosyne
//
//  Created by Mon on 19/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

struct ClipRecord {
    static let progressStrokeWidth = CGFloat(3)
    static let deactivatedAlpha = CGFloat(0.4)
    static let activatedAlpha = CGFloat(1.0)
    static let panelHeight = CGFloat(120)
    static let barHeight: Int = {
        let statusBarHeight = 20
        let navigationBarHeight = 44
        return statusBarHeight + navigationBarHeight
    }()
    static let strokeProgressAnimationName = "Stroke progress"
    
    /// For testing
    static let recordMethod = ClipRecordMethod.tap
    static let recordMethodPrompt = NSLocalizedString("TapToRecord", comment: "")
    static let recordDuration = 5
}
