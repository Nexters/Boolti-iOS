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

extension LogoutAPI: BaseAPI {

    var baseURL: URL {
        return URL(string: "~/app/v1")!
    }

    var path: String {
        return "/logout"
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
