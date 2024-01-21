//
//  RxMoya+.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation
import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    /// Wrap to common response
    /// - Common response로 감싼 객체로 매핑해주는 메소드
    func map<Response: Decodable>(
        _ type: Response.Type
    ) -> PrimitiveSequence<Trait, BaseResponseDTO<Response>> {
        return map(BaseResponseDTO<Response>.self, using: decoder)
    }

    /// Map to pure
    /// - Pure data로 매핑해주는 메소드
    /// - 옵셔널 타입으로 반환합니다.
    /*
    - statusCode
    - message
    - data? <- Pure data in our service
    */
    func map<Response: Decodable>(
        _ type: Response.Type
    ) -> PrimitiveSequence<Trait, Response?> {
        return map(Response.self).map { $0.data }
    }
}
