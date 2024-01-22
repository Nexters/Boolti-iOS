//
//  AppInfo.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/22/24.
//

import Foundation

struct AppInfo {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    static let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
    // TODO: - 현재는 카카오톡 id, 애플에서 앱 아이디 발급 받고 수정 필요
    private static let appId = "362057947"
    static let booltiAppStoreLink =  "itms-apps://itunes.apple.com/app/app-store/\(appId)"
}
