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
        typealias didSignedUp = Bool
        var didloginFinished = PublishRelay<didSignedUp>()
    }

    let input: Input
    let output: Output

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: OAuthAPIServiceType

    var identityToken: String?
    var provider: OAuthProvider?

    private let disposeBag = DisposeBag()

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: OAuthAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService
        
        self.input = Input()
        self.output = Output()
        self.bindInputs()
    }

    private func bindInputs() {
        self.input.loginButtonDidTapEvent
            .subscribe(with: self) { owner, provider in
                owner.provider = provider
                owner.socialLoginAPIService.authorize(provider: provider)
                    .flatMap({ OAuthResponse -> Single<Bool> in
                        let accessToken = OAuthResponse.accessToken
                        owner.identityToken = accessToken
                        return owner.authAPIService.fetch(withProviderToken: accessToken, provider: provider)
                    })
                    .subscribe(with: self) { owner, isSignUpRequired in
                        if isSignUpRequired {
                            owner.output.didloginFinished.accept(true)
                        } else {
                            owner.output.didloginFinished.accept(false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
                }
            .disposed(by: self.disposeBag)
    }
}
