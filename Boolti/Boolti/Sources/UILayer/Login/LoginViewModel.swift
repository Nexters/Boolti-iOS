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

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: SocialLoginAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService
    }
    // TODO: Input Ouput 모델로 변경할 예정!..
    func loginKakao() {
        if UserApi.isKakaoTalkLoginAvailable() {
            self.loginWithKakaoApp()
        } else {
            self.loginWithKakaoAccount()
        }
    }

    func loginWithKakaoApp() {
        UserApi.shared.loginWithKakaoTalk { oauthToken, error in
            guard error != nil else { return }

            let accessToken = oauthToken?.accessToken

            print("loginWithKakaoApp 성공!..")
        }
    }

    func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount { oauthToken, error in
            guard error != nil else { return }

            print("loginWithKakaoApp 성공!..")
        }
    }



}
