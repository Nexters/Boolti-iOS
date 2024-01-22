//
//  SplashViewModel.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

final class SplashViewModel {
    
    private let networkService: AuthService

    init(networkService: AuthService) {
        self.networkService = networkService
    }
}
