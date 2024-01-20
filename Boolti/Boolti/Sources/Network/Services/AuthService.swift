//
//  AuthService.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

protocol AuthAPIServiceType {
//    func login() -> Single<Void>
}

final class AuthService: Networking, AuthAPIServiceType {
    
    typealias API = AuthAPI
    
    private let provider = NetworkProvider<API>()
}
