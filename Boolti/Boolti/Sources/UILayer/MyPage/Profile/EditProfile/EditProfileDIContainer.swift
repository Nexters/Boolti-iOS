//
//  EditProfileDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import UIKit

final class EditProfileDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createEditProfileViewController() -> EditProfileViewController {
        let viewModel = EditProfileViewModel(authRepository: self.authRepository)
        let viewController = EditProfileViewController(viewModel: viewModel)

        return viewController
    }

}
