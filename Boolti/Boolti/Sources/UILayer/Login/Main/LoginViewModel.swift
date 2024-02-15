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

    private let authRepository: AuthRepositoryType
    private let socialLoginAPIService: OAuthRepositoryType

    var identityToken: String?
    var provider: OAuthProvider?

    private let disposeBag = DisposeBag()

    init(authRepository: AuthRepositoryType, socialLoginAPIService: OAuthRepositoryType) {
        self.authRepository = authRepository
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
                        return owner.authRepository.fetch(withProviderToken: accessToken, provider: provider)
                    })
                    .subscribe(with: self) { owner, isSignUpRequired in
                        owner.output.didloginFinished.accept(isSignUpRequired)
                    }
                    .disposed(by: owner.disposeBag)
                }
            .disposed(by: self.disposeBag)
    }
}
