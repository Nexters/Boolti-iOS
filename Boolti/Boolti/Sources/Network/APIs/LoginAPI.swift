//
//  AuthAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import Moya

enum LoginAPI {

    typealias Response = LoginResponseDTO

    // 불티 서버와 통신
    case kakao(requestDTO: LoginRequestDTO)
    case apple(requestDTO: LoginRequestDTO)
}

extension LoginAPI: BaseAPI {

    var path: String {
        switch self {
        case .kakao(_):
            return "/login/kakao"
        case .apple(_):
            return "/login/apple"
        }
    }

    var method: Moya.Method { return .post }

    var task: Task {
        switch self {
        case .kakao(let DTO):
            return .requestParameters(parameters: ["accessToken": DTO.token], encoding: URLEncoding.queryString)
        case .apple(let DTO):
            return .requestParameters(parameters: ["accessToken": DTO.token], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
            return [ "Content-Type": "application/json" ]
    }
}
