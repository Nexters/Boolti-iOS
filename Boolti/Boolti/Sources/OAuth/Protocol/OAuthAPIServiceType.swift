//
//  OAuthAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

protocol OAuthAPIServiceType {
    func authorize(provider: OAuthProvider) -> Observable<OAuthResponse>
}
