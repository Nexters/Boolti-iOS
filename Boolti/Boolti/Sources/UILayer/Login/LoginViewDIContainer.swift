//
//  LoginViewDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

final class LoginViewDIContainer {

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: SocialLoginAPIServiceType

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: SocialLoginAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService
    }

    func createLoginViewController() -> LoginViewController {
        let viewController = LoginViewController(viewModel: createLoginViewModel())

        return viewController
    }

    private func createLoginViewModel() -> LoginViewModel {
        let viewModel = LoginViewModel(
            authAPIService: self.authAPIService,
            socialLoginAPIService: self.socialLoginAPIService
        )

        return viewModel
    }
}
