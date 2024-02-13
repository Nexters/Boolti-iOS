//
//  QRAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import Foundation

import Moya

enum QRAPI {
    
    case scannerlist
}

extension QRAPI: ServiceAPI {

    var path: String {
        switch self {
        case .scannerlist:
            return "/api/v1/host/shows"
        }
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }
}
