//
//  LoginViewDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

final class LoginViewDIContainer {

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: OAuthAPIServiceType

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: OAuthAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService
    }

    func createLoginViewController() -> LoginViewController {

        let termsAgreementControllerFactory: (String, OAuthProvider) -> TermsAgreementViewController = { identityCode, provider in
            let DIContainer = self.createTermsAgreementViewDIContainer(identityCode: identityCode, provider: provider)

            let viewController = DIContainer.createTermsAgreementViewController()
            return viewController
        }

        let viewController = LoginViewController(viewModel: createLoginViewModel(), termsAgreementViewControllerFactory: termsAgreementControllerFactory)

        return viewController
    }

    private func createLoginViewModel() -> LoginViewModel {
        let viewModel = LoginViewModel(
            authAPIService: self.authAPIService,
            socialLoginAPIService: self.socialLoginAPIService
        )

        return viewModel
    }

    private func createTermsAgreementViewDIContainer(identityCode: String, provider: OAuthProvider) -> TermsAgreementDIContainer {
        return TermsAgreementDIContainer(identityCode: identityCode, provider: provider ,authAPIService: self.authAPIService)
    }
}
