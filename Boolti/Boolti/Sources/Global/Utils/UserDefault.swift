//
//  UserDefault.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

@propertyWrapper
struct UserDefault<T: Codable> {
    
    private let key: String
    private let defaultValue: T
    
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            if let decoded = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let value = try? decoder.decode(T.self, from: decoded) {
                    return value
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
    }
}

