//
//  Enviroment.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

enum Environment: String {
    case debug = "debug"
    case release = "release"
    
    enum Keys {
        enum Plist {
            static let baseURL = "BASE_URL"
            static let kakaoNativeAppKey = "KAKAO_NATIVE_APP_KEY"
            static let tossPaymentsKey = "TOSS_PAYMENTS_KEY"
        }
    }
    
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else { fatalError() }
        return dict
    }()
    
    static let BASE_URL: String = {
        guard let string = Environment.infoDictionary[Keys.Plist.baseURL] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return string
    }()
    
    static let KAKAO_NATIVE_APP_KEY: String = {
        guard let string = Environment.infoDictionary[Keys.Plist.kakaoNativeAppKey] as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY not set in plist for this environment")
        }
        return string
    }()
    
    static let TOSS_PAYMENTS_KEY: String = {
        guard let string = Environment.infoDictionary[Keys.Plist.tossPaymentsKey] as? String else {
            fatalError("TOSS_PAYMENTS_KEY not set in plist for this environment")
        }
        return string
    }()
}

func env() -> Environment {
    #if DEBUG
    return .debug
    #elseif RELEASE
    return .release
    #endif
}
