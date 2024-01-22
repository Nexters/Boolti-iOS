//
//  UserDefaultsManager.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

