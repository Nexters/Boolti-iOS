//
//  ProfileDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

final class ProfileDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createProfileViewController() -> ProfileViewController {
        let editProfileViewControllerFactory = {
            let DIContainer = EditProfileDIContainer(authRepository: self.authRepository)
            let viewController = DIContainer.createEditProfileViewController()
            
            return viewController
        }
        
        let viewModel = ProfileViewModel(authRepository: self.authRepository)
        let viewController = ProfileViewController(viewModel: viewModel,
                                                   editProfileViewControllerFactory: editProfileViewControllerFactory)

        return viewController
    }

}