//
//  TicketReservationsRepository.swift
//  Boolti
//
//  Created by Miro on 2/10/24.
//

import Foundation

protocol TicketReservationsRepositoryType {
    var networkService: NetworkProviderType { get }
}

class TicketReservationRepository: TicketReservationsRepositoryType {

    let networkService: NetworkProviderType

    init(networkService: NetworkProviderType) {
        self.networkService = networkService
    }
}
