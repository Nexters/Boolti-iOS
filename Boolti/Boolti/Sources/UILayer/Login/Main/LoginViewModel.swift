//
//  LoginViewModel.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

import KakaoSDKUser
import KakaoSDKAuth
import RxSwift
import RxMoya
import RxRelay

final class LoginViewModel {

    struct Input {
        var loginButtonDidTapEvent = PublishSubject<OAuthProvider>()
    }

    struct Output {
        let didloginFinished = PublishRelay<SignupConditionEntity>()
    }

    let input: Input
    let output: Output

    private let authRepository: AuthRepositoryType
    private let oauthRepository: OAuthRepositoryType
    private let pushNotificationRepository: PushNotificationRepositoryType

    var identityToken: String?
    var provider: OAuthProvider?

    private let disposeBag = DisposeBag()

    init(
        authRepository: AuthRepositoryType,
        oauthRepository: OAuthRepositoryType,
        pushNotificationRepository: PushNotificationRepositoryType
    ) {
        self.authRepository = authRepository
        self.oauthRepository = oauthRepository
        self.pushNotificationRepository = pushNotificationRepository

        self.input = Input()
        self.output = Output()
        self.bindInputs()
    }

    private func bindInputs() {
        self.input.loginButtonDidTapEvent
            .subscribe(with: self) { owner, provider in
                owner.provider = provider
                owner.oauthRepository.authorize(provider: provider)
                    .flatMap({ OAuthResponse -> Single<SignupConditionEntity> in
                        let accessToken = OAuthResponse.accessToken
                        owner.identityToken = accessToken
                        return owner.authRepository.fetch(withProviderToken: accessToken, provider: provider)
                    })
                    .subscribe(with: self) { owner, signupCondition in
                        owner.pushNotificationRepository.registerDeviceToken()
                        owner.output.didloginFinished.accept(signupCondition)
                    }
                    .disposed(by: owner.disposeBag)
                }
            .disposed(by: self.disposeBag)
    }
}
