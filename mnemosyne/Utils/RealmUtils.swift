//
//  RealmUtils.swift
//  mnemosyne
//
//  Created by Mon on 28/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit
import RealmSwift

let RealmUpdateQName = "com.wenyongyang.mnemosyne.realm.update"
let RealmReadingQName = "com.wenyongyang.mnemosyne.realm.reading"

class RealmUtils: NSObject {
    
    // 更新线程
    static let realmUpdateQ = DispatchQueue(label: RealmUpdateQName)
    
    // 读线程
    static let realmReadingQ = DispatchQueue(label: RealmReadingQName)
    
    /// UI 线程专用 Realm
    ///
    /// - Returns: 一个 Realm 对象
    class func uiRealm() throws -> Realm? {
        do {
            return try self.aRealm()
        } catch {
            throw error
        }
    }
    
    /// 更新操作专用 Realm，搭配 realmUpdateQ
    ///
    /// - Returns: 一个 Realm 对象
    class func updateRealm() throws -> Realm? {
        do {
            return try self.aRealm()
        } catch {
            throw error
        }
    }
    
    /// 读操作专用 Realm，搭配 realmReadingQ
    ///
    /// - Returns: 一个 Realm 对象
    class func readingRealm() throws -> Realm? {
        do {
            return try self.aRealm()
        } catch {
            throw error
        }
    }
    
    /// 获取一个 Realm 实例
    private static func aRealm() throws -> Realm? {
        let dbURL = FolderURL.databasesURL.appendingPathComponent(DatabaseName)
        do {
            let realm = try Realm(fileURL: dbURL)
            return realm
        } catch {
            throw error
        }
    }
}
