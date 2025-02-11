//
//  PopupResponseDTO.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/15/25.
//

import Foundation

struct PopupResponseDTO: Decodable {

    let id: Int
    let type: String
    let eventUrl: String?
    let view: String
    let noticeTitle: String?
    let description: String?
    let startDate: String
    let endDate: String

}

extension PopupResponseDTO {
    
    func convertToPopuptEntities() -> PopupEntity {
        return PopupEntity(id: self.id,
                           type: .init(rawValue: self.type) ?? .event,
                           eventUrl: self.eventUrl ?? "",
                           view: .init(rawValue: self.view) ?? .home,
                           noticeTitle: self.noticeTitle ?? "",
                           emphasisDescription: self.description,
                           description: self.description ?? "",
                           startDate: self.startDate.formatToDate(),
                           endDate: self.endDate.formatToDate())
    }

}
