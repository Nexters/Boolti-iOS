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
      case tokenNotFound

      var errorDescription: String? { "애플과의 연결 실패" }
    }

    func authorize() -> Observable<OAuthResponse> {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.performRequests()

        return authorizationController.rx.identityTokenDelegate
          .map { identityToken in
            guard let identityToken else { throw Error.tokenNotFound }
              return OAuthResponse(accessToken: identityToken, provider: .apple)
          }
          .compactMap { $0 }
    }
    
    func resign() -> Observable<Void> {
    }
}
