//
//  ContactDIContainer.swift
//  Boolti
//
//  Created by Juhyeon Byun on 5/25/24.
//

import Foundation

final class ContactDIContainer {
    
    func createContactViewController(contactType: ContactType, phoneNumber: String) -> ContactViewController {
        let viewModel = ContactViewModel(contactType: contactType, phoneNumber: phoneNumber)
        let viewController = ContactViewController(viewModel: viewModel)
        
        return viewController
    }
}
