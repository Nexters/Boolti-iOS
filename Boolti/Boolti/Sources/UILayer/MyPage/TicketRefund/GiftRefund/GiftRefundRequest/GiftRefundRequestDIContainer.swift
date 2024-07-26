//
//  GiftRefundRequestDIContainer.swift
//  Boolti
//
//  Created by Miro on 7/24/24.
//

import Foundation

final class GiftRefundRequestDIContainer {

    typealias GiftUuid = String

    private let reservationRepository: ReservationRepositoryType

    init(reservationRepository: ReservationRepositoryType) {
        self.reservationRepository = reservationRepository
    }

    func createGiftRefundRequestViewController(giftID: String) -> GiftRefundRequestViewController {

        let giftRefundConfirmViewControllerFactory: (GiftUuid, RefundAccountInformation) -> TicketRefundConfirmViewController = {
            (giftUuid, refundAccountInformation) in

            let DIContainer = self.createGiftRefundConfirmDIContainer()
            let viewController = DIContainer.createTicketRefundConfirmViewController(reservationID: giftUuid, reasonText: nil, isGift: true, refundAccoundInformation: refundAccountInformation)

            return viewController
        }

        return GiftRefundRequestViewController(
            giftRefundConfirmViewControllerFactory: giftRefundConfirmViewControllerFactory,
            viewModel: self.giftRefundRequestViewModel(giftID: giftID)
        )
    }


    private func giftRefundRequestViewModel(giftID: String) -> GiftRefundRequestViewModel {
        return GiftRefundRequestViewModel(giftID: giftID, reservationRepository: reservationRepository)
    }

    private func createGiftRefundConfirmDIContainer() -> TicketRefundConfirmDIContainer {
        return TicketRefundConfirmDIContainer(reservationRepository: self.reservationRepository)
    }
}
