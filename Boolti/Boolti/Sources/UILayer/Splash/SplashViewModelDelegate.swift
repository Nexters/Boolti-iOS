//
//  SplashViewModelDelegate.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation

struct Token {
    var accessToken: String
    var refreshToken: String
}

protocol SplashViewModelDelegate {
    func splashViewModel(_ didSplashViewControllerDismissed: SplashViewModel, with token: Token)
}
