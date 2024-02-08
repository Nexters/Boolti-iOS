//
//  MyPageDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class MyPageDIContainer {

    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createMyPageViewController() -> MyPageViewController {
        return MyPageViewController()
    }
}
