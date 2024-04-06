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
    
    @UserDefault<OAuthProvider>(key: UserDefaultsKey.oauthProvider.rawValue, defaultValue: .kakao)
    static var oauthProvider

    @UserDefault<Int>(key: UserDefaultsKey.tabBarIndex.rawValue, defaultValue:  0)
    static var tabBarIndex

    @UserDefault<Int?>(key: UserDefaultsKey.concertID.rawValue, defaultValue: nil)
    static var concertID

    @UserDefault<LandingDestination?>(key: UserDefaultsKey.landingDestination.rawValue, defaultValue: nil)
      static var landingDestination

    // MARK: - Custom Methods

    static func removeAllUserInfo() {
        UserDefaults.accessToken = ""
        UserDefaults.refreshToken = ""
        UserDefaults.userId = -1
        UserDefaults.userName = ""
        UserDefaults.userEmail = ""
        UserDefaults.userImageURLPath = ""
        UserDefaults.oauthProvider = .kakao
    }
}
