//
//  OAuth.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import RxSwift

protocol OAuth {
    func authorize() -> Observable<OAuthResponse>
    func resign() -> Observable<String?>
}
