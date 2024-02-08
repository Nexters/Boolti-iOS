//
//  ConcertAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import Moya

enum ConcertAPI {

    case detail(requestDTO: ConcertDetailRequestDTO)
}

extension ConcertAPI: ServiceAPI {

    var path: String {
        switch self {
        case .detail(let DTO):
            return "/papi/v1/show/\(DTO.id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        return .requestPlain
    }
}
