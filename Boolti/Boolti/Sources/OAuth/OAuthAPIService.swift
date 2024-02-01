//
//  OAuthAPIService.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

final class OAuthAPIService: OAuthAPIServiceType {

    func authorize(provider: OAuthProvider) -> Observable<OAuthResponse> {
        var OAuth: OAuth

        switch provider {
        case .kakao:
            OAuth = KakaoAuth()
        case .apple:
            OAuth = AppleAuth()
        }
        return OAuth.authorize()
    }

}
