//
//  LoginViewModel.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation

final class LoginViewModel {

    private let authAPIService: AuthAPIServiceType
    private let socialLoginAPIService: SocialLoginAPIServiceType

    init(authAPIService: AuthAPIServiceType, socialLoginAPIService: SocialLoginAPIServiceType) {
        self.authAPIService = authAPIService
        self.socialLoginAPIService = socialLoginAPIService
    }

}
