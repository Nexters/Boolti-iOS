//
//  QRScannerDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import Foundation

final class QRScannerDIContainer {
    
    typealias EntranceCode = String
    
    func createQRScannerViewController(qrRepository: QRRepositoryType,
                                       qrScannerEntity: QRScannerEntity) -> QRScannerViewController {
        let viewModel = createQRScannerViewModel(qrRepository: qrRepository,
                                                 qrScannerEntity: qrScannerEntity)
        
        let entranceCodeViewControllerFactory: (EntranceCode) -> EntranceCodeViewController = { entranceCode in
            let DIContainer = self.createEntranceCodeDIContainer()

            let viewController = DIContainer.createEntranceCodeViewController(entranceCode: entranceCode)
            return viewController
        }
        
        let viewController = QRScannerViewController(
            viewModel: viewModel,
            entranceCodeViewControllerFactory: entranceCodeViewControllerFactory
        )

        return viewController
    }
    
    private func createEntranceCodeDIContainer() -> EntranceCodeDIContainer {
        return EntranceCodeDIContainer()
    }
    
    private func createQRScannerViewModel(qrRepository: QRRepositoryType,
                                          qrScannerEntity: QRScannerEntity) -> QRScannerViewModel {
        return QRScannerViewModel(qrRepository: qrRepository,
                                  qrScannerEntity: qrScannerEntity)
    }
}
