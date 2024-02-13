//
//  QRScannerDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import Foundation

final class QRScannerDIContainer {
    
    func createQRScannerViewController(qrScannerEntity: QRScannerEntity) -> QRScannerViewController {
        let viewModel = createQRScannerViewModel(qrScannerEntity: qrScannerEntity)
        
        let viewController = QRScannerViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRScannerViewModel(qrScannerEntity: QRScannerEntity) -> QRScannerViewModel {
        return QRScannerViewModel(qrScannerEntity: qrScannerEntity)
    }
}
