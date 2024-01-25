//
//  TermsAgreementDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/25/24.
//

import Foundation

class TermsAgreementDIContainer {

    func createTermsAgreementViewController() -> TermsAgreementViewController {
        let viewController = TermsAgreementViewController(viewModel: self.createTermsAgreementViewModel())

        return viewController
    }

    private func createTermsAgreementViewModel() -> TermsAgreementViewModel {
        let viewModel = TermsAgreementViewModel()

        return viewModel
    }
}
