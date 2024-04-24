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
    let cardDetail: CardDetail
    
    struct CardDetail: Decodable {
        
        let installmentPlanMonths: Int
        let issuerCode: String
        
    }
}

extension TicketReservationDetailResponseDTO {
    func convertToTicketReservationDetailEntity() -> TicketReservationDetailEntity {

        var ticketType: TicketType = .sale
        switch self.salesTicketType {
        case "SALE":
            ticketType = .sale
        case "INVITE":
            ticketType = .invitation
        case "FREE":
            ticketType = .free
        default:
            break
        }
        
        let reservationStatus = ReservationStatus(rawValue: self.reservationStatus) ?? ReservationStatus.cancelled
        let totalAmountPrice = self.totalAmountPrice ?? 0
        let paymentType = self.meansType ?? "초청 코드"

        return TicketReservationDetailEntity(
            reservationID: String(self.reservationId),
            concertPosterImageURLPath: self.showImg,
            concertTitle: self.showName,
            salesTicketName: self.salesTicketName,
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
            csReservationID: self.csReservationId,
            installmentPlanMonths: self.cardDetail.installmentPlanMonths
        )
    }
}

