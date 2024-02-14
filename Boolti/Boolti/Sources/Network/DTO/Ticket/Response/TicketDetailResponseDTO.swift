//
//  TicketDetailResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import UIKit

struct TicketDetailResponseDTO: Decodable {

    let ticketId: Int
    let showId: Int
    let showName: String
    let placeName: String
    let showImgPath: String
    let showDate: String
    let streetAddress: String
    let detailAddress: String
    let ticketType: String
    let ticketName: String
    let notice: String
    let entryCode: String
    let usedAt: String?
    let hostName: String
    let hostPhoneNumber: String
}



extension TicketDetailResponseDTO {

    func convertToTicketDetailItemEntity() -> TicketDetailItemEntity {
        /// 티켓 타입
        let ticketType = self.ticketType == "SALE" ? TicketType.sale : TicketType.invitation

        /// QR 코드 이미지
        // 여기서 QR 코드 이미지로 변환할 예정
        let qrCodeImage: UIImage = .qrCode

        return TicketDetailItemEntity(
            ticketType: ticketType,
            ticketName: self.ticketName,
            posterURLPath: self.showImgPath,
            title: self.showName,
            date: self.showDate.formatToDate().format(.dateDay),
            location: self.placeName,
            qrCode: qrCodeImage,
            notice: self.notice,
            ticketID: self.ticketId,
            concertID: self.showId,
            hostName: self.hostName,
            hostPhoneNumber: self.hostPhoneNumber,
            usedTime: self.usedAt
        )
    }
}
