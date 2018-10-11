//
//  SessionState.swift
//  SingletonSessionState
//
//  Created by Vlastimir Radojevic on 10/11/18.
//  Copyright © 2018 Vlastimir Radojevic. All rights reserved.
//

import Foundation

public class SessionState {
    
    /// In-Memory storage for key-value pairs
    private var storage = [String: Any]()
    
    /// Serializes access to our internal disctinary
//    private let syncQueue = DispatchQueue(label: "serializationQueue")
    private let asyncQueue = DispatchQueue(label: "asyncQueue", attributes: .concurrent, target: nil)
    
    /// hide initialization
    private init() {}
    
    
    /// Swift fuarantees that lazily initialized globals or static properties are thread-safe
    /// GSD dispatch_once is not needed to create singletons,
    /// and it is no longer available from Swift 3
    public static let shared: SessionState = {
        let instance = SessionState()
        return instance
    }()
    
    public func set<T>(_ value: T?, forKey key: String) {
        // synchronize access
//        syncQueue.sync {
        asyncQueue.async(flags: .barrier) { // .barrier is used to 
            if value == nil {
                if self.storage.removeValue(forKey: key) != nil {
                    print("Successfully removed value for key \(key)")
                } else {
                    print("No value for key \(key)")
                }
            }
            self.storage[key] = value
        }
    }
    
    public func object<T>(forKey key: String) -> T? {
        var result: T?
        // syncronize access
//        syncQueue.sync {
        asyncQueue.sync {
            result = storage[key] as? T ?? nil
        }
        return result
    }
}
