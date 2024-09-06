//
//  EditLinkDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/6/24.
//

import UIKit

final class EditLinkDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createEditLinkViewController(editType: LinkEditType, profileEntity: ProfileEntity) -> EditLinkViewController {
        let viewModel = EditLinkViewModel(authRepository: self.authRepository,
                                          profileEntity: profileEntity)
        let viewController = EditLinkViewController(viewModel: viewModel,
                                                    editType: editType)

        return viewController
    }

}
