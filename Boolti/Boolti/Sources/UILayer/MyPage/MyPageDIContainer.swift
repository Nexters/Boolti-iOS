//
//  MyPageDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class MyPageDIContainer {

    private let authAPIService: AuthAPIServiceType

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
    }

    func createMyPageViewController() -> MyPageViewController {
        return MyPageViewController()
    }
}
