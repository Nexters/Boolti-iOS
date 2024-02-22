//
//  ResignReasonDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/22/24.
//

import Foundation

final class ResignReasonDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createResignReasonViewController() -> ResignReasonViewController {
        return ResignReasonViewController(viewModel: self.createResignReasonViewModel())
    }

    private func createResignReasonViewModel() -> ResignReasonViewModel {
        return ResignReasonViewModel(authRepository: self.authRepository)
    }
}
