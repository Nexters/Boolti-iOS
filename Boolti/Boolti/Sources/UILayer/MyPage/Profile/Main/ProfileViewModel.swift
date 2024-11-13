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
    private let repository: RepositoryType

    private let userCode: String?

    struct Input {
        let viewWillAppearEvent = PublishSubject<Void>()
    }

    struct Output {
        var links: [LinkEntity] = []
        var performedConcerts: [PerformedConcertEntity] = []
        var didProfileFetch = PublishSubject<(UserProfileResponseDTO)>()
        var isUnknownProfile = PublishSubject<Bool>()
    }

    var input: Input
    var output: Output
    
    // MARK: Initailizer
    // TODO: 내 프로필 확인과 다른 사람 프로필 확인하는 API 구분하기!.. -> 지금은 하나의 ProfileVM에서 처리중
    init(repository: RepositoryType, userCode: String? = nil) {
        self.input = Input()
        self.output = Output()
        self.repository = repository
        self.userCode = userCode

        self.bindInputs()
    }

    private func bindInputs() {
        self.input.viewWillAppearEvent
            .subscribe(with: self) { owner, _ in
                if let _ = owner.userCode {
                    owner.fetchProfileInformation()
                } else {
                    owner.fetchMyProfileInformation()
                }
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension ProfileViewModel {
    
    func fetchMyProfileInformation() {
        guard let authRepository = self.repository as? AuthRepository else { return }
        authRepository.userProfile()
            .subscribe(with: self) { owner, profile in
                owner.output.links = profile.link ?? []
                owner.output.performedConcerts = profile.performedShow ?? []
                owner.output.didProfileFetch.onNext((profile))
            }
            .disposed(by: self.disposeBag)
    }

    func fetchProfileInformation() {
        guard let concertRepository = self.repository as? ConcertRepository else { return }
        concertRepository.userProfile(userCode: self.userCode ?? "")
            .subscribe(with: self, onSuccess: { owner, profile in
                owner.output.links = profile.link ?? []
                owner.output.performedConcerts = profile.performedShow ?? []
                owner.output.didProfileFetch.onNext((profile))
            }, onFailure: { owner, error in
                owner.output.isUnknownProfile.onNext(true)
            })
            .disposed(by: self.disposeBag)
    }
}
