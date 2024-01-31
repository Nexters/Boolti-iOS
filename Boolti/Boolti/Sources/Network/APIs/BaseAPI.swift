//
//  BaseAPI.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import Moya

protocol BaseAPI: TargetType {
//    associatedtype Response: Decodable
}

extension BaseAPI {
    
    var baseURL: URL {
        // TODO: base url 키 숨기기, 환경변수로 등록
        return URL(string: "~/app/papi/v1")!
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
