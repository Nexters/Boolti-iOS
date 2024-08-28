//
//  SettingDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/23/24.
//

import Foundation

final class SettingDIContainer {

    // 추후 사용 예정
    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createSettingViewController() -> SettingViewController {
        let logoutViewControllerFactory: () -> LogoutViewController = { 
            let DIContainer = LogoutDIContainer(authRepository: self.authRepository)
            let viewController = DIContainer.createLogoutViewController()
            
            return viewController
        }
        
        let resignInfoViewControllerFactory: () -> ResignInfoViewController = {
            let DIContainer = ResignInfoDIContainer(authRepository: self.authRepository)
            let viewController = DIContainer.createResignInfoViewController()
            
            return viewController
        }
        
        return SettingViewController(logoutViewControllerFactory: logoutViewControllerFactory,
                                     resignInfoViewControllerFactory: resignInfoViewControllerFactory)
    }
}
