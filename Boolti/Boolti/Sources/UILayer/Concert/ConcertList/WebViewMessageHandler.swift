//
//  WebViewMessageHandler.swift
//  Boolti
//
//  Created by Miro on 4/15/25.
//

import Foundation

final class RegisterConcertWebViewHandler: WebViewMessageHandler {

    func handleWebMessage(command: WebToAppCommand, payload: [String: Any]) {
        switch command {
        case .navigateToShowDetail:
            guard let showId = payload["showId"] as? Int else { return }
            UserDefaults.landingDestination = .concertDetail(concertId: showId)

            NotificationCenter.default.post(
                name: Notification.Name.didTabBarSelectedIndexChanged,
                object: nil,
                userInfo: ["tabBarIndex" : HomeTab.concert.rawValue]
            )
            NotificationCenter.default.post(
                name: Notification.Name.LandingDestination.concertDetail,
                object: nil
            )
        default:
            break
        }
    }
}
