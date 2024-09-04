//
//  ProfileViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ProfileViewController: BooltiViewController {
    
    // MARK: Properties
    
    enum Section: Int, CaseIterable {
        case profile
        case snsLink
    }
    
    private var profileHeaderHeight: CGFloat = 400
    private let disposeBag = DisposeBag()
    private let viewModel: ProfileViewModel
    
    private let editProfileViewControllerFactory: () -> EditProfileViewController
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "프로필"))
    
    private let dataCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.bounces = false
        collectionView.contentInset = .init(top: 0, left: 0, bottom: 32, right: 0)
        return collectionView
    }()
    
    // MARK: Initailizer
    
    init(viewModel: ProfileViewModel,
         editProfileViewControllerFactory: @escaping () -> EditProfileViewController) {
        self.viewModel = viewModel
        self.editProfileViewControllerFactory = editProfileViewControllerFactory
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.viewModel.fetchLinkList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureCollectionView()
        self.bindUIComponents()
        self.bindViewModel()
    }
    
}

// MARK: - Methods

extension ProfileViewController {
    
    private func bindViewModel() {
        self.viewModel.output.didProfileFetch
            .subscribe(with: self) { owner, _ in
                owner.dataCollectionView.reloadData()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.dataCollectionView.rx.itemSelected
            .map { $0.row }
            .subscribe(with: self) { owner, index in
                guard let url = URL(string: owner.viewModel.output.links[index].link) else { return }
                owner.openSafari(with: url)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.dataCollectionView.delegate = self
        self.dataCollectionView.dataSource = self
        
        self.dataCollectionView.register(ProfileMainView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: ProfileMainView.className)
        self.dataCollectionView.register(ProfileLinkHeaderView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: ProfileLinkHeaderView.className)
        self.dataCollectionView.register(ProfileLinkCollectionViewCell.self, forCellWithReuseIdentifier: ProfileLinkCollectionViewCell.className)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .profile:
            return 0
        case .snsLink:
            return self.viewModel.output.links.count
        }
    }
    
    /// 헤더를 결정하는 메서드
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let section = Section(rawValue: indexPath.section) else { return .init() }
        
        switch section {
        case .profile:
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileMainView.className,
                    for: indexPath
                  ) as? ProfileMainView else { return UICollectionReusableView() }
            
            header.setData(introduction: self.viewModel.output.introduction) { height in
                self.profileHeaderHeight = height
                self.dataCollectionView.collectionViewLayout.invalidateLayout()
            }

            header.didEditButtonTap()
                .emit(with: self) { owner, _ in
                    owner.navigationController?.pushViewController(owner.editProfileViewControllerFactory(), animated: true)
                }
                .disposed(by: self.disposeBag)
            
            return header
        case .snsLink:
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileLinkHeaderView.className,
                    for: indexPath
                  ) as? ProfileLinkHeaderView else { return UICollectionReusableView() }
            
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return .init() }
        
        switch section {
        case .profile:
            return .init()
        case .snsLink:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileLinkCollectionViewCell.className,
                                                                for: indexPath) as? ProfileLinkCollectionViewCell else { return UICollectionViewCell() }
            cell.setData(linkName: self.viewModel.output.links[indexPath.row].title)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .profile:
            guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: elementKind,
                    withReuseIdentifier: ProfileMainView.className,
                    for: indexPath
                  ) as? ProfileMainView else { return }
            
            header.disposeBag = DisposeBag()
        case .snsLink:
            return
        }
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { return .init() }
        
        switch section {
        case .profile:
            return .zero
        case .snsLink:
            return CGSize(width: self.dataCollectionView.frame.width - 40, height: 56)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return .init() }
        
        switch section {
        case .profile:
            return 0
        case .snsLink:
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let section = Section(rawValue: section) else { return .init() }
        
        switch section {
        case .profile:
            return CGSize(width: self.view.frame.width, height: self.profileHeaderHeight)
        case .snsLink:
            guard !self.viewModel.output.links.isEmpty else { return .zero }
            return CGSize(width: self.view.frame.width, height: 74)
        }
    }
}

// MARK: - UI

extension ProfileViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.dataCollectionView,
                               self.navigationBar])
        self.navigationBar.setBackgroundColor(with: .grey90)
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.dataCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
