//
//  AppleOAuth.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift
import AuthenticationServices

class AppleOAuth: OAuth {

    enum Error: LocalizedError {
      case userInfoNotFound

      var errorDescription: String? { "애플과의 연결 실패" }
    }

    func authorize() -> Observable<OAuthResponse> {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.performRequests()

        return authorizationController.rx.appleUserInfoDelegate
          .map { userInfo in
            guard let userInfo else { throw Error.userInfoNotFound }
              
              UserDefaults.userName = userInfo.name
              UserDefaults.userEmail = userInfo.email
              
              return OAuthResponse(accessToken: userInfo.identityToken, provider: .apple)
          }
          .compactMap { $0 }
    }
    
    func resign() -> Observable<String?> {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.performRequests()

        return authorizationController.rx.appleUserInfoDelegate
          .map { userInfo in
            guard let userInfo else { throw Error.userInfoNotFound }
              return userInfo.authorizationCode
          }
    }
}
