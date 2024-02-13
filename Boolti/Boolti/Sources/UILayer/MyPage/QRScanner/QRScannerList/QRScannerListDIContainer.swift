//
//  QrScanDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class QRScannerListDIContainer {
    
    typealias ConcertName = String
    
    func createQRScannerListViewController() -> QRScannerListViewController {
        let viewModel = createQRScannerListViewModel()
        
        let qrScannerViewControllerFactory: (ConcertName) -> QRScannerViewController = { concertName in
            let DIContainer = self.createQRScannerDIContainer()

            let viewController = DIContainer.createQRScannerViewController(concertName: concertName)
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
