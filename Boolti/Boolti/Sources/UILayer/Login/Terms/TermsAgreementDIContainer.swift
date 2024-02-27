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
    private let pushNotificationRepository: PushNotificationRepositoryType

    init(
        identityCode: String,
        provider: OAuthProvider,
        authRepository: AuthRepositoryType,
        pushNotificationRepository: PushNotificationRepositoryType
    ) {
        self.identityCode = identityCode
        self.provider = provider
        self.authRepository = authRepository
        self.pushNotificationRepository = pushNotificationRepository
    }

    func createTermsAgreementViewController() -> TermsAgreementViewController {
        let viewController = TermsAgreementViewController(viewModel: self.createTermsAgreementViewModel())

        return viewController
    }

    private func createTermsAgreementViewModel() -> TermsAgreementViewModel {
        let viewModel = TermsAgreementViewModel(
            identityCode: self.identityCode,
            provider: self.provider,
            authRepository: self.authRepository,
            pushNotificationRepository: self.pushNotificationRepository
        )

        return viewModel
    }
}
