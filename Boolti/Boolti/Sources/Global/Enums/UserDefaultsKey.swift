//
//  UserDefaultsKey.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case userId
    case accessToken
    case refreshToken
    case deviceToken
    case isFirstLaunch
}
