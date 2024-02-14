//
//  TicketDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import UIKit

class TicketDetailDIContainer {

    // 일단 필요할 지는 모르겠으나! authRepository
    private let authRepository: AuthRepositoryType
    private let networkService: NetworkProviderType

    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
        self.networkService = authRepository.networkService
    }

    func createTicketDetailController(ticketID: String) -> TicketDetailViewController {
        let ticketEntryCodeViewControllerFactory = { (ticketID: String, concertID: String) in
            let DIContainer = self.createTicketEntryCodeDIContainer()

            let viewController = DIContainer.createTicketEntryCodeViewController(ticketID: ticketID, concertID: concertID)
            return viewController
        }
        
        let qrExpandViewControllerFactory: (UIImage) -> QRExpandViewController = { qrCodeImage in
            let DIContainer = self.createQRExpandDIContainer()

            let viewController = DIContainer.createQRExpandViewController(qrCodeImage: qrCodeImage)
            return viewController
        }

        let viewController = TicketDetailViewController(
            viewModel: self.createTicketDetailViewModel(ticketID: ticketID),
            ticketEntryCodeViewControllerFactory: ticketEntryCodeViewControllerFactory,
            qrExpandViewControllerFactory: qrExpandViewControllerFactory
        )

        return viewController
    }

    private func createTicketEntryCodeDIContainer() -> TicketEntryCodeDIContainer {
        return TicketEntryCodeDIContainer(networkService: self.networkService)
    }
    
    private func createQRExpandDIContainer() -> QRExpandDIContainer {
        return QRExpandDIContainer()
    }

    private func createTicketDetailViewModel(ticketID: String) -> TicketDetailViewModel {
        return TicketDetailViewModel(ticketID: ticketID, networkService: self.networkService)
    }
}
