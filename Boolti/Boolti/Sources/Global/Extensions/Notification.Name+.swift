//
//  Notification.Name+.swift
//  Boolti
//
//  Created by Miro on 2/18/24.
//

import Foundation

extension Notification.Name {
    static let refreshTokenHasExpired = Notification.Name("refreshTokenHasExpired")
    static let serverError = Notification.Name("serverError")
    static let didTabBarSelectedIndexChanged = Notification.Name("didTabBarSelectedIndexChanged")

    enum LandingDestination {
        static let concertDetail = Notification.Name("concertDetail")
        static let reservationList = Notification.Name("reservationList")
        static let reservationDetail = Notification.Name("reservationDetail")
    }
}
