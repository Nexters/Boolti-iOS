//
//  ProfileViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import Foundation

import RxSwift

final class ProfileViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryType
    
    struct Output {
        var links: [LinkEntity] = []
        var didProfileFetch = PublishSubject<String?>()
    }
    
    var output: Output
    
    // MARK: Initailizer
    
    init(authRepository: AuthRepositoryType) {
        self.output = Output()
        self.authRepository = authRepository
    }
    
}

// MARK: - Network

extension ProfileViewModel {
    
    func fetchLinkList() {
        self.authRepository.userProfile()
            .subscribe(with: self) { owner, profile in
                owner.output.links = profile.link ?? []
                owner.output.didProfileFetch.onNext(profile.introduction)
            }
            .disposed(by: self.disposeBag)
    }
}
