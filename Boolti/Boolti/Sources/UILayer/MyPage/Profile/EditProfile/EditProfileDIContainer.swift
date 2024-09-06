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
        let editLinkViewControllerFactory: (LinkEditType, ProfileEntity) -> EditLinkViewController = { editType, profileEntity in
            let DIContainer = EditLinkDIContainer(authRepository: self.authRepository)
            let viewController = DIContainer.createEditLinkViewController(editType: editType,
                                                                          profileEntity: profileEntity)
            
            return viewController
        }

        let viewModel = EditProfileViewModel(authRepository: self.authRepository)
        let viewController = EditProfileViewController(viewModel: viewModel,
                                                       editLinkViewControllerFactory: editLinkViewControllerFactory)

        return viewController
    }

}
