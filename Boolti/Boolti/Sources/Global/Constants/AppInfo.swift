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
    static let androidDebugPackageName = "com.nexters.boolti.debug"
    static let booltiAppStoreLink = "itms-apps://itunes.apple.com/app/app-store/\(appId)"
    static let booltiShareLink = "https://apps.apple.com/kr/app/id\(appId)"
    static let booltiDeepLinkPrefix = "https://boolti.page.link"
    static var reversalPolicy =
        """
        • 서비스 내 발권 취소 및 환불은 주최자가 지정한 티켓 판매 기간 내에만 가능하며, 판매 기간 이후 환불은 주최자에게 직접 문의해 주시기 바랍니다.
        • 초청 티켓의 경우 발권 취소가 불가합니다.
        • 취소 요청 즉시 취소 완료 처리 및 환불이 진행됩니다.
        • 환불은 기존 결제 수단으로 진행되며 계좌이체의 경우 결제하신 계좌로 환불이 진행됩니다.
        • 결제 수단에 따라 환불 완료까지 약 1~5 영업일이 소요될 수 있습니다.
        • 기타 사항은 카카오톡 채널 @스튜디오불티로 문의해 주시기 바랍니다.
        """

    static let termsPolicyLink = "https://boolti.notion.site/b4c5beac61c2480886da75a1f3afb982"
    static let privacyPolicyLink = "https://boolti.notion.site/5f73661efdcd4507a1e5b6827aa0da70"
    static let refundPolicyLink = "https://boolti.notion.site/d2a89e2c19824c60bb1e928370d16989"
}
