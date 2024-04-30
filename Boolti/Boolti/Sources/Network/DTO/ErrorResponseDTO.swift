//
//  ErrorResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 5/1/24.
//

struct ErrorResponseDTO: Decodable {
    let errorTraceId: String
    let type: String
    let detail: String
}
