//
//  QRScannerDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import Foundation

final class QRScannerDIContainer {
    
    func createQRScannerViewController(qrRepository: QRRepositoryType,
                                       qrScannerEntity: QRScannerEntity) -> QRScannerViewController {
        let viewModel = createQRScannerViewModel(qrRepository: qrRepository,
                                                 qrScannerEntity: qrScannerEntity)
        
        let viewController = QRScannerViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRScannerViewModel(qrRepository: QRRepositoryType,
                                          qrScannerEntity: QRScannerEntity) -> QRScannerViewModel {
        return QRScannerViewModel(qrRepository: qrRepository,
                                  qrScannerEntity: qrScannerEntity)
    }
}
