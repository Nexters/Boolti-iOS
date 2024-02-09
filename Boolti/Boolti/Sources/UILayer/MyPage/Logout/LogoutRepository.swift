//
//  LogoutRepository.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

import RxSwift
import RxMoya

protocol LogoutRepositoryType {
    var authRepository: AuthRepositoryType { get }
    var networkService: NetworkProviderType { get }
    func logout() -> Single<Void>
}

final class LogoutRepository: LogoutRepositoryType {

    var networkService: NetworkProviderType
    var authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
        self.networkService = authRepository.networkService
    }

    func logout() -> Single<Void> {
        let api = AuthAPI.logout
        return self.networkService.request(api)
            .do(onSuccess: { [weak self] _ in
                self?.authRepository.removeAllTokens()
            })
            .map { _ in return () }
    }
}
