//
//  TicketReservationItemResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/10/24.
//

import Foundation

struct TicketReservationItemResponseDTO: Decodable {

    let reservationId: Int
    let reservationStatus: String
    let reservationDate: String
    let showName: String
    let showImg: String
    let salesTicketName: String
    let ticketCount: Int
    let ticketPrice: Int?
    let recipientName: String?
    let giftId: Int?
    let csReservationId: String
}

extension TicketReservationItemResponseDTO {

    func convertToTicketReservationItemEntity() -> TicketReservationItemEntity {
        let reservationID = self.reservationId
        let reservationStatus = ReservationStatus(rawValue: self.reservationStatus) ?? ReservationStatus.reservationCompleted
        let reservationDate = self.reservationDate.components(separatedBy: ".")[0]
        let concertTitle = self.showName
        let concertImageURLPath = self.showImg
        let ticketName = self.salesTicketName
        let ticketCount = self.ticketCount
        let ticketPrice = self.ticketPrice
        let csReservationID = self.csReservationId
        let isGiftReservation = self.recipientName == nil ? false : true

        return TicketReservationItemEntity(
            reservationID: reservationID,
            reservationStatus: reservationStatus,
            reservationDate: reservationDate,
            concertTitle: concertTitle,
            concertImageURLPath: concertImageURLPath,
            ticketName: ticketName,
            ticketCount: ticketCount,
            ticketPrice: ticketPrice ?? 0,
            isGiftReservation: isGiftReservation,
            recipientName: self.recipientName,
            giftId: self.giftId ?? 0,
            csReservationID: csReservationID
        )
    }
}
