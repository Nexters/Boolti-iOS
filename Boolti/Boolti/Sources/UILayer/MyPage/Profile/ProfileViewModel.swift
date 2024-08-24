//
//  ProfileViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import Foundation

import RxSwift
import RxRelay

final class ProfileViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryType
    
    struct Output {
        let links = PublishRelay<[linkEntity]>()
    }
    
    let output: Output
    
    // MARK: Initailizer
    
    init(authRepository: AuthRepositoryType) {
        self.output = Output()
        self.authRepository = authRepository
    }
    
}

// MARK: - Network

extension ProfileViewModel {
    
    func fetchLinkList() {
//        self.authRepository.userInfo()
        self.output.links.accept([linkEntity(name: "rads", urlString: "daf"),
                                  linkEntity(name: "rads", urlString: "daf"),
                                  linkEntity(name: "rads", urlString: "daf"),
                                  linkEntity(name: "rads", urlString: "daf")])
    }
}
