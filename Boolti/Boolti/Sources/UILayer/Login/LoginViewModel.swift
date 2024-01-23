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
    func loginKakao() {
        self.socialLoginAPIService.authorize(provider: .kakao)
            .flatMapLatest { [weak self] OAuthReponse -> Single<LoginResponseDTO> in
                guard let self else {
                    return Single<LoginResponseDTO>.never()
                }
                // 서버 통신을 통해서 AccessToken과 RefreshToken을 받아온다.
                return self.authAPIService.fetch(withProviderToken: OAuthReponse.accessToken, provider: OAuthReponse.provider)
            }
            .subscribe { _ in
                print("완료")
            }
            .disposed(by: self.disposeBag)
    }

}
