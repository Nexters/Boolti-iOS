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
    struct Profile: Equatable {
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
        let didNickNameTyped = PublishRelay<String>()
        let didIntroductionTyped = PublishRelay<String>()
        let didProfileImageSelected = PublishRelay<UIImage>()
        let didLinkChanged = PublishRelay<[LinkEntity]>()

        let didNavigationBarCompleteButtonTapped = PublishSubject<Void>()
        let didPopUpConfirmButtonTapped = PublishSubject<Void>()
        let didBackButtonTapped = PublishSubject<Void>()
    }

    struct Output {
        // Links - RxCocoa Datasource로 변경하기
        let fetchedProfile = BehaviorRelay<Profile?>(value: nil)
        // Edit이된 Profile
        // TODO: 아래의 로직을 Rx로 바꾸기..
        // Profile이 변경되었는 지 아닌 지를 판단하는 로직 변경하기.. -> 현재는 두 개의 객체를 생성해서 Equatable로 비교
        var profile = Profile()
        var initialProfile = Profile()
        let didProfileSaved = PublishSubject<Void>()
        let isProfileChanged = PublishSubject<Bool>()
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

        // CombineLatest는 모든 요구사항을 다 만족했을 때 넘길 때 활용할 것!
        self.input.didNickNameTyped
            .subscribe(with: self, onNext: { owner, nickName in
                owner.output.profile.nickName = nickName
            })
            .disposed(by: self.disposeBag)

        self.input.didIntroductionTyped
            .subscribe(with: self, onNext: { owner, introduction in
                owner.output.profile.introduction = introduction
            })
            .disposed(by: self.disposeBag)

        self.input.didProfileImageSelected
            .subscribe(with: self, onNext: { owner, image in
                owner.output.profile.image = image
            })
            .disposed(by: self.disposeBag)

        self.input.didLinkChanged
            .subscribe(with: self, onNext: { owner, links in
                owner.output.profile.links = links
            })
            .disposed(by: self.disposeBag)

        self.input.didBackButtonTapped
            .subscribe(with: self) { owner, _ in
                let isChanged = !(owner.output.profile == owner.output.initialProfile)
                owner.output.isProfileChanged.onNext(isChanged)
            }
            .disposed(by: self.disposeBag)

        Observable.merge(self.input.didNavigationBarCompleteButtonTapped, self.input.didPopUpConfirmButtonTapped)
            .subscribe(with: self) { owner, _ in
                owner.save(owner.output.profile)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network

extension EditProfileViewModel {
    
    // TODO: 추후에 View Life Cycle에 맞게 호출하도록 변경하기
    func fetchProfile() {
        // TODO: 추후에 Domain 객체로 변경
        self.authRepository.userProfile()
            .map({ [weak self] DTO in
                let fetchedProfile = Profile(image: nil, imageURL: DTO.imgPath, nickName: DTO.nickname, introduction: DTO.introduction, links: DTO.link)
                self?.output.initialProfile = fetchedProfile
                return fetchedProfile
            })
            .subscribe(with: self) { owner, profile in
                owner.output.profile = profile
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
                owner.output.didProfileSaved.onNext(())
            }
            .disposed(by: self.disposeBag)
    }
}
