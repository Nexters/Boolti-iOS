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
    let easyPayDetail: EasyPayDetail?
    let cardDetail: CardDetail?
    let transferDetail: TransferDetail?
    let showDate: String
}

struct EasyPayDetail: Decodable {
    let provider: String
}

struct CardDetail: Decodable {
    let installmentPlanMonths: Int
    let issuerCode: String
}

struct TransferDetail: Decodable {
    let bankCode: String
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
            purchaseName: self.reservationName,
            purchaserPhoneNumber: self.reservationPhoneNumber,
            depositorName: self.depositorName ?? "",
            depositorPhoneNumber: self.depositorPhoneNumber ?? "",
            salesEndTime: self.salesEndTime,
            csReservationID: self.csReservationId,
            easyPayProvider: self.easyPayDetail?.provider ?? "",
            accountTransferBank: transferAccountBank,
            paymentCardDetail: paymentCardDetail,
            showDate: self.showDate.formatToDate()
        )
    }

    private func paymentMethod() -> PaymentMethod? {
        guard let meansType = self.meansType else { return nil }
        return PaymentMethod(rawValue: meansType)
    }

    private func paymentCardDetail() -> PaymentCardDetail? {
        guard let cardDetail = self.cardDetail else { return nil }
        guard cardDetail.issuerCode != "" else { return nil }

        return PaymentCardDetail(
            installmentPlanMonths: cardDetail.installmentPlanMonths == 0 ? "일시불" : "\(cardDetail.installmentPlanMonths)개월",
            issuer: PaymentMethod.issuerByCode[cardDetail.issuerCode] ?? ""
        )
    }

    private func transferAccountBank() -> String? {
        guard let transferDetail = self.transferDetail else { return nil }

        return PaymentMethod.issuerByCode[transferDetail.bankCode]
    }
}
