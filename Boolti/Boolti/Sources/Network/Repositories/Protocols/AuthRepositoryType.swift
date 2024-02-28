//
//  AuthRepositoryType.swift
//  Boolti
//
//  Created by Miro on 1/22/24.
//

import RxSwift
import Moya

protocol AuthRepositoryType {

    var networkService: NetworkProviderType { get }
    func fetchTokens() -> (String, String)
    func fetch(withProviderToken providerToken: String, provider: OAuthProvider) -> Single<SignupConditionEntity>
    func signUp(provider: OAuthProvider, identityToken: String?) -> Single<Void>
    func logout() -> Single<Void>
    func userInfo() -> Single<Void>
    func resign(reason: String, appleIdAuthorizationCode: String?) -> Single<Void>
}
