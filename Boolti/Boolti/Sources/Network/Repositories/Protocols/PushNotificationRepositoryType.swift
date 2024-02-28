//
//  PushNotificationRepositoryType.swift
//  Boolti
//
//  Created by Miro on 2/27/24.
//

import Foundation

protocol PushNotificationRepositoryType {

    var networkService: NetworkProviderType { get }
    func registerDeviceToken()
}
