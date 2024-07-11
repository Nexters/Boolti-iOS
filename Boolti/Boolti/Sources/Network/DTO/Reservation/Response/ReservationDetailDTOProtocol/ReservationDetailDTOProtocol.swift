//
//  ReservationDetailDTOProtocol.swift
//  Boolti
//
//  Created by Miro on 7/11/24.
//

import Foundation

protocol ReservationDetailDTOProtocol {
    var reservationId: Int { get }
    var showImg: String { get }
    var showName: String { get }
    var salesTicketName: String { get }
    var salesTicketType: String { get }
    var ticketCount: Int { get }
    var salesEndTime: String { get }
    var meansType: String? { get }
    var totalAmountPrice: Int? { get }
    var reservationStatus: String { get }
    var completedTimeStamp: String? { get }
    var csReservationId: String { get }
    var easyPayDetail: EasyPayDetail? { get }
    var cardDetail: CardDetail? { get }
    var transferDetail: TransferDetail? { get }
    var showDate: String { get }
    func paymentMethod() -> PaymentMethod?
    func paymentCardDetail() -> PaymentCardDetail?
    func transferAccountBank() -> String?
}

extension ReservationDetailDTOProtocol {

    func paymentMethod() -> PaymentMethod? {
        guard let meansType = self.meansType else { return nil }
        return PaymentMethod(rawValue: meansType)
    }

    func paymentCardDetail() -> PaymentCardDetail? {
        guard let cardDetail = self.cardDetail else { return nil }
        guard cardDetail.issuerCode != "" else { return nil }

        return PaymentCardDetail(
            installmentPlanMonths: cardDetail.installmentPlanMonths == 0 ? "일시불" : "\(cardDetail.installmentPlanMonths)개월",
            issuer: PaymentMethod.issuerByCode[cardDetail.issuerCode] ?? ""
        )
    }

    func transferAccountBank() -> String? {
        guard let transferDetail = self.transferDetail else { return nil }

        return PaymentMethod.issuerByCode[transferDetail.bankCode]
    }
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
