//
//  QRExpandDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

final class QRExpandDIContainer {
    
    func createQRExpandViewController(indexPath: IndexPath, tickets: [TicketDetailInformation]) -> QRExpandViewController {
        let viewModel = createQRExpandViewModel(indexPath: indexPath, tickets: tickets)

        let viewController = QRExpandViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRExpandViewModel(indexPath: IndexPath, tickets: [TicketDetailInformation]) -> QRExpandViewModel {
        return QRExpandViewModel(indexPath: indexPath, tickets: tickets)
    }
}
