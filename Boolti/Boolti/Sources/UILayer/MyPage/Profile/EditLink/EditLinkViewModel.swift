//
//  EditLinkViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/6/24.
//

import Foundation

import RxSwift

final class EditLinkViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryType
    
    struct Output {
        let didLinkSave = PublishSubject<Void>()
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
