//
//  TicketDetailDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/4/24.
//

import Foundation

class TicketDetailDIContainer {
    
    // 일단 필요할 지는 모르겠으나! authAPIService
    private let authAPIService: AuthAPIServiceType
    private let networkService: NetworkProviderType

    init(authAPIService: AuthAPIServiceType) {
        self.authAPIService = authAPIService
        self.networkService = authAPIService.networkService
    }

    func createTicketDetailController(ticketItem: TicketItem) -> TicketDetailViewController {
        let viewController = TicketDetailViewController(ticketItem: ticketItem, viewModel: self.createTicketDetailViewModel())

        return viewController
    }

    private func createTicketDetailViewModel() -> TicketDetailViewModel {
        return TicketDetailViewModel(networkService: self.networkService)
    }
}
