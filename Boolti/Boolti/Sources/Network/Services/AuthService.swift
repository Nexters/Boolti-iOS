//
//  AuthService.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

protocol AuthAPIServiceType {
    func login(accessToken: String) -> Single<KakaoLoginResponseDTO>
}

final class AuthService: AuthAPIServiceType {
    
    private typealias API = AuthAPI
    private let provider: NetworkProvider
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    func login(accessToken: String) -> Single<KakaoLoginResponseDTO> {
        return provider.request(API.kakaoLogin(requestDTO: KakaoLoginRequestDTO(token: accessToken)))
            .map(KakaoLoginResponseDTO.self)
    }
}
