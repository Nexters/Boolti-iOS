//
//  SplashViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class SplashViewModel {
    
    private let authAPIservice: AuthAPIServiceType
    private let delegate: SplashViewViewModelDelegate

    init(authAPIService: AuthAPIServiceType, delegate: SplashViewViewModelDelegate) {
        self.authAPIservice = authAPIService
        self.delegate = delegate
    }

    func navigateToHomeTab() {
        delegate.splashViewViewModel(self)
    }
}
