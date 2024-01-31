//
//  TermsAgreementDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import Foundation

final class TermsAgreementDIContainer {

    private let identityCode: String
    private let provider: Provider
    private let authAPIService: AuthAPIServiceType

    init(
        identityCode: String,
        provider: Provider,
        authAPIService: AuthAPIServiceType
    ) {
        self.identityCode = identityCode
        self.provider = provider
        self.authAPIService = authAPIService
    }

    func createTermsAgreementViewController() -> TermsAgreementViewController {
        let viewController = TermsAgreementViewController(viewModel: self.createTermsAgreementViewModel())

        return viewController
    }

    private func createTermsAgreementViewModel() -> TermsAgreementViewModel {
        let viewModel = TermsAgreementViewModel(identityCode: self.identityCode, provider: self.provider, authAPIService: self.authAPIService)

        return viewModel
    }
}
