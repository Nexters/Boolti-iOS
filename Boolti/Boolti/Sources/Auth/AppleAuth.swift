//
//  AppleAuth.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift
import AuthenticationServices

class AppleAuth: NSObject, OAuth {

    func authorize() -> Observable<OAuthResponse> {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.performRequests()
        return authorizationController.rx.identityTokenDelegate
          .map { identityToken in
            guard let identityToken = identityToken else { throw Error.tokenDidNotFetched }
              return OAuthResponse(accessToken: identityToken, provider: .apple)
          }
          .asObservable()
          .compactMap { $0 }
    }

    enum Error: LocalizedError {
      case tokenDidNotFetched

      var errorDescription: String? { "애플과 연결을 실패했습니다." }
    }
}
