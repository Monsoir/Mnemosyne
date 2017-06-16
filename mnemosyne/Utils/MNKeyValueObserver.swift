//
//  MNKeyValueObserver.swift
//  mnemosyne
//
//  Created by Mon on 13/06/2017.
//  Copyright © 2017 wenyongyang. All rights reserved.
//

import UIKit

private var myContext = 0

protocol MNKeyValueObserverType {
    
}

class MNKeyValueObserver: NSObject {
    weak var target: AnyObject? = nil
    var selector: Selector!
    
    fileprivate weak var observeredObject: AnyObject? = nil
    fileprivate var keyPath: String!
    
    init?(with object: AnyObject?, keyPath k: String!, target t: AnyObject?, selector s: Selector!, options os: NSKeyValueObservingOptions) {
        guard let _ = object else { return nil }
        assert(t != nil, "target should not be nil")
        assert(t!.responds(to: s)
            , "target does not response to selector")
        super.init()
        target = t
        selector = s
        observeredObject = object
        keyPath = k
        object?.addObserver(self, forKeyPath: k, options: os, context: &myContext)
    }
    
    deinit {
        #if DEBUG
            print("\(type(of: self)) deinit")
        #endif
        observeredObject?.removeObserver(self, forKeyPath: keyPath)
    }
    
    class func observeObject(object: AnyObject?, keyPath: String!, target: AnyObject?, selector: Selector!, options: NSKeyValueObservingOptions) -> MNKeyValueObserver? {
        return MNKeyValueObserver(with: object, keyPath: keyPath, target: target, selector: selector, options: options)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            didChange(change: change)
        }
    }
    
    private func didChange(change: [NSKeyValueChangeKey : Any]?) {
        guard let _ = target else { return }
        let _ = target!.perform(selector, with: change)
    }
}
