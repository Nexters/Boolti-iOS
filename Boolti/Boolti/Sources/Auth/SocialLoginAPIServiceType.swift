//
//  SocialLoginAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

struct OAuthResponse {
    let accessToken: String
    let provider: Provider
}


protocol SocialLoginAPIServiceType {
    func authorize(provider: Provider) -> Observable<OAuthResponse>
}
