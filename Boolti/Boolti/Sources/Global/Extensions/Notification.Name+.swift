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

    enum DynamicDestination {
        static let concertDetail = Notification.Name("concertDetail")
    }
}
