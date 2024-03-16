//
//  ConcertListDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit

final class ConcertListDIContainer {

    typealias ConcertId = Int

    private let authRepository: AuthRepository
    private let concertRepository: ConcertRepository
    private let ticketReservationRepository: TicketReservationRepository

    init(authRepository: AuthRepository,
         concertRepository: ConcertRepository,
         ticketReservationRepository: TicketReservationRepository) {
        self.authRepository = authRepository
        self.concertRepository = concertRepository
        self.ticketReservationRepository = ticketReservationRepository
    }
    
    func createConcertListViewController() -> UIViewController {
        let viewModel = createConcertListViewModel()
        
        let concertDetailViewControllerFactory: (ConcertId) -> ConcertDetailViewController = { concertId in
            let DIContainer = self.createConcertDetailDIContainer()

            let viewController = DIContainer.createConcertDetailViewController(concertId: concertId)
            return viewController
        }
        
        let ticketReservationsViewControllerFactory = {
            let DIContainer = self.createTicketReservationsDIContainer()
            let viewController = DIContainer.createTicketReservationsViewController()

            return viewController
        }
        
        let businessInfoViewControllerFactory = {
            let DIContainer = self.createBusinessInfoDIContainer()
            let viewController = DIContainer.createBusinessInfoViewController()

            return viewController
        }

        let viewController = ConcertListViewController(
            viewModel: viewModel,
            concertDetailViewControllerFactory: concertDetailViewControllerFactory,
            ticketReservationsViewControllerFactory: ticketReservationsViewControllerFactory,
            businessInfoViewControllerFactory: businessInfoViewControllerFactory
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func createConcertListViewModel() -> ConcertListViewModel {
        return ConcertListViewModel(concertRepository: self.concertRepository,
                                    ticketReservationRepository: self.ticketReservationRepository)
    }
    
    private func createTicketReservationsDIContainer() -> TicketReservationsDIContainer {
        return TicketReservationsDIContainer(networkService: self.authRepository.networkService)
    }
    
    private func createConcertDetailDIContainer() -> ConcertDetailDIContainer {
        return ConcertDetailDIContainer(authRepository: self.authRepository, concertRepository: self.concertRepository)
    }

    private func createBusinessInfoDIContainer() -> BusinessInfoDIContainer {
        return BusinessInfoDIContainer()
    }
}
