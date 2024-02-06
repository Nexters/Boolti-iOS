//
//  LogoutAPI.swift
//  Boolti
//
//  Created by Miro on 1/31/24.
//

import Foundation
import Moya

enum LogoutAPI {

    case logout
}

extension LogoutAPI: ServiceAPI {

    var path: String {
        return "/v1/logout"
    }

    var method: Moya.Method {
        return .post
    }

    var task: Moya.Task {
        return .requestPlain
    }

    var headers: [String : String]? {
        return nil
    }
}
