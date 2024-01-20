//
//  AuthAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import Moya

enum AuthAPI {
    // 불티 서버와 통신
    case kakaoLogin(requestDTO: KakaoLoginRequestDTO)
}

extension AuthAPI: BaseAPI {

    var path: String {
        switch self {
        case .kakaoLogin:
            return "/login/kakao"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .kakaoLogin(let requestDTO):
            return .requestJSONEncodable(requestDTO)
        }
    }
}
