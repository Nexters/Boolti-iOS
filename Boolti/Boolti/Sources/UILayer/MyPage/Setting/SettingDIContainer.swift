//
//  SettingDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 7/23/24.
//

import Foundation

final class SettingDIContainer {

    // 추후 사용 예정
    private let authRepository: AuthRepositoryType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }

    func createSettingViewController() -> SettingViewController {
        return SettingViewController()
    }
}
