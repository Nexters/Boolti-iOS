//
//  AppInfo.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/22/24.
//

import Foundation

enum AppInfo {
    static let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

    static let appId = "6476589322"
    static let bundleID = "com.nexters.boolti"
    static let booltiAppStoreLink = "itms-apps://itunes.apple.com/app/app-store/\(appId)"
    static let booltiShareLink = "https://apps.apple.com/kr/app/id\(appId)"
    static let booltiDeepLinkPrefix = "https://app.boolti.in/"

    static let termsPolicyLink = "https://boolti.notion.site/b4c5beac61c2480886da75a1f3afb982"
    static let privacyPolicyLink = "https://boolti.notion.site/5f73661efdcd4507a1e5b6827aa0da70"
    static let refundPolicyLink = "https://boolti.notion.site/d2a89e2c19824c60bb1e928370d16989"
}
