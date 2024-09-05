//
//  AuthRepository.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

import RxSwift
import KakaoSDKUser
import RxKakaoSDKUser
import SwiftJWT

protocol AuthRepositoryType {

    var networkService: NetworkProviderType { get }
    func fetchTokens() -> (String, String)
    func fetch(withProviderToken providerToken: String, provider: OAuthProvider) -> Single<SignupConditionEntity>
    func signUp(provider: OAuthProvider, identityToken: String?) -> Single<Void>
    func logout() -> Single<Void>
    func userInfo() -> Single<Void>
    func userProfile() -> Single<UserResponseDTO>
    func resign(reason: String, appleIdAuthorizationCode: String?) -> Single<Void>
    func fetchProfile(profileImageUrl: String, nickname: String, introduction: String, links: [LinkEntity]) -> Single<Void>
}

final class AuthRepository: AuthRepositoryType {

    typealias AuthToken = (String, String)

    let networkService: NetworkProviderType
    private let disposeBag = DisposeBag()

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func fetchTokens() -> AuthToken {
        return (UserDefaults.accessToken, UserDefaults.refreshToken)
    }
    
    func fetch(withProviderToken providerToken: String, provider: OAuthProvider) -> Single<SignupConditionEntity> {
        let loginRequestDTO = LoginRequestDTO(accessToken: providerToken)
        let api = AuthAPI.login(provider: provider, requestDTO: loginRequestDTO)

        return networkService.request(api)
            .map(LoginResponseDTO.self)
            .do { [weak self] loginReponseDTO in
                guard let self = self else { return }
                guard let accessToken = loginReponseDTO.accessToken,
                      let refreshToken = loginReponseDTO.refreshToken else { return }
                UserDefaults.accessToken = accessToken
                UserDefaults.refreshToken = refreshToken
                UserDefaults.oauthProvider = provider

                self.userInfo().subscribe(onSuccess: { _ in
                    debugPrint("UserAPI Success")
                })
                .disposed(by: self.disposeBag)

                if provider == .kakao {
                    self.setKakaoUserInformation()
                }
            }
            .map { SignupConditionEntity(isSignUpRequired: $0.signUpRequired,
                                         removeCancelled: $0.removeCancelled ?? false) }
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

    func signUp(provider: OAuthProvider, identityToken: String?) -> Single<Void> {
        switch provider {
        case .kakao:
            self.signUpKakao()
        case .apple:
            self.signUpApple(with: identityToken)
        }
    }

    private func signUpKakao() -> Single<Void> {
        UserApi.shared.rx.me()
            .flatMap { user in
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
                return self.requestSignUp(API)
            }
    }

    private func signUpApple(with identityToken: String?) -> Single<Void> {
        guard let identityToken else { return .just(())}

        guard let jwt = try? JWT<IdentityTokenDTO>(jwtString: identityToken) else { return .just(()) }
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

        return self.requestSignUp(API)
    }

    private func requestSignUp(_ API: AuthAPI) -> Single<Void> {
        return self.networkService.request(API)
            .map(SignUpResponseDTO.self)
            .flatMap({ signUpResponseDTO in
                guard let accessToken = signUpResponseDTO.accessToken,
                      let refreshToken = signUpResponseDTO.refreshToken else { return .just(())}

                UserDefaults.accessToken = accessToken
                UserDefaults.refreshToken = refreshToken

                return self.userInfo()
            })
    }
    
    func logout() -> Single<Void> {
        let api = AuthAPI.logout
        return self.networkService.request(api)
            .do(onSuccess: {  _ in
                UserDefaults.removeAllUserInfo()
            })
            .map { _ in return () }
    }
    
    func userInfo() -> Single<Void> {
        let api = AuthAPI.user
        return self.networkService.request(api)
            .map(UserResponseDTO.self)
            .flatMap({ user -> Single<Void> in
                UserDefaults.userId = user.id
                UserDefaults.userName = user.nickname ?? ""
                UserDefaults.userCode = user.userCode ?? ""
                UserDefaults.userEmail = user.email ?? ""
                UserDefaults.userImageURLPath = user.imgPath ?? ""

                return .just(())
            })
    }
    
    func userProfile() -> Single<UserResponseDTO> {
        let api = AuthAPI.user
        return self.networkService.request(api)
            .map(UserResponseDTO.self)
            .flatMap({ user -> Single<UserResponseDTO> in
                UserDefaults.userName = user.nickname ?? ""
                UserDefaults.userImageURLPath = user.imgPath ?? ""

                return .just(user)
            })
    }
    
    func resign(reason: String, appleIdAuthorizationCode: String?) -> Single<Void> {
        let api = AuthAPI.resign(requestDTO: ResignRequestDTO(reason: reason,
                                                              appleIdAuthorizationCode: appleIdAuthorizationCode))
        
        return self.networkService.request(api)
            .do(onSuccess: {  _ in
                UserDefaults.removeAllUserInfo()
            })
            .map { _ in return () }
    }
    
    func fetchProfile(profileImageUrl: String, nickname: String, introduction: String, links: [LinkEntity]) -> Single<Void> {
        let api = AuthAPI.fetchProfile(requestDTO: EditProfileRequestDTO(nickname: nickname,
                                                                         profileImagePath: profileImageUrl,
                                                                         introduction: introduction,
                                                                         link: links))
        return self.networkService.request(api)
            .map(UserResponseDTO.self)
            .flatMap({ user -> Single<Void> in
                UserDefaults.userName = user.nickname ?? ""
                UserDefaults.userImageURLPath = user.imgPath ?? ""
                return .just(())
            })
    }

}
