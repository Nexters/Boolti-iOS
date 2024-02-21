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

    let ticketId: Int
    let showName: String
    let placeName: String
    let showDate: String
    let showImgPath: String
    let ticketType: String
    let ticketName: String
    let entryCode: String
    let usedAt: String?
}

extension TicketListItemResponseDTO {

    func convertToTicketItemEntity() -> TicketItemEntity {
        /// 티켓 타입
        let ticketType = self.ticketType == "SALE" ? TicketType.sale : TicketType.invitation

        /// QR 코드 이미지
        let qrCodeImage = QRMaker.shared.makeQR(identifier: self.entryCode) ?? .qrCode

        var ticketStatus: TicketStatus
        let formattedShowDate: Date = self.showDate.formatToDate()

        if usedAt != nil {
            ticketStatus = .entryCompleted
        } else {
            if Date().getBetweenDay(to: formattedShowDate) < 0 {
                ticketStatus = .concertEnd
            } else {
                ticketStatus = .notUsed
            }
        }

        return TicketItemEntity(
            ticketType: ticketType,
            ticketName: self.ticketName,
            posterURLPath: showImgPath,
            title: self.showName,
            date: self.showDate.formatToDate().format(.dateDay),
            location: self.placeName,
            qrCode: qrCodeImage,
            ticketID: self.ticketId,
            ticketStatus: ticketStatus
        )
    }
}
