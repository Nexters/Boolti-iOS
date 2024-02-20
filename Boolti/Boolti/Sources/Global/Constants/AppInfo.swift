//
//  AppInfo.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/22/24.
//

import Foundation

enum AppInfo {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    private static let appId = "6476589322"
    static let booltiAppStoreLink = "itms-apps://itunes.apple.com/app/app-store/\(appId)"
    static let booltiShareLink = "https://apps.apple.com/kr/app/id\(appId)"
}
