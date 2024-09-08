//
//  EditLinkViewModel.swift
//  Boolti
//
//  Created by Juhyeon Byun on 9/6/24.
//
//
//import Foundation
//
//import RxSwift
//
//final class EditLinkViewModel {
//    
//    // MARK: Properties
//    
//    private let disposeBag = DisposeBag()
//    private let authRepository: AuthRepositoryType
//    
//    struct Output {
//        let didLinkSave = PublishSubject<Void>()
//        let didLinkRemove = PublishSubject<Void>()
//    }
//    
//    var output: Output
//    
//    var profile: ProfileEntity
//    
//    // MARK: Initailizer
//    
//    init(authRepository: AuthRepositoryType,
//         profileEntity: ProfileEntity) {
//        self.output = Output()
//        self.authRepository = authRepository
//        self.profile = profileEntity
//    }
//    
//}
//
//// MARK: - Network
//
//extension EditLinkViewModel {
//    
//    func addLink(title: String, link: String) {
//        self.profile.links.insert(LinkEntity(title: title, link: link), at: 0)
//        self.saveProfile()
//    }
//    
//    func editLink(title: String, link: String, indexPath: IndexPath) {
//        self.profile.links[indexPath.row] = LinkEntity(title: title, link: link)
//        self.saveProfile()
//    }
//    
//    func removeLink(indexPath: IndexPath) {
//        self.profile.links.remove(at: indexPath.row)
//        self.saveProfile(isRemoveAction: true)
//    }
//    
//    func saveProfile(isRemoveAction: Bool = false) {
//        self.authRepository.fetchProfile(profileImageUrl: self.profile.profileImageURL,
//                                         nickname: self.profile.nickname,
//                                         introduction: self.profile.introduction,
//                                         links: self.profile.links)
//        .subscribe(with: self) { owner, _ in
//            if isRemoveAction {
//                owner.output.didLinkRemove.onNext(())
//            } else {
//                owner.output.didLinkSave.onNext(())
//            }
//        }
//        .disposed(by: self.disposeBag)
//    }
//    
//}
