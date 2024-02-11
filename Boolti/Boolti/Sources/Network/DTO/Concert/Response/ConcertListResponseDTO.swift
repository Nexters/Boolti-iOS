//
//  ConcertListResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/11/24.
//

import Foundation

struct ConcertListResponseDTOElement: Decodable {
    let id: Int
    let name: String
    let date: String
    let salesStartTime: String
    let salesEndTime: String
    let showImg: String
}

typealias ConcertListResponseDTO = [ConcertListResponseDTOElement]

extension ConcertListResponseDTO {
    
    func convertToConcertEntities() -> [ConcertEntity] {
        return self.map { concert in
            return ConcertEntity(id: concert.id,
                                 name: concert.name,
                                 dateTime: concert.date.formatToDate(),
                                 posterPath: concert.showImg)
        }
    }
}
