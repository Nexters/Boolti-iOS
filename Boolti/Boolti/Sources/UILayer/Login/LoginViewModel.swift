//
//  LoginViewModel.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation
import RxSwift
import KakaoSDKUser
import KakaoSDKAuth

final class LoginViewModel {

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: SocialLoginAPIServiceType
    private let disposeBag = DisposeBag()

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: SocialLoginAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService
    }

    // TODO: Input Ouput 모델로 변경할 예정!..
    // TODO: 분기처리도 해야함!...
    func login(with provider: Provider) {
        // 카카오 로그인을 한다..
        // 카카오 로그인을 통해서 받아온 토큰을 통해서 서버와 login 통신을 한다.
        // 만약 login 통신을 했는데, 회원가입을 안했다면, 서버와 signup 통신을 한다.
        self.socialLoginAPIService.authorize(provider: provider)
            .flatMapLatest { [weak self] OAuthReponse -> Single<LoginResponseDTO> in
                guard let self else {
                    return Single<LoginResponseDTO>.never()
                }
                // 서버 통신을 통해서 AccessToken과 RefreshToken을 받아온다.
                return self.authAPIService.fetch(withProviderToken: OAuthReponse.accessToken, provider: OAuthReponse.provider)
            }
            .subscribe(onNext: { loginResponseDTO in
                // 그리고 만약 회원가입이 필요하다면 signUp 메소드를 호출!..
                if loginResponseDTO.signUpRequired == false {
                    self.authAPIService.signUp(provider: provider)
                }
            })
            .disposed(by: self.disposeBag)
    }

}
