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

    let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func fetchTokens() -> AuthToken {
        return AuthToken(accessToken: UserDefaults.accessToken, refreshToken: UserDefaults.refreshToken)
    }

    func fetch(withProviderToken providerToken: String, provider: Provider) -> Single<LoginResponseDTO> {
        let loginAPI: LoginAPI
        let loginRequestDTO = LoginRequestDTO(token: providerToken)

        switch provider {
        case .kakao:
            loginAPI = LoginAPI.kakao(requestDTO: loginRequestDTO)
        case .apple:
            loginAPI = LoginAPI.apple(requestDTO: loginRequestDTO)
        }

        return networkService.request(loginAPI)
            .map(LoginResponseDTO.self)
            .do { [weak self] loginReponseDTO in
                guard let accessToken = loginReponseDTO.accessToken,
                      let refreshToken = loginReponseDTO.refreshToken else { return }

                let authToken = AuthToken(accessToken: accessToken, refreshToken: refreshToken)
                self?.write(token: authToken)
            }
    }

    // MARK: Kakao만 생각!..


    // 유저의 정보를 가져와서 서버와 회원가입 API 통신을 한다.
    func signUp(provider: Provider) {
        UserApi.shared.rx.me()
            .subscribe(with: self, onSuccess: { owner, user in
                guard let email = user.kakaoAccount?.email,
                      let name = user.kakaoAccount?.legalName,
                      let phoneNumber = user.kakaoAccount?.phoneNumber,
                      let nickName = user.kakaoAccount?.name,
                      let userID = user.id,
                      let imgPath = user.kakaoAccount?.profile?.profileImageUrl
                else {
                    return
                }

                self.signInUser(
                    name: name,
                    nickName: nickName,
                    email: email,
                    phoneNumber: phoneNumber,
                    OAuthType: "KAKAO",
                    OAuthIdentity: "\(userID)",
                    imagePath: "\(imgPath)"
                )
            })
            .disposed(by: self.disposeBag)
    }

    private func signInUser(
        name: String?,
        nickName: String,
        email: String?,
        phoneNumber: String?,
        OAuthType: String,
        OAuthIdentity: String,
        imagePath: String?
    ) {

        let requestDTO = SignUpRequestDTO(
            name: name,
            nickname: nickName,
            email: email,
            phoneNumber: phoneNumber,
            OAuthType: OAuthType,
            OAuthIdentity: OAuthIdentity,
            imgPath: imagePath
        )

        let signUpAPI = SignUpAPI.kakao(requestDTO: requestDTO)

        self.networkService.request(signUpAPI)
            .map(SignUpResponseDTO.self)
            .subscribe { [weak self] signUpResponseDTO in
                guard let accessToken = signUpResponseDTO.accessToken,
                      let refreshToken = signUpResponseDTO.refreshToken else { return }

                let authToken = AuthToken(accessToken: accessToken, refreshToken: refreshToken)
                self?.write(token: authToken)
            }
            .disposed(by: self.disposeBag)
    }

    func write(token: AuthToken) {
        UserDefaults.accessToken = token.accessToken
        UserDefaults.refreshToken = token.refreshToken
    }

    func removeAllTokens() {
        UserDefaults.removeAllTokens()
    }
}
