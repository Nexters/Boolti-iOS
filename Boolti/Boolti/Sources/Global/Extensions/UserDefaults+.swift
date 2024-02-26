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

    @UserDefault<String>(key: UserDefaultsKey.userName.rawValue, defaultValue: "")
    static var userName

    @UserDefault<String>(key: UserDefaultsKey.userEmail.rawValue, defaultValue: "")
    static var userEmail

    @UserDefault<String>(key: UserDefaultsKey.userImageURLPath.rawValue, defaultValue: "")
    static var userImageURLPath

    @UserDefault<String>(key: UserDefaultsKey.accessToken.rawValue, defaultValue: "")
    static var accessToken
    
    @UserDefault<String>(key: UserDefaultsKey.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    
    @UserDefault<String>(key: UserDefaultsKey.deviceToken.rawValue, defaultValue: "")
    static var deviceToken
    
    @UserDefault<String>(key: UserDefaultsKey.oauthProvider.rawValue, defaultValue: OAuthProvider.kakao.rawValue)
    static var oauthProvider
    
    // MARK: - Custom Methods

    static func removeAllUserInfo() {
        UserDefaults.accessToken = ""
        UserDefaults.refreshToken = ""
        UserDefaults.deviceToken = ""
        UserDefaults.userId = -1
        UserDefaults.userName = ""
        UserDefaults.userEmail = ""
        UserDefaults.userImageURLPath = ""
        UserDefaults.oauthProvider = OAuthProvider.kakao.rawValue
    }
}
