//
//  TicketListItemResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import UIKit

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
        // 여기서 QR 코드 이미지로 변환할 예정
        let qrCodeImage: UIImage = .qrCode

        return TicketItemEntity(
            ticketType: ticketType,
            ticketName: self.ticketName,
            posterURLPath: showImgPath,
            title: self.showName,
            date: self.showDate.formatToDate().format(.dateDay),
            location: self.placeName,
            qrCode: qrCodeImage,
            ticketID: self.ticketId,
            usedTime: self.usedAt
        )
    }
}
