//
//  ConcertListViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit

import RxSwift

final class ConcertListViewController: BooltiViewController {
    
    // MARK: Properties
    
    enum Section: Int, CaseIterable {
        case title
        case searchBar
        case topConcerts
        case banner
        case bottomConcerts
        case information
    }
    
    typealias ConcertId = Int
    
    private let viewModel: ConcertListViewModel
    private let disposeBag = DisposeBag()
    private let concertDetailViewControllerFactory: (ConcertId) -> ConcertDetailViewController
    private let businessInfoViewControllerFactory: () -> BusinessInfoViewController
    private let loginViewControllerFactory: () -> LoginViewController
    
    // MARK: UI Component
    
    private let mainCollectionView: UICollectionView = {
        let layout = ConcertCollectionViewFlowLayout(stickyIndexPath: IndexPath(item: 0, section: 1))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.backgroundColor = .grey95
        return collectionView
    }()
    
    private let popupView = BooltiPopupView()
    
    // MARK: Init
    
    init(
        viewModel: ConcertListViewModel,
        concertDetailViewControllerFactory: @escaping (ConcertId) -> ConcertDetailViewController,
        businessInfoViewControllerFactory: @escaping () -> BusinessInfoViewController,
        loginViewControllerFactory: @escaping () -> LoginViewController
    ) {
        self.viewModel = viewModel
        self.concertDetailViewControllerFactory = concertDetailViewControllerFactory
        self.businessInfoViewControllerFactory = businessInfoViewControllerFactory
        self.loginViewControllerFactory = loginViewControllerFactory
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.configureCollectionView()
        self.configureToastView(isButtonExisted: true)
        self.bindInputs()
        self.bindOutputs()
        self.viewModel.checkAdminPopup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.viewModel.fetchConcertList(concertName: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.configureDynamicLinkDestination()
        self.mainCollectionView.reloadSections([0], animationStyle: .automatic)
    }

}

// MARK: - Methods

extension ConcertListViewController {
    
    private func bindInputs() {
        self.popupView.didConfirmButtonTap()
            .emit(with: self) { owner, _ in
                owner.popupView.isHidden = true
                
                switch owner.popupView.popupType {
                case .requireLogin:
                    let viewController = owner.loginViewControllerFactory()
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .registerGift, .registerMyGift:
                    owner.viewModel.input.didRegisterGiftButtonTap.accept(())
                default:
                    break
                }
            }
            .disposed(by: self.disposeBag)
        
        self.popupView.didCancelButtonTap()
            .emit(with: self) { owner, _ in
                owner.popupView.isHidden = true
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.didConcertFetch
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, concerts in
                owner.mainCollectionView.reloadSections([2, 3, 4], animationStyle: .automatic)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.didRegisterGift
            .asDriver(onErrorJustReturn: false)
            .drive(with: self) { owner, isSuccess in
                if isSuccess {
                    owner.showToast(message: "선물이 등록되었어요")
                    owner.changeTab(to: .ticket)
                } else {
                    owner.popupView.showPopup(with: .registerGiftError)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.showRegisterGiftPopUp
            .subscribe(with: self) { owner, giftType in
                switch giftType {
                case .receive:
                    owner.popupView.showPopup(with: .registerGift,
                                              withCancelButton: true)
                case .send:
                    owner.popupView.showPopup(with: .registerMyGift,
                                              withCancelButton: true)
                }
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.showEventPopup
            .subscribe(with: self) { owner, popupData in
                let eventPopupViewController = BooltiEventPopupViewController(with: popupData)
                eventPopupViewController.modalPresentationStyle = .overFullScreen
                owner.present(eventPopupViewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        
        self.mainCollectionView.register(ConcertListMainTitleCollectionViewCell.self, forCellWithReuseIdentifier: ConcertListMainTitleCollectionViewCell.className)
        self.mainCollectionView.register(SearchBarCollectionViewCell.self, forCellWithReuseIdentifier: SearchBarCollectionViewCell.className)
        self.mainCollectionView.register(ConcertCollectionViewCell.self, forCellWithReuseIdentifier: ConcertCollectionViewCell.className)
        self.mainCollectionView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.className)
        self.mainCollectionView.register(BusinessInfoCollectionViewCell.self, forCellWithReuseIdentifier: BusinessInfoCollectionViewCell.className)
    }
    
}

// MARK: - UICollectionViewDelegate

extension ConcertListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .topConcerts:
            let viewController = concertDetailViewControllerFactory(self.viewModel.output.topConcerts[indexPath.row].id)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .banner:
            guard let url = URL(string: Environment.LOGIN_URL) else { return }
        UIApplication.shared.open(url, options: [:])

        case .bottomConcerts:
            let viewController = concertDetailViewControllerFactory(self.viewModel.output.bottomConcerts[indexPath.row].id)
            self.navigationController?.pushViewController(viewController, animated: true)
        case .title, .searchBar, .information:
            break
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

}

// MARK: - UICollectionViewDataSource

extension ConcertListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .topConcerts:
            return viewModel.output.topConcerts.count
        case .banner:
            return viewModel.output.showBanner ? 1 : 0
        case .bottomConcerts:
            return viewModel.output.bottomConcerts.count
        case .title, .searchBar, .information:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return .init() }
        
        switch section {
        case .title:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConcertListMainTitleCollectionViewCell.className, for: indexPath) as? ConcertListMainTitleCollectionViewCell else { return UICollectionViewCell() }
            cell.setTitle()
            return cell
        case .searchBar:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchBarCollectionViewCell.className, for: indexPath) as? SearchBarCollectionViewCell else { return UICollectionViewCell() }
            
            cell.didSearchTap()
                .emit(with: self) { owner, _ in
                    owner.viewModel.fetchConcertList(concertName: cell.searchBarTextField.text)
                }
                .disposed(by: self.disposeBag)
            
            return cell
        case .topConcerts, .bottomConcerts:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConcertCollectionViewCell.className, for: indexPath) as? ConcertCollectionViewCell else { return UICollectionViewCell() }
            
            // 배너 상단
            if section == .topConcerts {
                cell.setData(concertEntity: self.viewModel.output.topConcerts[indexPath.item])
            }
            // 배너 하단
            else {
                cell.setData(concertEntity: self.viewModel.output.bottomConcerts[indexPath.item])
            }
            return cell
        case .banner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.className, for: indexPath) as? BannerCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        case .information:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessInfoCollectionViewCell.className, for: indexPath) as? BusinessInfoCollectionViewCell else { return UICollectionViewCell() }
            
            cell.disposeBag = DisposeBag()
            
            cell.businessInfoView.didInfoButtonTap()
                .emit(with: self) { owner, _ in
                    let viewController = self.businessInfoViewControllerFactory()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
                .disposed(by: cell.disposeBag)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConcertListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let section = Section(rawValue: indexPath.section) else { return .zero }
        
        switch section {
        case .title:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 96)
        case .searchBar:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 80)
        case .topConcerts, .bottomConcerts:
            return CGSize(width: (self.mainCollectionView.frame.width - 40) / 2 - 7.5, height: max(313, 313 * self.view.bounds.height / 812))
        case .banner:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 80)
        case .information:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 86)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let section = Section(rawValue: section) else { return .zero }
        
        switch section {
        case .topConcerts, .bottomConcerts:
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        case .banner:
            return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        case .title, .searchBar, .information:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .topConcerts, .bottomConcerts:
            return 15
        case .title, .searchBar, .banner, .information:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .topConcerts, .bottomConcerts:
            return 20
        case .title, .searchBar, .banner, .information:
            return 0
        }
    }
}

// MARK: - UI

extension ConcertListViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        
        self.view.addSubviews([self.mainCollectionView,
                               self.popupView])
    }
    
    private func configureConstraints() {
        self.mainCollectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.popupView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureDynamicLinkDestination() {
        guard let landingDestination = UserDefaults.landingDestination else { return }
        
        switch landingDestination {
        case .concertDetail(let concertID):
            let viewController = concertDetailViewControllerFactory(concertID)
            self.navigationController?.pushViewController(viewController, animated: true)
            UserDefaults.landingDestination = nil
        case .concertList(let giftUuid):
            if UserDefaults.accessToken.isEmpty {
                self.popupView.showPopup(with: .requireLogin)
            } else {
                self.viewModel.input.checkGift.onNext(giftUuid)
                UserDefaults.landingDestination = nil
            }
        default:
            break
        }
    }
}
