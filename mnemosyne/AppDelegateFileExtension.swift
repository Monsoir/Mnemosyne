//
//  AppDelegateFileExtension.swift
//  mnemosyne
//
//  Created by Mon on 20/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import Foundation
import FileManagerShortcutKit

/// 创建放置资源的各个文件夹
///
func createAssetFolders() {
    FileManagerShortcuts.createFolderAt(FolderURL.clipURL, completion: nil)
    FileManagerShortcuts.createFolderAt(FolderURL.soundURL, completion: nil)
    FileManagerShortcuts.createFolderAt(FolderURL.picURL, completion: nil)
}
