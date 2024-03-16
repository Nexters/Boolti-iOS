//
//  BusinessInfoDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/14/24.
//

import Foundation

final class BusinessInfoDIContainer {
    
    func createBusinessInfoViewController() -> BusinessInfoViewController {
        let viewController = BusinessInfoViewController()
        
        return viewController
    }
}
