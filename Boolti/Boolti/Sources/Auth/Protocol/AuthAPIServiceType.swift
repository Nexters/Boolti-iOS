//
//  AuthAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/22/24.
//

import RxSwift
import Moya

protocol AuthAPIServiceType {

    var networkService: Networking { get }
    func fetchTokens() -> AuthToken
    func fetch(withProviderToken providerToken: String, provider: Provider) -> Single<LoginResponseDTO>
    func write(token: AuthToken)
}
