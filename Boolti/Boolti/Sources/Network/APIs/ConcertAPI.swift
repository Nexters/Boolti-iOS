//
//  ConcertAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/7/24.
//

import Foundation

import Moya

enum ConcertAPI {

    case list(requesDTO: ConcertListRequestDTO)
    case detail(requestDTO: ConcertDetailRequestDTO)
    case castTeamList(requestDTO: ConcertCastTeamListRequestDTO)
}

extension ConcertAPI: ServiceAPI {

    var path: String {
        switch self {
        case .list:
            return "/papi/v1/shows/search"
        case .detail(let DTO):
            return "/papi/v1/show/\(DTO.id)"
        case .castTeamList(let DTO):
            return "/papi/v1/shows/\(DTO.showID)/cast-teams"
        }
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Moya.Task {
        switch self {
        case .list(let DTO):
            let query: [String: Any] = [
                "nameLike": DTO.nameLike ?? ""
            ]
            return .requestParameters(parameters: query, encoding: URLEncoding.queryString)
        default:
            return .requestPlain
        }
    }
}
