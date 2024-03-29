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
    let ticketNotice: String
    let entryCode: String
    let usedAt: String?
    let hostName: String
    let hostPhoneNumber: String
    let csReservationId: String
    let csTicketId: String
}

extension TicketDetailResponseDTO {

    func convertToTicketDetailItemEntity() -> TicketDetailItemEntity {
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

        return TicketDetailItemEntity(
            ticketType: ticketType,
            ticketName: self.ticketName,
            posterURLPath: self.showImgPath,
            title: self.showName,
            date: self.showDate,
            location: self.placeName,
            streetAddress: self.streetAddress,
            qrCode: qrCodeImage,
            notice: self.ticketNotice,
            ticketID: self.ticketId,
            concertID: self.showId,
            hostName: self.hostName,
            hostPhoneNumber: self.hostPhoneNumber,
            ticketStatus: ticketStatus,
            csReservationID: self.csReservationId,
            csTicketID: self.csTicketId,
            usedAt: self.usedAt
        )
    }
}
