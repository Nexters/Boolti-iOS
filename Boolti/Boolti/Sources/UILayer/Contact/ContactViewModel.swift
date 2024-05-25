//
//  ContactViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 5/25/24.
//

import Foundation

enum ContactType {
    case call
    case message
}

final class ContactViewModel {
    
    // MARK: Properties
    
    let contactType: ContactType
    let phoneNumber: String
    
    // MARK: Initailizer
    
    init(contactType: ContactType, phoneNumber: String) {
        self.contactType = contactType
        self.phoneNumber = phoneNumber
    }
    
}
