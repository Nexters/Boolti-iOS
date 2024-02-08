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
    var networkService: NetworkProviderType { get }
    func logout() -> Single<Void>
}

final class LogoutRepository: LogoutRepositoryType {

    var networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }

    func logout() -> Single<Void> {
        let api = LogoutAPI.logout
        return self.networkService.request(api)
            .map { _ in return () }
    }
}
