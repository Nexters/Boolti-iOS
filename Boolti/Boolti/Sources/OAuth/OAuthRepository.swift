//
//  OAuthRepository.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

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
    
    func resign() -> Observable<String?> {
        var OAuth: OAuth
        
        switch UserDefaults.oauthProvider {
        case OAuthProvider.kakao.rawValue:
            OAuth = KakaoOAuth()
        default:
            OAuth = AppleOAuth()
        }
        return OAuth.resign()
    }
}
