//
//  QRExpandDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

final class QRExpandDIContainer {
    
    func createQRExpandViewController(qrCodeImage: UIImage, ticketName: String) -> QRExpandViewController {
        let viewModel = createQRExpandViewModel(qrCodeImage: qrCodeImage, ticketName: ticketName)

        let viewController = QRExpandViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRExpandViewModel(qrCodeImage: UIImage, ticketName: String) -> QRExpandViewModel {
        return QRExpandViewModel(qrCodeImage: qrCodeImage, ticketName: ticketName)
    }
}
