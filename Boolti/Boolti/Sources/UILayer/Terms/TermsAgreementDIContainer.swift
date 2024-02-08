//
//  TermsAgreementDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import Foundation

final class TermsAgreementDIContainer {

    private let identityCode: String
    private let provider: OAuthProvider
    private let authRepository: AuthRepositoryType

    init(
        identityCode: String,
        provider: OAuthProvider,
        authRepository: AuthRepositoryType
    ) {
        self.identityCode = identityCode
        self.provider = provider
        self.authRepository = authRepository
    }

    func createTermsAgreementViewController() -> TermsAgreementViewController {
        let viewController = TermsAgreementViewController(viewModel: self.createTermsAgreementViewModel())

        return viewController
    }

    private func createTermsAgreementViewModel() -> TermsAgreementViewModel {
        let viewModel = TermsAgreementViewModel(identityCode: self.identityCode, provider: self.provider, authRepository: self.authRepository)

        return viewModel
    }
}
