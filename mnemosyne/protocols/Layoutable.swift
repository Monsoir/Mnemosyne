//
//  Layoutable.swift
//  mnemosyne
//
//  Created by Mon on 16/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import SnapKit

protocol Layoutable {
    func layoutMaker() -> (ConstraintMaker) -> Void
    func layoutUpdater() -> (ConstraintMaker) -> Void
}

extension Layoutable {
    func layoutMaker() -> (ConstraintMaker) -> Void {
        return { make in
            
        }
    }
    
    func layoutUpdater() -> (ConstraintMaker) -> Void {
        return { make in
            
        }
    }
}

// MARK: - 自动布局的 extension
extension UIView {
    func makeLayout(layouter: Layoutable) {
        snp.makeConstraints(layouter.layoutMaker())
    }
    
    func updateLayout(layouter: Layoutable) {
        snp.updateConstraints(layouter.layoutUpdater())
    }
}
