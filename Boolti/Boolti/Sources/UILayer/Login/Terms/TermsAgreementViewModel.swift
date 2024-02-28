//
//  TermsAgreementViewModel.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import Foundation

import RxSwift
import RxRelay

final class TermsAgreementViewModel {

    struct Input {
        var didAgreementButtonTapEvent = PublishSubject<Void>()
    }

    struct Output {
        var didSignUpFinished = PublishRelay<Void>()
    }

    let input: Input
    let output: Output

    private let authRepository: AuthRepositoryType
    private let pushNotificationRepository: PushNotificationRepositoryType
    private let identityCode: String
    private let provider: OAuthProvider

    private let disposeBag = DisposeBag()

    init(identityCode: String, provider: OAuthProvider, authRepository: AuthRepositoryType, pushNotificationRepository: PushNotificationRepositoryType) {
        self.identityCode = identityCode
        self.provider = provider
        self.authRepository = authRepository
        self.pushNotificationRepository = pushNotificationRepository

        self.input = Input()
        self.output = Output()

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.didAgreementButtonTapEvent
            .flatMap({ [weak self] _ -> Single<Void> in
                guard let self = self else { return .just(()) }
                return self.authRepository.signUp(provider: self.provider, identityToken: self.identityCode)
            })
            .subscribe(with: self) { owner, _ in
                owner.pushNotificationRepository.registerDeviceToken()
                owner.output.didSignUpFinished.accept(())
            }
            .disposed(by: self.disposeBag)
    }

    private func registerDeviceToken() {

    }
}
