//
//  LoginViewModel.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation
import RxSwift
import RxRelay
import KakaoSDKUser
import KakaoSDKAuth

final class LoginViewModel {

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: SocialLoginAPIServiceType

    private let disposeBag = DisposeBag()

    struct Input {
        var loginButtonDidTapEvent = PublishSubject<Provider>()
    }

    struct Output {
        typealias isFirstSignUp = Bool

        var loginFinished = PublishRelay<isFirstSignUp>()
    }

    let input: Input
    let output: Output

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: SocialLoginAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService

        self.input = Input()
        self.output = Output()
        self.bindInputs()
    }

//    private func bindInputs() {
//        self.input.loginButtonDidTapEvent
//            .subscribe(with: self) { owner, provider in
//                owner.socialLoginAPIService.authorize(provider: provider)
//                    .flatMapLatest { [weak self] OAuthReponse -> Single<LoginResponseDTO> in
//                        guard let self else {
//                            return Single<LoginResponseDTO>.never()
//                        }
//                        // 서버 통신을 통해서 AccessToken과 RefreshToken을 받아온다.
//                        return self.authAPIService.fetch(
//                            withProviderToken: OAuthReponse.accessToken,
//                            provider: OAuthReponse.provider
//                        )
//                    }
//                    .subscribe(with: self, onNext: { owner, loginResponseDTO in
//                        // 그리고 만약 회원가입이 필요하다면 signUp 메소드를 호출!..
//                        if loginResponseDTO.signUpRequired == false {
//                            owner.authAPIService.signUp(provider: provider)
//                        }
//                    })
//                    .disposed(by: owner.disposeBag)
//            }
//            .disposed(by: self.disposeBag)
//    }

    private func bindInputs() {
        self.input.loginButtonDidTapEvent
            .subscribe(with: self) { owner, provider in
                owner.socialLoginAPIService.authorize(provider: provider)
                    .subscribe(with: self) { owner, OAuthReponse in
                        // 만약 singUp을 했다고 가정하자!...
                        var signUped = true

                        if signUped == true { // 회원 가입을 했다!..
                            // 최초 회원 가입 이용약관 동의 팝!
                            owner.output.loginFinished.accept(true)
                        } else {
                            owner.output.loginFinished.accept(false)
                        }
                    }
                    .disposed(by: self.disposeBag)
            }
            .disposed(by: self.disposeBag)
    }
}
