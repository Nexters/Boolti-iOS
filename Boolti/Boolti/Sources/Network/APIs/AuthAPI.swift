//
//  AuthAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/24/24.
//

import Foundation

import Moya

enum AuthAPI {

    case login(provider: OAuthProvider, requestDTO: LoginRequestDTO)
    case logout
    case signup(requestDTO: SignUpRequestDTO)
    case refresh(requestDTO: TokenRefreshRequestDTO)
}

extension AuthAPI: ServiceAPI {
    
    var path: String {
        switch self {
        case .login(let provider, _):
            return "/papi/v1/login/\(provider.rawValue)"
        case .logout:
            return "/v1/logout"
        case .signup:
            return "/papi/v1/signup/sns"
        case .refresh:
            return "/papi/v1/login/refresh"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var headers: [String : String]? {
        switch self {
        case .logout:
            return nil
        case .login, .refresh, .signup:
            return ["Content-Type": "application/json"]
        }
    }

    var task: Task {
        switch self {
        case .login(let provider, let DTO):
            let params: [String: Any]
            switch provider {
            case .kakao:
                params = ["accessToken": DTO.accessToken]
            case .apple:
                params = ["idToken": DTO.accessToken]
            }
            return .requestParameters(parameters: params, encoding: JSONEncoding.prettyPrinted)
        case .logout:
            return .requestPlain
        case .signup(let DTO):
            return .requestJSONEncodable(DTO)
        case .refresh(requestDTO: let DTO):
            return .requestJSONEncodable(DTO)
        }
    }
}
