//
//  KakaoOAuth.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift
import KakaoSDKAuth
import KakaoSDKUser

struct KakaoOAuth: OAuth {

    private enum KakaoAuthError: Error {
        case invalidToken
    }

    func authorize() -> Observable<OAuthResponse> {
        return Observable<OAuthResponse>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk { OAuthToken, error in
                    if let error = error {
                        observer.onError(error)
                    }
                    guard let accessToken = OAuthToken?.accessToken else {
                        observer.onError(KakaoAuthError.invalidToken)
                        return
                    }
                    observer.onNext(.init(accessToken: accessToken, provider: .kakao))
                    observer.onCompleted()
                }
            } else {
                UserApi.shared.loginWithKakaoAccount() { OAuthToken, error in
                    if let error = error {
                        observer.onError(error)
                    }
                    guard let accessToken = OAuthToken?.accessToken else {
                        observer.onError(KakaoAuthError.invalidToken)
                        return
                    }
                    observer.onNext(.init(accessToken: accessToken, provider: .kakao))
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func resign() -> Observable<String?> {
        return Observable<String?>.create { observer in
            UserApi.shared.unlink {(error) in
                if let error = error {
                    observer.onError(error)
                }
                else {
                    observer.onNext(nil)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
