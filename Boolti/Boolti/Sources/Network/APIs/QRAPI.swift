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
    case qrScan(requestDTO: QRScanRequestDTO)
}

extension QRAPI: ServiceAPI {

    var path: String {
        switch self {
        case .scannerlist:
            return "/api/v1/host/shows"
        case .qrScan:
            return "/api/v1/ticket/entrance"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .scannerlist:
            return .get
        case .qrScan:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .scannerlist:
            return .requestPlain
        case .qrScan(let DTO):
            return .requestJSONEncodable(DTO)
        }
    }
}
