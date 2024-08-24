//
//  ProfileViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import Foundation

final class ProfileViewModel {
    
    // MARK: Properties
    
    private let authRepository: AuthRepositoryType
    
    // MARK: Initailizer
    
    init(authRepository: AuthRepositoryType) {
        self.authRepository = authRepository
    }
    
}
