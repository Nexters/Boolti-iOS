//
//  AuthAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/24/24.
//

import Foundation
import Moya

enum AuthAPI {

    case login(provider: Provider, requestDTO: LoginRequestDTO)
    case signup(requestDTO: SignUpRequestDTO)
}

extension AuthAPI: BaseAPI {

    var path: String {
        switch self {
        case .login(let provider, _):
            return "/login/\(provider.rawValue)"
        case .signup:
            return "/signup/sns"
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .signup:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .login(let provider, let DTO):
            let params: [String: Any]
            switch provider {
            case .kakao:
                params = ["accessToken": DTO.token]
            case .apple:
                params = ["idToken": DTO.token]
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
        case .signup(let DTO):
            return .requestJSONEncodable(DTO)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
