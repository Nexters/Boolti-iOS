//
//  AuthAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/22/24.
//

import Foundation
import RxSwift
import Moya

enum Provider: String {
    case apple
    case kakao
}

protocol AuthAPIServiceType {

    var networkService: Networking { get }
    func fetchTokens() -> Token
    func fetch(withProviderToken providerToken: String, provider: Provider) -> Single<LoginResponseDTO>
    func write(token: Token)
}
