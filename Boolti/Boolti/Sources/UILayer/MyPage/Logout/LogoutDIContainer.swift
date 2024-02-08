//
//  LogoutDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class LogoutDIContainer {

    private let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func createLogoutViewController() -> LogoutViewController {
        return LogoutViewController(viewModel: self.createLogoutViewModel())
    }

    private func createLogoutViewModel() -> LogoutViewModel {
        return LogoutViewModel(logoutRepository: LogoutRepository(networkService: self.networkService))
    }
}
