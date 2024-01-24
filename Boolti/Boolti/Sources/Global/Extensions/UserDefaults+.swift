//
//  UserDefaults+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Properties
    @UserDefault<Int>(key: UserDefaultsKey.userId.rawValue, defaultValue: -1)
    static var userId
    
    @UserDefault<String>(key: UserDefaultsKey.accessToken.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault<String>(key: UserDefaultsKey.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault<String>(key: UserDefaultsKey.deviceToken.rawValue, defaultValue: "")
    static var deviceToken
    
    @UserDefault<Bool>(key: UserDefaultsKey.isFirstLaunch.rawValue, defaultValue: true)
    static var isFirstLaunch
    
    // MARK: - Custom Methods
    
    // UserDefaults에 저장된 모든 유저 정보를 제거하는 메서드
    static func removeAllUserDefaulsKeys() {
        UserDefaultsKey.allCases
            .forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }

    static func removeAllTokens() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.refreshToken.rawValue)
    }
}
