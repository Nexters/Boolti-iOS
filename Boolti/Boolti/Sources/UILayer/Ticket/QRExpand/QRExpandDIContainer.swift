//
//  QRExpandDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import UIKit

final class QRExpandDIContainer {
    
    func createQRExpandViewController(qrCodeImage: UIImage) -> QRExpandViewController {
        let viewModel = createQRExpandViewModel(qrCodeImage: qrCodeImage)
        
        let viewController = QRExpandViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRExpandViewModel(qrCodeImage: UIImage) -> QRExpandViewModel {
        return QRExpandViewModel(qrCodeImage: qrCodeImage)
    }
}
