//
//  ResignDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import Foundation

final class ResignDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createResignViewController() -> ResignViewController {
        return ResignViewController(viewModel: self.createResignViewModel())
    }

    private func createResignViewModel() -> ResignViewModel {
        return ResignViewModel(authRepository: self.authRepository)
    }
}
