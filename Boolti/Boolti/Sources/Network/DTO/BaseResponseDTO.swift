//
//  BaseResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let data: T?
    
    enum CodingKeys: CodingKey {
        case statusCode
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = (try? container.decode(Int.self, forKey: .statusCode)) ?? 500
        self.message = (try? container.decode(String.self, forKey: .message)) ?? ""
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
