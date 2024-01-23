//
//  AppleAuth.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

struct AppleAuth: OAuth {
    func authorize() -> Observable<OAuthResponse> {
        return Observable<OAuthResponse>.create { observer in
            return Disposables.create()
        }    }

}
