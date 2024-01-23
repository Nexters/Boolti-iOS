//
//  AuthAPIService.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation
import RxSwift
import RxMoya


final class AuthAPIService: AuthAPIServiceType {

    let networkService: NetworkProviderType

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

    func write(token: AuthToken) {
        UserDefaults.accessToken = token.accessToken
        UserDefaults.refreshToken = token.refreshToken
    }

    func removeAllTokens() {
        UserDefaults.removeAllTokens()
    }
}
