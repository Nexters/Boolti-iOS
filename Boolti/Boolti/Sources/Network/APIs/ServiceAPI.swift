//
//  ServiceAPI.swift
//  Boolti
//
//  Created by Miro on 1/31/24.
//

import Foundation

protocol ServiceAPI: BaseAPI {

}

extension ServiceAPI {
    
    var baseURL: URL {
        // TODO: base url 키 숨기기, 환경변수로 등록
        return URL(string: Environment.BASE_URL)!
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
