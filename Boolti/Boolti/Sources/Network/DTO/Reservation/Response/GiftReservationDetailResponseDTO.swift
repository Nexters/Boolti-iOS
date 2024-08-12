//
//  GiftReservationDetailResponseDTO.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import Foundation

struct GiftReservationDetailResponseDTO: Decodable, ReservationDetailDTOProtocol {

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
    let giftUuid: String
    let giftMessage: String
    let giftImgPath: String
    let giftInvitePath: String
    let senderName: String
    let senderPhoneNumber: String
}

extension GiftReservationDetailResponseDTO {
    func convertToGiftReservationDetailEntity() -> GiftReservationDetailEntity {

        let reservationStatus = ReservationStatus(rawValue: self.reservationStatus) ?? ReservationStatus.reservationCompleted
        let totalAmountPrice = self.totalAmountPrice ?? 0
        let paymentMethod = paymentMethod()
        let paymentCardDetail = paymentCardDetail()
        let transferAccountBank = transferAccountBank()

        return GiftReservationDetailEntity(
            concertPosterImageURLPath: self.showImg,
            concertTitle: self.showName,
            salesTicketName: self.salesTicketName,
            ticketType: .sale,
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
            giftID: self.giftId,
            giftUUID: self.giftUuid,
            giftMessage: self.giftMessage,
            giftImageURLPath: self.giftInvitePath,
            recipientName: self.recipientName,
            recipientPhoneNumber: self.recipientPhoneNumber,
            senderName: self.senderName,
            senderPhoneNumber: self.senderPhoneNumber
        )
    }
}
