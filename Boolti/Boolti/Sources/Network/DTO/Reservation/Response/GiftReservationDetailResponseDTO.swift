//
//  GiftReservationDetailResponseDTO.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import Foundation

struct GiftReservationDetailResponseDTO: Decodable, ReservationDetailDTOProtocol {

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

    let recipientName: String
    let recipientPhoneNumber: String
    let giftId: Int
    let giftMessage: String
    let giftImgPath: String
}

extension GiftReservationDetailResponseDTO {
    func convertToGiftReservationDetailEntity() -> GiftReservationDetailEntity {

        let ticketType = self.salesTicketType == "SALE" ? TicketType.sale : TicketType.invitation
        let reservationStatus = ReservationStatus(rawValue: self.reservationStatus) ?? ReservationStatus.reservationCompleted
        let totalAmountPrice = self.totalAmountPrice ?? 0
        let paymentMethod = paymentMethod()
        let paymentCardDetail = paymentCardDetail()
        let transferAccountBank = transferAccountBank()

        return GiftReservationDetailEntity(
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
            giftID: self.giftId,
            giftMessage: self.giftMessage,
            giftImageURLPath: self.giftImgPath,
            ticketingDate: self.completedTimeStamp,
            recipientName: self.recipientName,
            recipientPhoneNumber: self.recipientPhoneNumber,
            salesEndTime: self.salesEndTime,
            csReservationID: self.csReservationId,
            easyPayProvider: self.easyPayDetail?.provider ?? "",
            accountTransferBank: transferAccountBank,
            paymentCardDetail: paymentCardDetail,
            showDate: self.showDate.formatToDate()
        )
    }
}
