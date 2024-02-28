//
//  ServiceAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

import Moya

protocol ServiceAPI: TargetType {
}

extension ServiceAPI {
    var baseURL: URL {
        return URL(string: Environment.BASE_URL)!
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }

    var validationType: ValidationType {
        return .successCodes
    }
}
