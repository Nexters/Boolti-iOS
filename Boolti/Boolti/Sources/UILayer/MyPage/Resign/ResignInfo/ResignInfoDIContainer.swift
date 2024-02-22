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
        let resignReasonViewControllerFactory = {
            let DIContainer = self.createResignReasonDIContainer()
            let viewController = DIContainer.createResignReasonViewController()

            return viewController
        }
        
        return ResignInfoViewController(viewModel: self.createResignInfoViewModel(),
                                        resignReasonViewControllerFactory: resignReasonViewControllerFactory)
    }

    private func createResignInfoViewModel() -> ResignInfoViewModel {
        return ResignInfoViewModel(authRepository: self.authRepository)
    }
    
    private func createResignReasonDIContainer() -> ResignReasonDIContainer {
        return ResignReasonDIContainer(authRepository: self.authRepository)
    }
}
