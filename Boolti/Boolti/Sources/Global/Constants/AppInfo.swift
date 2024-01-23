//
//  AppInfo.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/22/24.
//

import Foundation

enum AppInfo {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    // TODO: - Update with actual KakaoTalk ID and Apple App ID
    private static let appId = "362057947"
    static let booltiAppStoreLink =  "itms-apps://itunes.apple.com/app/app-store/\(appId)"
}
