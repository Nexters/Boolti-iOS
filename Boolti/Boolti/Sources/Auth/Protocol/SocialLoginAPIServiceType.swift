//
//  SocialLoginAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

protocol SocialLoginAPIServiceType {
    func authorize(provider: Provider) -> Observable<OAuthResponse>
}
