//
//  TicketReservationDetailResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

struct TicketReservationDetailResponseDTO: Decodable {
    let reservationId: Int
    let showImg: String
    let showName: String
    let salesTicketName: String
    let salesTicketType: String
    let ticketCount: Int
    let bankName: String
    let accountNumber: String
    let accountHolder: String
    let salesEndTime: String
    let meansType: String?
    let totalAmountPrice: Int?
    let reservationStatus: String
    let completedTimeStamp: String?
    let reservationName: String
    let reservationPhoneNumber: String
    let depositorName: String?
    let depositorPhoneNumber: String?
    let csReservationId: String
}

extension TicketReservationDetailResponseDTO {
    func convertToTicketReservationDetailEntity() -> TicketReservationDetailEntity {

        let ticketType = self.salesTicketType == "SALE" ? TicketType.sale : TicketType.invitation
        let reservationStatus = ReservationStatus(rawValue: self.reservationStatus) ?? ReservationStatus.cancelled
        let totalAmountPrice = self.totalAmountPrice ?? 0
        let paymentType = self.meansType ?? "초청코드"

        return TicketReservationDetailEntity(
            reservationID: String(self.reservationId),
            concertPosterImageURLPath: self.showImg,
            concertTitle: self.showName,
            ticketType: ticketType,
            ticketCount: String(self.ticketCount),
            bankName: bankName,
            accountNumber: self.accountNumber,
            accountHolderName: self.accountHolder,
            depositDeadLine: self.salesEndTime,
            paymentMethod: paymentType,
            totalPaymentAmount: totalAmountPrice.formattedCurrency(),
            reservationStatus: reservationStatus,
            ticketingDate: self.completedTimeStamp,
            purchaseName: self.reservationName,
            purchaserPhoneNumber: self.reservationPhoneNumber,
            depositorName: self.depositorName ?? "",
            depositorPhoneNumber: self.depositorPhoneNumber ?? "",
            salesEndTime: self.salesEndTime,
            csReservationID: self.csReservationId
        )
    }
}

