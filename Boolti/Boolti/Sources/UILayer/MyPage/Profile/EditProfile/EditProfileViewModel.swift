//
//  EditProfileViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/4/24.
//

import UIKit

import RxSwift
import RxRelay

final class EditProfileViewModel {

    // TODO: DOMAIN 객체 제대로 정의하기
    // - Domain 객체
    struct Profile {
        var image: UIImage? = UIImage() // TODO: URL 뽑아오는 로직 변경하기!..
        var imageURL: String? = ""
        var nickName: String? = ""
        var introduction: String? = ""
        var links: [LinkEntity]? = []
    }

    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let authRepository: AuthRepositoryType

    struct Input {
        let didNickNameTyped = BehaviorRelay<String>(value: "")
        let didIntroductionTyped = BehaviorRelay<String>(value: "")
        let didProfileImageSelected = BehaviorRelay<UIImage>(value: UIImage())
        let didLinkChanged = BehaviorRelay<[LinkEntity]>(value: [])

        let didNavigationBarCompleteButtonTapped = PublishSubject<Void>()
        let didPopUpConfirmButtonTapped = PublishSubject<Void>()
    }

    struct Output {
        // Links - RxCocoa Datasource로 변경하기
        let fetchedProfile = BehaviorRelay<Profile?>(value: nil)
        let didProfileSave = PublishSubject<Void>()
    }
    
    var input: Input
    var output: Output
    
    // MARK: Initailizer
    
    init(authRepository: AuthRepositoryType) {
        self.input = Input()
        self.output = Output()
        self.authRepository = authRepository
        self.bindInputs()
    }
    
}

// MARK: - Inputs

extension EditProfileViewModel {
    private func bindInputs() {

        Observable.combineLatest(
            self.input.didNickNameTyped,
            self.input.didIntroductionTyped,
            self.input.didProfileImageSelected,
            self.input.didLinkChanged
        )
        .withLatestFrom(self.output.fetchedProfile) { (latest, fetchedProfile) -> Profile? in
            guard var profile = fetchedProfile else { return nil }
            let (nickName, introduction, uiImage, links) = latest
            profile.nickName = nickName
            profile.introduction = introduction
            profile.image = uiImage
            profile.links = links
            return profile
        }
        .compactMap { $0 }
        .subscribe(with: self) { owner, updatedProfile in
            owner.output.fetchedProfile.accept(updatedProfile)
        }
        .disposed(by: self.disposeBag)

        Observable.merge(self.input.didNavigationBarCompleteButtonTapped, self.input.didPopUpConfirmButtonTapped)
            .subscribe(with: self) { owner, _ in
                guard let profile = owner.output.fetchedProfile.value else { return }
                owner.save(profile)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Ouputs
extension EditProfileViewModel {
    private func bindOutputs() {

    }
}

// MARK: - Network

extension EditProfileViewModel {
    
    // TODO: 추후에 View Life Cycle에 맞게 호출하도록 변경하기
    func fetchProfile() {
        // TODO: 추후에 Domain 객체로 변경
        self.authRepository.userProfile()
            .map({ DTO in
                return Profile(image: nil, imageURL: DTO.imgPath, nickName: DTO.nickname, introduction: DTO.introduction, links: DTO.link)
            })
            .subscribe(with: self) { owner, profile in
                owner.output.fetchedProfile.accept(profile)
            }
            .disposed(by: self.disposeBag)
    }

    func save(_ profile: Profile) {

        self.authRepository.getUploadImageURL()
            .flatMap({ [weak self] response -> Single<String> in
                guard let self = self else { return .just("") }
                return self.authRepository.uploadProfileImage(uploadURL: response.uploadUrl, imageData: profile.image ?? UIImage())
                    .map { _ in response.expectedUrl }
            })
            .flatMap({ [weak self] profileImageUrl -> Single<Void> in
                guard let self = self else { return .just(()) }
                return self.authRepository.editProfile(profileImageUrl: profileImageUrl,
                                                       nickname: profile.nickName ?? "",
                                                       introduction: profile.introduction ?? "",
                                                       links: profile.links ?? [])
            })
            .subscribe(with: self) { owner, _ in
                owner.output.didProfileSave.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
}
