//
//  EditProfileViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import UIKit

import RxSwift

final class EditProfileViewModel {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryType
    
    struct Output {
        var didProfileFetch = PublishSubject<Void>()
        var introduction: String?
        var links: [LinkEntity] = []
        let didProfileSave = PublishSubject<Void>()
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
    
    func fetchProfile() {
        self.authRepository.userProfile()
            .subscribe(with: self) { owner, profile in
                owner.output.introduction = profile.introduction
                owner.output.links = profile.link ?? []
                owner.output.didProfileFetch.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
    
    func saveProfile(nickname: String, introduction: String, profileImage: UIImage?, links: [LinkEntity]) {
        guard let profileImage = profileImage else { return }
        
        self.authRepository.getUploadImageURL()
            .flatMap({ [weak self] response -> Single<String> in
                guard let self = self else { return .just("") }
                return self.authRepository.uploadProfileImage(uploadURL: response.uploadUrl, imageData: profileImage)
                    .map { _ in response.expectedUrl }
            })
            .flatMap({ [weak self] profileImageUrl -> Single<Void> in
                guard let self = self else { return .just(()) }
                return self.authRepository.fetchProfile(profileImageUrl: profileImageUrl,
                                                        nickname: nickname,
                                                        introduction: introduction,
                                                        links: links)
            })
            .subscribe(with: self) { owner, _ in
                owner.output.didProfileSave.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
    
}
