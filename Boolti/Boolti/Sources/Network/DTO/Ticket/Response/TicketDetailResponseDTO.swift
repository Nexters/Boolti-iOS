//
//  TicketDetailResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/6/24.
//

import UIKit

struct TicketDetailResponseDTO: Decodable {

    let userId: Int
    let ticketNotice: String
    let showDate: String
    let hostName: String
    let ticketName: String
    let hostPhoneNumber: String
    let ticketType: String
    let showName: String
    let notice: String
    let reservationId: Int
    let showImgPath: String
    let streetAddress: String
    let detailAddress: String
    let placeName: String
    let showId: Int
    let tickets: [TicketDetailInformationDTO]
    let giftSenderUserId: Int?
}

struct TicketDetailInformationDTO: Decodable {

    let entryCode: String
    let usedAt: String?
    let ticketCreatedAt: String
    let ticketId: Int
    let csTicketId: String
}

extension TicketDetailResponseDTO {

    func convertToTicketDetailInformaton(_ information: TicketDetailInformationDTO) -> TicketDetailInformation {
        var ticketStatus: TicketStatus
        let formattedShowDate: Date = self.showDate.formatToDate()

        if information.usedAt != nil {
            ticketStatus = .entryCompleted
        } else {
            if Date().getBetweenDay(to: formattedShowDate) < 0 {
                ticketStatus = .concertEnd
            } else {
                ticketStatus = .notUsed
            }
        }

        return TicketDetailInformation(
            ticketName: self.ticketName,
            entryCode: information.entryCode,
            ticketStatus: ticketStatus,
            ticketID: information.ticketId,
            csTicketID: information.csTicketId
        )
    }

    func convertToTicketDetailItemEntity() -> TicketDetailItemEntity {
        /// 티켓 타입
        let ticketType = self.ticketType == "SALE" ? TicketType.sale : TicketType.invitation

        let ticketInformations: [TicketDetailInformation] = self.tickets.map { self.convertToTicketDetailInformaton($0) }

        let formattedShowDate: Date = self.showDate.formatToDate()
        var showStatus: ShowStatus = .dayBeforeShow

        if Date().getBetweenDay(to: formattedShowDate) < 0 {
            showStatus = .dayAfterShow
        } else if Date().getBetweenDay(to: formattedShowDate) == 0 {
            showStatus = .onShowDate
        }

        let isGift = self.giftSenderUserId == nil ? false : true

        return TicketDetailItemEntity(
            ticketType: ticketType,
            ticketName: self.ticketName,
            posterURLPath: self.showImgPath,
            showStatus: showStatus,
            isGift: isGift,
            title: self.showName,
            streetAddress: self.streetAddress,
            notice: self.notice,
            ticketNotice: self.ticketNotice,
            concertID: self.showId,
            hostName: self.hostName,
            hostPhoneNumber: self.hostPhoneNumber,
            ticketInformations: ticketInformations
        )
    }
}
