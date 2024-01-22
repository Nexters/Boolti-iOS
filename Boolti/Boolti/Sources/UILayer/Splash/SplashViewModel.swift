//
//  SplashViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class SplashViewModel {
    
    private let authAPIservice: AuthAPIServiceType
    private let navigationDelegate: SplashViewModelDelegate

    init(authAPIService: AuthAPIServiceType, delegate: SplashViewModelDelegate) {
        self.authAPIservice = authAPIService
        self.navigationDelegate = delegate
    }

    func navigateToHomeTab() {
        navigationDelegate.splashViewModel(self)
    }
}
