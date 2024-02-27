//
//  PushNotificationAPI.swift
//  Boolti
//
//  Created by Miro on 2/27/24.
//

import Foundation

import Moya

enum PushNotificationAPI {

    case register(requestDTO: DeviceTokenRegisterRequestDTO)
}

extension PushNotificationAPI: ServiceAPI {

    var path: String {
        switch self {
        case .register:
            return "/papi/v1/device-token"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        switch self {
        case .register(let DTO):
            let query: [String: Any] = [
                "deviceToken": DTO.deviceToken,
                "deviceType": DTO.deviceType
            ]
            return .requestParameters(parameters: query, encoding: JSONEncoding.prettyPrinted)
        }
    }
}
