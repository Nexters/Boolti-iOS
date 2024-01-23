//
//  SignUpAPI.swift
//  Boolti
//
//  Created by Miro on 1/23/24.
//

import Foundation
import Moya

enum SignUpAPI {

    case kakao(requestDTO: SignUpRequestDTO)
    case apple(requestDTO: SignUpRequestDTO)
}

extension SignUpAPI: BaseAPI {

    var headers: [String : String]? {
        return [ "Content-Type": "application/json" ]
    }

    var path: String {
            return "/signup/sns"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        // 일단 Kakao만
        var parameters: [String: Any] = [:]

        switch self {
        case .kakao(requestDTO: let requestDTO):
            parameters["name"] = requestDTO.name
            parameters["nickname"] = requestDTO.nickname
            parameters["email"] = requestDTO.email
            parameters["phone_number"] = requestDTO.phoneNumber
            parameters["oauth_type"] = requestDTO.OAuthType
            parameters["oauth_identity"] = requestDTO.OAuthIdentity
            parameters["img_path"] = requestDTO.imgPath

            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)

        case .apple(requestDTO: let requestDTO):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }

}
