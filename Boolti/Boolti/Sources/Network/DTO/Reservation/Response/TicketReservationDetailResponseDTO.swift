//
//  TicketReservationDetailResponseDTO.swift
//  Boolti
//
//  Created by Miro on 2/12/24.
//

import Foundation

struct TicketReservationDetailResponseDTO: Decodable, ReservationDetailDTOProtocol {
    
    let reservationId: Int
    let showImg: String
    let showName: String
    let salesTicketName: String
    let salesTicketType: String
    let ticketCount: Int
    let salesEndTime: String
    let meansType: String?
    let totalAmountPrice: Int?
    let reservationStatus: String
    let completedTimeStamp: String?
    let csReservationId: String
    let easyPayDetail: EasyPayDetail?
    let cardDetail: CardDetail?
    let transferDetail: TransferDetail?
    let showDate: String

    let reservationName: String
    let reservationPhoneNumber: String
    let depositorName: String?
    let depositorPhoneNumber: String?
}

extension TicketReservationDetailResponseDTO {
    func convertToTicketReservationDetailEntity() -> TicketReservationDetailEntity {

        let ticketType = self.salesTicketType == "SALE" ? TicketType.sale : TicketType.invitation
        let reservationStatus = ReservationStatus(rawValue: self.reservationStatus) ?? ReservationStatus.reservationCompleted
        let totalAmountPrice = self.totalAmountPrice ?? 0
        let paymentMethod = paymentMethod()
        let paymentCardDetail = paymentCardDetail()
        let transferAccountBank = transferAccountBank()

        return TicketReservationDetailEntity(
            reservationID: self.reservationId,
            concertPosterImageURLPath: self.showImg,
            concertTitle: self.showName,
            salesTicketName: self.salesTicketName,
            ticketType: ticketType,
            ticketCount: self.ticketCount,
            depositDeadLine: self.salesEndTime,
            paymentMethod: paymentMethod,
            totalPaymentAmount: totalAmountPrice.formattedCurrency(),
            reservationStatus: reservationStatus,
            ticketingDate: self.completedTimeStamp,
            salesEndTime: self.salesEndTime,
            csReservationID: self.csReservationId,
            easyPayProvider: self.easyPayDetail?.provider ?? "",
            accountTransferBank: transferAccountBank,
            paymentCardDetail: paymentCardDetail,
            showDate: self.showDate.formatToDate(),
            purchaseName: self.reservationName,
            purchaserPhoneNumber: self.reservationPhoneNumber,
            depositorName: self.depositorName ?? "",
            depositorPhoneNumber: self.depositorPhoneNumber ?? ""
        )
    }
}
