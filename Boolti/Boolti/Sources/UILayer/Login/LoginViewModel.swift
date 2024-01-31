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
        var loginButtonDidTapEvent = PublishSubject<Provider>()
    }

    struct Output {
        typealias didSignedUp = Bool

        var didloginFinished = PublishRelay<didSignedUp>()
    }

    let input: Input
    let output: Output

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: SocialLoginAPIServiceType

    private let disposeBag = DisposeBag()
    private var identityToken: String?

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: SocialLoginAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService

        self.input = Input()
        self.output = Output()
        self.bindInputs()
    }

    private func bindInputs() {
        self.input.loginButtonDidTapEvent
            .subscribe(with: self) { owner, provider in
                // 먼저 카카오 로그인을 통해서 accesstoken을 받아오기
                owner.socialLoginAPIService.authorize(provider: provider)
                    .flatMap({ OAuthResponse -> Single<Bool> in
                        let accessToken = OAuthResponse.accessToken
                        owner.identityToken = accessToken
                        return owner.authAPIService.fetch(withProviderToken: accessToken, provider: provider)
                    })
                    .subscribe(with: self) { owner, isSignUpRequired in
                        if isSignUpRequired { // 회원가입이 필요하다.
                            guard let identityToken = owner.identityToken else { return }
                            owner.authAPIService.signUp(provider: provider, identityToken: identityToken)
                            owner.output.didloginFinished.accept(false)
                        } else { // 회원가입이 필요없다.
                            owner.output.didloginFinished.accept(true)
                        }
                    }
                    .disposed(by: owner.disposeBag)
                }
            .disposed(by: self.disposeBag)
    }
}
