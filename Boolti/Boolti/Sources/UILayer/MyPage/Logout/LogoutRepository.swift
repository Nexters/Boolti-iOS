//
//  LogoutRepository.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

protocol LogoutRepositoryType {
    var networkService: NetworkProviderType { get }
}

final class LogoutRepository: LogoutRepositoryType {

    var networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
}
