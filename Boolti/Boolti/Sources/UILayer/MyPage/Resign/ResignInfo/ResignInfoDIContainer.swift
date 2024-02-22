//
//  ResignInfoDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/15/24.
//

import Foundation

final class ResignInfoDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createResignInfoViewController() -> ResignInfoViewController {
        return ResignInfoViewController(viewModel: self.createResignInfoViewModel())
    }

    private func createResignInfoViewModel() -> ResignInfoViewModel {
        return ResignInfoViewModel(authRepository: self.authRepository)
    }
}
