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
    
    private let disposeBag = DisposeBag()
    private let viewModel: ProfileViewModel
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "프로필"))
    
    private let mainCollectionView: UICollectionView = {
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
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
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
    }
    
}

// MARK: - Methods

extension ProfileViewController {
    
    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.mainCollectionView.rx.didScroll
            .subscribe(with: self) { owner, _ in
                let offset = owner.mainCollectionView.contentOffset.y
                if offset <= 280 {
                    self.navigationBar.setBackgroundColor(with: .grey90)
                } else {
                    self.navigationBar.setBackgroundColor(with: .grey95)
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        
        self.mainCollectionView.register(ProfileMainView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: ProfileMainView.className
        )
        self.mainCollectionView.register(ProfileLinkHeaderView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: ProfileLinkHeaderView.className
        )
        self.mainCollectionView.register(ProfileLinkCollectionViewCell.self, forCellWithReuseIdentifier: ProfileLinkCollectionViewCell.className)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 10
        default:
            return 0
        }
    }
    
    /// 헤더를 결정하는 메서드
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileMainView.className,
                    for: indexPath
                  ) as? ProfileMainView else {return UICollectionReusableView()}
            
            header.didEditButtonTap()
                .emit(with: self) { owner, _ in
                    print("edit button tap!")
                }
                .disposed(by: self.disposeBag)
            header.setData()
            return header
        default:
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ProfileLinkHeaderView.className,
                    for: indexPath
                  ) as? ProfileLinkHeaderView else {return UICollectionReusableView()}
            
            return header
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileLinkCollectionViewCell.className, for: indexPath) as? ProfileLinkCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(linkName: "안녕하세요")
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.mainCollectionView.frame.width - 40, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: self.mainCollectionView.frame.width, height: 280)
        case 1:
            return CGSize(width: self.mainCollectionView.frame.width, height: 74)
        default:
            return .zero
        }
    }
}

// MARK: - UI

extension ProfileViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.mainCollectionView])
        self.navigationBar.setBackgroundColor(with: .grey90)
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
