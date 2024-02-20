//
//  QrScanDIContainer.swift
//  Boolti
//
//  Created by Miro on 2/8/24.
//

import Foundation

final class QRScannerListDIContainer {
    
    private let qrRepository: QRRepositoryType

    init(qrRepository: QRRepositoryType) {
        self.qrRepository = qrRepository
    }
    
    func createQRScannerListViewController() -> QRScannerListViewController {
        let viewModel = createQRScannerListViewModel()
        
        let qrScannerViewControllerFactory: (QRScannerEntity) -> QRScannerViewController = { qrScannerEntity in
            let DIContainer = self.createQRScannerDIContainer()

            let viewController = DIContainer.createQRScannerViewController(qrRepository: self.qrRepository,
                                                                           qrScannerEntity: qrScannerEntity)
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
        return QRScannerListViewModel(qrRepository: self.qrRepository)
    }
}
