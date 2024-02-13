//
//  QRScannerDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

import Foundation

final class QRScannerDIContainer {
    
    func createQRScannerViewController(concertName: String) -> QRScannerViewController {
        let viewModel = createQRScannerViewModel(concertName: concertName)
        
        let viewController = QRScannerViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createQRScannerViewModel(concertName: String) -> QRScannerViewModel {
        return QRScannerViewModel(concertName: concertName)
    }
}
