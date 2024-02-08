//
//  LogoutViewModel.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class LogoutViewModel {

    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
}
