//
//  TicketReservationsDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class TicketReservationsDIContainer {
    
    typealias ReservationID = String
    typealias GiftID = String
    
    
    private let reservationRepository: ReservationRepositoryType
    
    init(networkService: NetworkProviderType) {
        self.reservationRepository = ReservationRepository(networkService: networkService)
    }
    
    func createTicketReservationsViewController() -> TicketReservationsViewController {
        let ticketReservationDetailViewControllerFactory: (ReservationID) -> TicketReservationDetailViewController = { reservationID in
            let DIContainer = self.createTicketReservationDetailDIContainer()
            
            let viewController = DIContainer.createTicketReservationDetailViewController(reservationID: reservationID)
            
            return viewController
        }
        
        let giftReservationDetailViewControllerFactory: (GiftID) -> GiftReservationDetailViewController = { giftID in
            let DIContainer = self.createGiftReservationDetailDIContainer()
            
            let viewController = DIContainer.createTicketReservationDetailViewController(giftID: giftID)
            
            return viewController
        }
        
        
        
        return TicketReservationsViewController(
            ticketReservationDetailViewControllerFactory: ticketReservationDetailViewControllerFactory,
            giftReservationDetailViewControllerFactory: giftReservationDetailViewControllerFactory,
            viewModel: self.createTicketResercationsViewModel())
    }
    
    private func createTicketResercationsViewModel() -> TicketReservationsViewModel {
        return TicketReservationsViewModel(
            reservationRepository: self.reservationRepository)
    }
    
    private func createTicketReservationDetailDIContainer() -> TicketReservationDetailDIContainer {
        return TicketReservationDetailDIContainer(reservationRepository: self.reservationRepository)
    }
    
    private func createGiftReservationDetailDIContainer() -> GiftReservationDetailDIContainer {
        return GiftReservationDetailDIContainer(giftReservationRepository: self.reservationRepository)
    }
}
