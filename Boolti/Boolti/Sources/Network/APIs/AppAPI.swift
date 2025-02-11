//
//  AppAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

import Foundation

import Moya

enum AppAPI {
    case popup(route: String)
}

extension AppAPI: ServiceAPI {
    
    var path: String {
        switch self {
        case .popup(let route):
            return "/papi/v1/popup/\(route)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .popup:
            return .requestPlain
        }
    }
    
}
