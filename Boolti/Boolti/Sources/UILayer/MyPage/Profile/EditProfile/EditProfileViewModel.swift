//
//  EditProfileViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import Foundation

import RxSwift

final class EditProfileViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryType
    
    struct Output {
    }
    
    var output: Output
    
    // MARK: Initailizer
    
    init(authRepository: AuthRepositoryType) {
        self.output = Output()
        self.authRepository = authRepository
    }
    
}

// MARK: - Network

extension EditProfileViewModel {
    
}
