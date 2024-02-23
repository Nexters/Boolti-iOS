//
//  AuthRepository.swift
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
import Kingfisher

final class AuthRepository: AuthRepositoryType {

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
            .do { [weak self] loginReponseDTO in
                guard let accessToken = loginReponseDTO.accessToken,
                      let refreshToken = loginReponseDTO.refreshToken else { return }
                UserDefaults.accessToken = accessToken
                UserDefaults.refreshToken = refreshToken
                UserDefaults.oauthProvider = provider

                self?.userInfo()
                
                if provider == .kakao {
                    self?.setKakaoUserInformation()
                }
            }
            .map { $0.signUpRequired }
    }

    private func setKakaoUserInformation() {
        UserApi.shared.rx.me()
            .subscribe(with: self, onSuccess: { owner, user in

                let email = user.kakaoAccount?.email ?? ""
                let nickName = user.kakaoAccount?.profile?.nickname ?? ""
                let imagePath = user.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? ""

                UserDefaults.userName = nickName
                UserDefaults.userEmail = email
                UserDefaults.userImageURLPath = imagePath
            })
            .disposed(by: self.disposeBag)
    }

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
                let email = user.kakaoAccount?.email ?? ""
                let phoneNumber = user.kakaoAccount?.phoneNumber ?? ""
                let nickName = user.kakaoAccount?.profile?.nickname ?? ""
                let userID = user.id ?? 0
                let imagePath = user.kakaoAccount?.profile?.profileImageUrl?.absoluteString ?? ""

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
            nickname: UserDefaults.userName,
            email: UserDefaults.userEmail,
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
                
                self.userInfo()
            }
            .disposed(by: self.disposeBag)
    }
    
    func logout() -> Single<Void> {
        let api = AuthAPI.logout
        return self.networkService.request(api)
            .do(onSuccess: {  _ in
                UserDefaults.removeAllUserInfo()
            })
            .map { _ in return () }
    }
    
    func userInfo() {
        let api = AuthAPI.user
        return self.networkService.request(api)
            .map(UserResponseDTO.self)
            .subscribe(with: self) { owner, user in
                UserDefaults.userId = user.id
                UserDefaults.userName = user.nickname ?? ""
                UserDefaults.userEmail = user.email ?? ""
                UserDefaults.userImageURLPath = user.imgPath ?? ""
            }
            .disposed(by: self.disposeBag)
    }
    
    func resign(reason: String) -> Single<Void> {
        let api = AuthAPI.resign(requestDTO: ResignRequestDTO(reason: reason))
        
        return self.networkService.request(api)
            .do(onSuccess: {  _ in
                UserDefaults.removeAllUserInfo()
            })
            .map { _ in return () }
    }
}
