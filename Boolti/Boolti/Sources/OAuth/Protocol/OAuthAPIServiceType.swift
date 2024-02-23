//
//  OAuthRepositoryType.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

protocol OAuthRepositoryType {
    func authorize(provider: OAuthProvider) -> Observable<OAuthResponse>
    func resign() -> Observable<Void>
}
