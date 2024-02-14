//
//  EntranceCodeDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/14/24.
//

import Foundation

final class EntranceCodeDIContainer {
    
    func createEntranceCodeViewController(entranceCode: String) -> EntranceCodeViewController {
        let viewModel = createEntranceCodeViewModel(entranceCode: entranceCode)
        
        let viewController = EntranceCodeViewController(
            viewModel: viewModel
        )

        return viewController
    }
    
    private func createEntranceCodeViewModel(entranceCode: String) -> EntranceCodeViewModel {
        return EntranceCodeViewModel(entranceCode: entranceCode)
    }
}
