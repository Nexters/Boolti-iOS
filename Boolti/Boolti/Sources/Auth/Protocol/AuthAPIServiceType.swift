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
    func fetch(withProviderToken providerToken: String, provider: Provider) -> Single<LoginResponseDTO>
    func signUp(provider: Provider)
    func write(token: AuthToken)
}
