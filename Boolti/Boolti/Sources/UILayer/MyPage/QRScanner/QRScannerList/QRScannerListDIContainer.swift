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
        
        let viewController = QRScannerListViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRScannerListViewModel() -> QRScannerListViewModel {
        return QRScannerListViewModel()
    }
}
