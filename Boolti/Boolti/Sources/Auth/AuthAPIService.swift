//
//  AuthAPIService.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//
import Foundation
import KakaoSDKAuth
import KakaoSDKUser
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
    
    // 로그인 API 활용해서 AccessToken, RefreshToken 가져오기
    func fetch(withProviderToken providerToken: String, provider: Provider) -> Single<isSignUpRequired> {
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
    func signUp(provider: Provider, identityToken: String?) {
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
                guard let email = user.kakaoAccount?.email,
                      let phoneNumber = user.kakaoAccount?.phoneNumber,
                      let nickName = user.kakaoAccount?.name,
                      let userID = user.id,
                      let imgPath = user.kakaoAccount?.profile?.profileImageUrl
                else { return }

                let requestDTO = SignUpRequestDTO(
                    nickname: nickName,
                    email: email,
                    phoneNumber: phoneNumber,
                    oauthType: "KAKAO",
                    oauthIdentity: "\(userID)",
                    imgPath: "\(imgPath)"
                )
                let API = AuthAPI.signup(requestDTO: requestDTO)

                self.requestSignUp(API)

            })
            .disposed(by: self.disposeBag)
    }

    private func signUpApple(with identityToken: String?) {
        guard let identityToken else { return }
        let requestDTO = SignUpRequestDTO(
            nickname: nil,
            email: nil,
            phoneNumber: nil,
            oauthType: "APPLE",
            oauthIdentity: identityToken,
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
