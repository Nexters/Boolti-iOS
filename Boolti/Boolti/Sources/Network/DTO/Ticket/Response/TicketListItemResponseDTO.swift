//
//  TicketListItemResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import UIKit

enum TicketStatus {
    case concertEnd
    case notUsed
    case entryCompleted

    var stampImage: UIImage? {
        switch self {
        case .entryCompleted:
            return .entryCompleteStamp
        case .concertEnd:
            return .concertEndStamp
        case .notUsed:
            return nil
        }
    }
}

struct TicketListItemResponseDTO: Decodable {

    let userId: Int
    let reservationId: Int
    let showName: String
    let placeName: String
    let showDate: String
    let showImgPath: String
    let ticketType: String
    let ticketName: String
    let ticketCount: Int
}

extension TicketListItemResponseDTO {

    func convertToTicketItemEntity() -> TicketItemEntity {
        /// 티켓 타입
        let ticketType = self.ticketType == "SALE" ? TicketType.sale : TicketType.invitation

        return TicketItemEntity(
            ticketType: ticketType,
            ticketName: self.ticketName,
            posterURLPath: showImgPath,
            title: self.showName,
            date: self.showDate.formatToDate().format(.dateDay),
            reservationID: self.reservationId,
            location: self.placeName,
            ticketCount: self.ticketCount
        )
    }
}
