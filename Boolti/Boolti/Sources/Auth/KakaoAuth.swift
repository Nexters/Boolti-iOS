//
//  KakaoAuth.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift
import RxKakaoSDKAuth
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

struct KakaoAuth: OAuth {

    private let disposeBag = DisposeBag()

    private enum KakaoAuthError: Error {
        case invalidToken
    }

    func authorize() -> Observable<OAuthResponse> {
        return Observable<OAuthResponse>.create { observer in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe { OAuthToken in
                        switch OAuthToken {
                        case .next(let providerToken):
                            observer.onNext(.init(accessToken: providerToken.accessToken, provider: .kakao))
                        case .error:
                            observer.onError(KakaoAuthError.invalidToken)
                        case .completed:
                            print("It's completed")
                        }
                    }
                    .disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe { OAuthToken in
                        switch OAuthToken {
                        case .next(let providerToken):
                            observer.onNext(.init(accessToken: providerToken.accessToken, provider: .kakao))
                        case .error:
                            observer.onError(KakaoAuthError.invalidToken)
                        case .completed:
                            print("It's completed")
                        }
                    }
                    .disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
}
