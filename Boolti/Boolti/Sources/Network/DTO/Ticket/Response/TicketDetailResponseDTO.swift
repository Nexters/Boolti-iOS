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
}

extension TicketDetailResponseDTO {

    func convertToTicketDetailItemEntity() -> TicketDetailItemEntity {
        /// 티켓 타입
        let ticketType = self.ticketType == "SALE" ? TicketType.sale : TicketType.invitation

        /// QR 코드 이미지
        let qrCodeImage = QRMaker.shared.makeQR(identifier: self.entryCode) ?? .qrCode

        // TicketListItem과 동일한 로직을 반복함 따라서 굳이 두번 하지 말고, VC에서 넘겨주는 것도 하나의 방법일듯!..
        var ticketStatus: TicketStatus = .notUsed
        let formattedShowDate: Date = self.showDate.formatToDate()

        if let usedAt {
            // 밤에하는 공연의 경우 다른 방법으로 compare해줘야함!
            if Date().getBetweenDay(to: formattedShowDate) < 0 {
                ticketStatus = .concertEnd
            } else {
                ticketStatus = .entryCompleted
            }
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
            date: self.showDate.formatToDate().format(.dateDay),
            location: self.placeName,
            qrCode: qrCodeImage,
            notice: self.ticketNotice,
            ticketID: self.ticketId,
            concertID: self.showId,
            hostName: self.hostName,
            hostPhoneNumber: self.hostPhoneNumber,
            ticketStatus: ticketStatus
        )
    }
}
