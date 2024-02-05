//
//  AuthAPIService.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import SwiftJWT

import RxKakaoSDKUser
import RxSwift
import RxMoya

final class AuthAPIService: AuthAPIServiceType {

    typealias isSignUpRequired = Bool
    typealias AuthToken = (String, String)

    let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func fetchTokens() -> AuthToken {
        return (UserDefaults.accessToken, UserDefaults.refreshToken)
    }
    
    func fetch(withProviderToken providerToken: String, provider: OAuthProvider) -> Single<isSignUpRequired> {
        let loginRequestDTO = LoginRequestDTO(accessToken: providerToken)
        let api = AuthAPI.login(provider: provider, requestDTO: loginRequestDTO)

        return networkService.request(api)
            .map(LoginResponseDTO.self)
            .do { loginReponseDTO in
                guard let accessToken = loginReponseDTO.accessToken,
                      let refreshToken = loginReponseDTO.refreshToken else { return }
                UserDefaults.accessToken = accessToken
                UserDefaults.refreshToken = refreshToken
            }
            .map { $0.signUpRequired }
    }

    // 회원가입 API 활용해서 AccessToken, RefreshToken 가져오기
    func signUp(provider: OAuthProvider, identityToken: String?) {
        switch provider {
        case .kakao:
            self.signUpKakao()
        case .apple:
            self.signUpApple(with: identityToken)
        }
    }

    private func signUpKakao() {
        UserApi.shared.rx.me()
            .subscribe(with: self, onSuccess: { owner, user in
                guard let email = user.kakaoAccount?.email else { return }
                guard let phoneNumber = user.kakaoAccount?.phoneNumber else { return }
                guard let nickName = user.kakaoAccount?.name else { return }
                guard let userID = user.id else { return }
                guard let imagePath = user.kakaoAccount?.profile?.profileImageUrl?.absoluteString else { return }

                let requestDTO = SignUpRequestDTO(
                    nickname: nickName,
                    email: email,
                    phoneNumber: phoneNumber,
                    oauthType: "KAKAO",
                    oauthIdentity: String(userID),
                    imgPath: imagePath
                )

                let API = AuthAPI.signup(requestDTO: requestDTO)
                owner.requestSignUp(API)
            })
            .disposed(by: self.disposeBag)
    }

    private func signUpApple(with identityToken: String?) {
        guard let identityToken else { return }

        guard let jwt = try? JWT<IdentityTokenDTO>(jwtString: identityToken) else { return }
        let oauthIdentity = jwt.claims.sub

        let requestDTO = SignUpRequestDTO(
            nickname: nil,
            email: nil,
            phoneNumber: nil,
            oauthType: "APPLE",
            oauthIdentity: oauthIdentity,
            imgPath: nil
        )
        let API = AuthAPI.signup(requestDTO: requestDTO)

        self.requestSignUp(API)
    }

    private func requestSignUp(_ API: AuthAPI) {
        self.networkService.request(API)
            .map(SignUpResponseDTO.self)
            .subscribe { signUpResponseDTO in
                guard let accessToken = signUpResponseDTO.accessToken,
                      let refreshToken = signUpResponseDTO.refreshToken else { return }
                
                UserDefaults.accessToken = accessToken
                UserDefaults.refreshToken = refreshToken
            }
            .disposed(by: self.disposeBag)
    }


    func removeAllTokens() {
        UserDefaults.removeAllTokens()
    }
}
