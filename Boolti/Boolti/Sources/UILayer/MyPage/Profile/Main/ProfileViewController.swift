//
//  ProfileViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 8/24/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxAppState

final class ProfileViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel: ProfileViewModel
    
    private let editProfileViewControllerFactory: (() -> EditProfileViewController)?

    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "프로필"))
    
    private lazy var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.addSubview(self.stackView)
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 32, right: 0)
        
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubviews([self.profileMainView,
                                       self.dataCollectionView])
        
        return stackView
    }()
    
    private let profileMainView = ProfileMainView()

    private let unknownProfilePopUpView = BooltiPopupView()

    let dataCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    // MARK: Initailizer
    
    init(viewModel: ProfileViewModel,
         editProfileViewControllerFactory: (() -> EditProfileViewController)? = nil
    ) {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureCollectionView()
        self.configureToastView(isButtonExisted: false)
        self.bindInput()
        self.bindUIComponents()
        self.bindViewModel()
    }
}

// MARK: - Methods

extension ProfileViewController {

    private func bindInput() {
        self.rx.viewWillAppear
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.viewWillAppearEvent.onNext(())
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.viewModel.output.didProfileFetch
            .subscribe(onNext: { [weak self] (entity, isMyProfile) in
                self?.profileMainView.setData(entity: entity, isMyProfile: isMyProfile)
                self?.dataCollectionView.reloadData()
                self?.updateCollectionViewHeight()
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.isUnknownProfile
            .asDriver(onErrorJustReturn: true)
            .drive(with: self) { owner, isUnknownProfile in
                owner.configureUnknownProfileUI()
                owner.unknownProfilePopUpView.showPopup(with: .unknownProfile)
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
                if UIApplication.shared.canOpenURL(url) {
                    owner.openSafari(with: url)
                } else {
                    owner.showToast(message: "유효한 링크가 아니에요")
                }
            }
            .disposed(by: self.disposeBag)
        
        self.profileMainView.didEditButtonTap()
            .emit(with: self) { owner, _ in
                guard let editProfileViewControllerFactory = owner.editProfileViewControllerFactory?() else { return }
                owner.navigationController?.pushViewController(editProfileViewControllerFactory, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.dataCollectionView.delegate = self
        self.dataCollectionView.dataSource = self
        
        self.dataCollectionView.register(ProfileLinkHeaderView.self,
                                         forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                         withReuseIdentifier: ProfileLinkHeaderView.className)
        self.dataCollectionView.register(ProfileLinkCollectionViewCell.self, forCellWithReuseIdentifier: ProfileLinkCollectionViewCell.className)
    }
    
    private func updateCollectionViewHeight() {
        self.dataCollectionView.layoutIfNeeded()
        let collectionViewHeight = self.dataCollectionView.contentSize.height
        self.dataCollectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionViewHeight)
        }
        
        self.profileMainView.layoutIfNeeded()
        let profileViewHeight = self.profileMainView.getHeight()
        self.profileMainView.snp.updateConstraints { make in
            make.height.equalTo(profileViewHeight)
        }
    }

    private func configureUnknownProfileUI() {
        self.profileMainView.setDataForUnknownProfile()

        self.profileMainView.snp.updateConstraints { make in
            make.height.equalTo(250)
        }

        self.unknownProfilePopUpView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)

            }
            .disposed(by: self.disposeBag)
    }

}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(self.viewModel.output.links.count, 3)
    }
    
    /// 헤더를 결정하는 메서드
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ProfileLinkHeaderView.className,
                for: indexPath
              ) as? ProfileLinkHeaderView else { return UICollectionReusableView() }
        
        header.expandButton.isHidden = self.viewModel.output.links.count <= 3
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileLinkCollectionViewCell.className,
                                                            for: indexPath) as? ProfileLinkCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(linkName: self.viewModel.output.links[indexPath.row].title)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.dataCollectionView.frame.width - 40, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard !self.viewModel.output.links.isEmpty else { return .zero }
        return CGSize(width: self.view.frame.width, height: 74)
    }
}

// MARK: - UI

extension ProfileViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.mainScrollView, self.unknownProfilePopUpView])
        self.navigationBar.setBackgroundColor(with: .grey90)
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.mainScrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(self.mainScrollView)
            make.width.equalTo(self.mainScrollView)
        }
        
        self.profileMainView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        self.dataCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        self.profileMainView.snp.makeConstraints { make in
            make.height.equalTo(400)
        }
        
        self.dataCollectionView.snp.makeConstraints { make in
            make.height.equalTo(0)
        }

        self.unknownProfilePopUpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
