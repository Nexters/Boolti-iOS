//
//  ReportDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/13/24.
//

final class ReportDIContainer {
    
    func createReportViewController() -> ReportViewController {
        let viewModel = createReportViewModel()
        
        let viewController = ReportViewController(
            viewModel: viewModel
        )
        
        return viewController
    }
    
    private func createReportViewModel() -> ReportViewModel {
        return ReportViewModel()
    }

}
