//
//  ASAuthorizationController+Rx.swift
//  Boolti
//
//  Created by Miro on 1/24/24.
//

import RxCocoa
import RxSwift
import AuthenticationServices

final class RxASAuthorizationControllerDelegateProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType, ASAuthorizationControllerDelegate {

    static func registerKnownImplementations() {
        self.register {
            RxASAuthorizationControllerDelegateProxy(parentObject: $0, delegateProxy: self)
        }
    }

    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        return object.delegate
    }

    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
}

extension Reactive where Base: ASAuthorizationController {

    var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
        return RxASAuthorizationControllerDelegateProxy.proxy(for: self.base)
    }

    var identityTokenDelegate: Observable<String?> {
        delegate.methodInvoked(#selector(ASAuthorizationControllerDelegate.authorizationController(controller:didCompleteWithAuthorization:)))
            .map { parameters in
                guard let authorization = parameters[1] as? ASAuthorization,
                      let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                      let appleIdentityToken = appleIDCredential.identityToken
                else { return nil }

                return String(data: appleIdentityToken, encoding: .utf8)
            }
    }

}
