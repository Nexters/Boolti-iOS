//
//  AuthAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/22/24.
//

import RxSwift
import Moya

protocol AuthAPIServiceType {

    var networkService: NetworkProviderType { get }
    func fetchTokens() -> AuthToken
    func fetch(withProviderToken providerToken: String, provider: Provider) -> Single<Bool>
    func signUp(provider: Provider, identityToken: String?)
    func write(token: AuthToken)
    func removeAllTokens()

}
