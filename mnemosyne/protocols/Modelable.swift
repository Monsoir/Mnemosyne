//
//  Modelable.swift
//  mnemosyne
//
//  Created by Mon on 01/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation

protocol MnemosyneAssetable {
    
    /// 创建日期
    var createDateTime: String { get set }
    
    /// 名称
    var name: String { get set }
    
    /// 类型
    var type: MnemosyneAssetType { get set }
    
    /// 存储位置
    var location: String { get set }
    
    /// 附加的信息
    var remark: String { get set }
    
    /// 缩略图位置，可有可无
    var thumbnailLocation: String { get set }
}
