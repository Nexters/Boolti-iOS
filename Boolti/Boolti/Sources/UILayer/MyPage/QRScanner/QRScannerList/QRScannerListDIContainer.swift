//
//  QrScanDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class QRScannerListDIContainer {
    
    func createQRScannerListViewController() -> QRScannerListViewController {
        let viewModel = createQRScannerListViewModel()
        
        let qrScannerViewControllerFactory: (QRScannerEntity) -> QRScannerViewController = { qrScannerEntity in
            let DIContainer = self.createQRScannerDIContainer()

            let viewController = DIContainer.createQRScannerViewController(qrScannerEntity: qrScannerEntity)
            return viewController
        }
        
        
        let viewController = QRScannerListViewController(
            viewModel: viewModel,
            qrScannerViewControllerFactory: qrScannerViewControllerFactory
        )

        return viewController
    }
    
    private func createQRScannerDIContainer() -> QRScannerDIContainer {
        return QRScannerDIContainer()
    }
    
    private func createQRScannerListViewModel() -> QRScannerListViewModel {
        return QRScannerListViewModel()
    }
}
