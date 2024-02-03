//
//  MyPageDIContainer.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import Foundation
import UIKit

final class MyPageDIContainer {

    private let authAPIService: AuthAPIService

    init(authAPIService: AuthAPIService) {
        self.authAPIService = authAPIService
    }
    
    func createMyPageViewController() -> UIViewController {
        let viewModel = createMyPageViewModel()

        let viewController = MyPageViewController(viewModel: viewModel)

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    private func createMyPageViewModel() -> MypageViewModel {
        return MypageViewModel()
    }

}
