//
//  RealmUtils.swift
//  mnemosyne
//
//  Created by Mon on 28/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import Realm

class RealmUtils: NSObject {
    
    /// 获取一个 Realm 实例
    class func aRealm() -> RLMRealm {
        let dbURL = FolderURL.databasesURL.appendingPathComponent(DatabaseName)
        return RLMRealm.init(url: dbURL)
    }
}
