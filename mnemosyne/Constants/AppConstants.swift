//
//  AppConstants.swift
//  mnemosyne
//
//  Created by Mon on 20/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation

/// 资源文件夹的名称
struct FolderName {
    static let clipFolder = "Clips"
    static let soundFolder = "Sounds"
    static let picFolder = "Pics"
}

/// 资源文件夹的 URL
struct FolderURL {
    static let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let tmpURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    static let clipURL = FolderURL.documentURL.appendingPathComponent(FolderName.clipFolder, isDirectory: true)
    static let soundURL = FolderURL.documentURL.appendingPathComponent(FolderName.soundFolder, isDirectory: true)
    static let picURL = FolderURL.documentURL.appendingPathComponent(FolderName.picFolder, isDirectory: true)
}
