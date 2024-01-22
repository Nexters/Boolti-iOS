//
//  AuthAPIServiceType.swift
//  Boolti
//
//  Created by Miro on 1/22/24.
//

import Foundation
import Moya
import RxSwift

protocol AuthAPIServiceType {
    func login(accessToken: String) -> Single<KakaoLoginResponseDTO>
}
