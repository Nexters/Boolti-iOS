//
//  LogoutDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class LogoutDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createLogoutViewController() -> LogoutViewController {
        return LogoutViewController(viewModel: self.createLogoutViewModel())
    }

    private func createLogoutViewModel() -> LogoutViewModel {
        return LogoutViewModel(logoutRepository: LogoutRepository(authRepository: authRepository))
    }
}
