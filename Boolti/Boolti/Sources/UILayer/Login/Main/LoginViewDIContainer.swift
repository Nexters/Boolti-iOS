//
//  LoginViewDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

final class LoginViewDIContainer {

    private let authRepository: AuthRepositoryType
    private let socialLoginAPIService: OAuthRepositoryType

    init(authRepository: AuthRepositoryType, socialLoginAPIService: OAuthRepositoryType) {
        self.authRepository = authRepository
        self.socialLoginAPIService = socialLoginAPIService
    }

    func createLoginViewController() -> LoginViewController {

        let termsAgreementControllerFactory: (String, OAuthProvider) -> TermsAgreementViewController = { identityCode, provider in
            let DIContainer = self.createTermsAgreementViewDIContainer(identityCode: identityCode, provider: provider)

            let viewController = DIContainer.createTermsAgreementViewController()
            return viewController
        }

        let viewController = LoginViewController(viewModel: createLoginViewModel(), termsAgreementControllerFactory: termsAgreementControllerFactory)

        return viewController
    }

    private func createLoginViewModel() -> LoginViewModel {
        let viewModel = LoginViewModel(
            authRepository: self.authRepository,
            socialLoginAPIService: self.socialLoginAPIService
        )

        return viewModel
    }

    private func createTermsAgreementViewDIContainer(identityCode: String, provider: OAuthProvider) -> TermsAgreementDIContainer {
        return TermsAgreementDIContainer(identityCode: identityCode, provider: provider ,authRepository: self.authRepository)
    }
}
