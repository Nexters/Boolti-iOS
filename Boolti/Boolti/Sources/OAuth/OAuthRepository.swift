//
//  OAuthRepository.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

final class OAuthRepository: OAuthRepositoryType {

    func authorize(provider: OAuthProvider) -> Observable<OAuthResponse> {
        var OAuth: OAuth

        switch provider {
        case .kakao:
            OAuth = KakaoOAuth()
        case .apple:
            OAuth = AppleOAuth()
        }
        return OAuth.authorize()
    }

}
