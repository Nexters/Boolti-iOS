//
//  ConcertDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/3/24.
//

import UIKit

import RxSwift
import RxCocoa
import RxGesture
import Kingfisher
import FirebaseDynamicLinks

final class ConcertDetailViewController: BooltiViewController {
    
    // MARK: Properties

    typealias Content = String
    typealias Posters = [ConcertDetailEntity.Poster]
    typealias ConcertId = Int
    typealias PhoneNumber = String
    
    private let viewModel: ConcertDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let loginViewControllerFactory: () -> LoginViewController
    private let posterExpandViewControllerFactory: (Posters) -> PosterExpandViewController
    private let concertContentExpandViewControllerFactory: (Content) -> ConcertContentExpandViewController
    private let reportViewControllerFactory: () -> ReportViewController
    private let ticketSelectionViewControllerFactory: (ConcertId, TicketingType) -> TicketSelectionViewController
    private let contactViewControllerFactory: (ContactType, PhoneNumber) -> ContactViewController

    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .concertDetail)
    
    private let dimmedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black100.withAlphaComponent(0.85)
        view.isHidden = true

        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        scrollView.addSubviews([self.stackView])
        return scrollView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical

        stackView.addArrangedSubviews([
            self.concertPosterView,
            self.ticketingPeriodView,
            self.segmentedControlContainerView,
            self.concertDetailStackView,
            self.castTeamListCollectionView
        ])

        stackView.setCustomSpacing(40, after: self.concertPosterView)
        stackView.setCustomSpacing(40, after: self.ticketingPeriodView)
        return stackView
    }()

    private lazy var concertDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isHidden = false

        stackView.addArrangedSubviews([
            self.datetimeInfoView,
            self.placeInfoView,
            self.contentInfoView,
            self.organizerInfoView
        ])
        return stackView
    }()

    private lazy var castTeamListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 32, right: 20)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .grey95
        collectionView.isScrollEnabled = false
        collectionView.isHidden = true

        collectionView.register(
            CastTeamListCollectionViewCell.self,
            forCellWithReuseIdentifier: CastTeamListCollectionViewCell.className
        )

        collectionView.register(CastTeamListHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CastTeamListHeaderView.className)
        collectionView.register(CastTeamListFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CastTeamListFooterView.className)

        return collectionView
    }()

    private let concertPosterView = ConcertPosterView()
    
    private let ticketingPeriodView = TicketingPeriodView()
    
    private let datetimeInfoView = DatetimeInfoView()

    private let segmentedControlContainerView = SegmentedControlContainerView(items: ["공연 정보", "출연진"])

    private let placeInfoView = PlaceInfoView()
    
    private let contentInfoView = ContentInfoView()
    
    private let organizerInfoView = OrganizerInfoView(horizontalInset: 20, verticalInset: 32, height: 170)

    private lazy var buttonBackgroundView: UIView = {
        let view = UIView()

        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 24)
        gradient.colors = [UIColor.grey95.withAlphaComponent(0.0).cgColor, UIColor.grey95.cgColor]
        gradient.locations = [0.1, 0.7]
        view.layer.insertSublayer(gradient, at: 0)

        return view
    }()
    
    private let giftingButton: BooltiButton = {
        let button = BooltiButton(title: "선물하기")
        button.backgroundColor = .grey80
        return button
    }()
    
    private let ticketingButton = BooltiButton(title: "예매하기")
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 9
        stackView.addArrangedSubviews([self.giftingButton, self.ticketingButton])
        return stackView
    }()
    
    // MARK: Init
    
    init(viewModel: ConcertDetailViewModel,
         loginViewControllerFactory: @escaping () -> LoginViewController,
         posterExpandViewControllerFactory: @escaping (Posters) -> PosterExpandViewController,
         concertContentExpandViewControllerFactory: @escaping (Content) -> ConcertContentExpandViewController,
         reportViewControllerFactory: @escaping () -> ReportViewController,
         ticketSelectionViewControllerFactory: @escaping (ConcertId, TicketingType) -> TicketSelectionViewController,
         contactViewControllerFactory: @escaping (ContactType, PhoneNumber) -> ContactViewController) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.posterExpandViewControllerFactory = posterExpandViewControllerFactory
        self.concertContentExpandViewControllerFactory = concertContentExpandViewControllerFactory
        self.reportViewControllerFactory = reportViewControllerFactory
        self.ticketSelectionViewControllerFactory = ticketSelectionViewControllerFactory
        self.contactViewControllerFactory = contactViewControllerFactory
        
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
        self.configureToastView(isButtonExisted: true)
        self.bindUIComponents()
        self.bindInputs()
        self.bindOutputs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.dimmedBackgroundView.isHidden = true
        self.viewModel.fetchConcertDetail()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateCollectionViewHeight()
    }
}

// MARK: - Methods

extension ConcertDetailViewController {
    
    private func bindInputs() {
        self.ticketingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didTicketingButtonTap.accept(.ticketing)
            }
            .disposed(by: self.disposeBag)
        
        self.giftingButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didTicketingButtonTap.accept(.gifting)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOutputs() {
        self.viewModel.output.concertDetail
            .skip(1)
            .take(1)
            .bind(with: self) { owner, entity in
                guard let entity = entity else { return }
                
                owner.concertPosterView.setData(images: entity.posters, title: entity.name)
                owner.ticketingPeriodView.setData(startDate: entity.salesStartTime, endDate: entity.salesEndTime)
                owner.placeInfoView.setData(name: entity.placeName, streetAddress: entity.streetAddress, detailAddress: entity.detailAddress)
                owner.datetimeInfoView.setData(date: entity.date, runningTime: entity.runningTime)
                owner.contentInfoView.setData(content: entity.notice)
                owner.organizerInfoView.setData(hostName: entity.hostName)
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.buttonState
            .bind(with: self) { owner, state in
                owner.giftingButton.isHidden = !state.isEnabled
                
                owner.ticketingButton.isEnabled = state.isEnabled
                owner.ticketingButton.setTitle(state.title, for: .normal)
                owner.ticketingButton.setTitleColor(state.titleColor, for: .normal)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.navigate
            .asDriver(onErrorJustReturn: .login)
            .drive(with: self) { owner, destination in
                switch destination {
                case .login:
                    let viewController = owner.loginViewControllerFactory()
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                case .posterExpand(let posters):
                    let viewController = owner.posterExpandViewControllerFactory(posters)
                    viewController.modalPresentationStyle = .overFullScreen
                    owner.present(viewController, animated: true)
                case .contentExpand(let content):
                    let viewController = owner.concertContentExpandViewControllerFactory(content)
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .ticketSelection(let concertId, let type):
                    let viewController = owner.ticketSelectionViewControllerFactory(concertId, type)
                    viewController.onDismiss = {
                        owner.dimmedBackgroundView.isHidden = true
                    }
                    
                    owner.dimmedBackgroundView.isHidden = false
                    owner.present(viewController, animated: true)
                }
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.teamListEntities
            .asDriver()
            .drive(with: self) { owner, entity in
                owner.castTeamListCollectionView.reloadData()
                owner.castTeamListCollectionView.layoutIfNeeded()
                owner.updateCollectionViewHeight()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindUIComponents() {
        self.bindPlaceInfoView()
        self.bindPosterView()
        self.bindContentInfoView()
        self.bindNavigationBar()
        self.bindOrganizerInfoView()
        self.bindCollectionView()
    }
    
    private func bindPlaceInfoView() {
        self.placeInfoView.didAddressCopyButtonTap()
            .emit(with: self) { owner, _ in
                UIPasteboard.general.string = owner.viewModel.output.concertDetail.value?.streetAddress
                owner.showToast(message: "공연장 주소가 복사되었어요")
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindPosterView() {
        self.concertPosterView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorJustReturn: .init())
            .drive(with: self) { owner, _ in
                owner.viewModel.input.didPosterViewTap.accept(())
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindContentInfoView() {
        self.contentInfoView.didAddressExpandButtonTap()
            .emit(to: self.viewModel.input.didExpandButtonTap)
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didHomeButtonTap()
            .emit(with: self) { owner, _ in
                if let tabBarController = owner.tabBarController,
                   let navigationController = self.navigationController {
                    if tabBarController.selectedIndex == 0 {
                        navigationController.popToRootViewController(animated: true)
                    } else {
                        UIView.transition(with: tabBarController.view,
                                          duration: 0.3,
                                          options: .transitionCrossDissolve,
                                          animations: { tabBarController.selectedIndex = 0 },
                                          completion: { _ in navigationController.popToRootViewController(animated: false) })
                    }
                }
            }
            .disposed(by: self.disposeBag)
        
        self.navigationBar.didShareButtonTap()
            .emit(with: self) { owner, _ in
                guard let posterURL = owner.viewModel.output.concertDetail.value?.posters.first?.path
                else { return }
                guard let concertID = owner.viewModel.output.concertDetail.value?.id else { return }

                let image = KFImage(URL(string: posterURL))

                guard let link = URL(string: "https://preview.boolti.in/show/\(concertID)") else { return }
                let activityViewController = UIActivityViewController(
                    activityItems: [link, image],
                    applicationActivities: nil
                )
                activityViewController.popoverPresentationController?.sourceView = owner.view
                owner.present(activityViewController, animated: true, completion: nil)
            }
            .disposed(by: self.disposeBag)
        self.navigationBar.didMoreButtonTap()
            .emit(with: self) { owner, _ in
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                let reportAction = UIAlertAction(title: "신고하기", style: .default) { _ in
                    let viewController = owner.reportViewControllerFactory()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                 }
                 alertController.addAction(reportAction)

                let cancleAction = UIAlertAction(title: "취소하기", style: .cancel)
                alertController.addAction(cancleAction)

                owner.present(alertController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindOrganizerInfoView() {
        self.organizerInfoView.didCallButtonTap()
            .emit(with: self) { owner, _ in
                guard let phoneNumber = owner.viewModel.output.concertDetail.value?.hostPhoneNumber else { return }
                owner.present(owner.contactViewControllerFactory(.call, phoneNumber), animated: true)
            }
            .disposed(by: self.disposeBag)

        self.organizerInfoView.didMessageButtonTap()
            .emit(with: self) { owner, _ in
                guard let phoneNumber = owner.viewModel.output.concertDetail.value?.hostPhoneNumber else { return }
                owner.present(owner.contactViewControllerFactory(.message, phoneNumber), animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bindCollectionView() {
//        self.
    }
}

// MARK: - UIScrollViewDelegate

extension ConcertDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset <= self.concertPosterView.frame.height {
            self.navigationBar.setBackgroundColor(with: .grey90)
        } else {
            self.navigationBar.setBackgroundColor(with: .grey95)
        }
    }
}

// MARK: - UI

extension ConcertDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.scrollView,
                               self.buttonBackgroundView,
                               self.buttonStackView,
                               self.dimmedBackgroundView])
        
        self.view.backgroundColor = .grey95
        self.configureSegmentedControl()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.ticketingButton.snp.top)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.edges.equalTo(self.scrollView)
        }

        self.buttonBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(self.ticketingButton.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }
        
        self.buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        self.castTeamListCollectionView.snp.makeConstraints { make in
            make.height.equalTo(100) // 초기 설정
            make.horizontalEdges.equalToSuperview()
        }
    }

    private func configureSegmentedControl() {
        self.segmentedControlContainerView.segmentedControl.setTitleTextAttributes(
            [
            NSAttributedString.Key.foregroundColor: UIColor.grey70,
            .font: UIFont.subhead1
            ],
            for: .normal
        )
        self.segmentedControlContainerView.segmentedControl.setTitleTextAttributes(
            [
            NSAttributedString.Key.foregroundColor: UIColor.grey10,
            .font: UIFont.subhead1
            ],
            for: .selected
        )
        self.segmentedControlContainerView.segmentedControl.selectedSegmentIndex = 0
        
        let selectedSegmentIndex =  self.segmentedControlContainerView.segmentedControl.rx.selectedSegmentIndex

        selectedSegmentIndex
            .asDriver()
            .distinctUntilChanged()
            .skip(1)
            .drive(with: self, onNext: { owner, _ in
                owner.concertDetailStackView.isHidden.toggle()
                owner.castTeamListCollectionView.isHidden.toggle()
            })
            .disposed(by: self.disposeBag)

        selectedSegmentIndex
            .distinctUntilChanged()
            .filter { $0 == 1 }
            .take(1)
            .subscribe(with: self, onNext: { owner, _ in
                owner.viewModel.fetchCastTeamList()
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: CollectionView

extension ConcertDetailViewController {

    private func updateCollectionViewHeight() {
        self.castTeamListCollectionView.snp.updateConstraints { make in
            make.height.equalTo(self.castTeamListCollectionView.contentSize.height)
        }
    }
}

// MARK: CollectionViewDatasource

extension ConcertDetailViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return 0 }
        return listEntities.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return 0 }
        let members = listEntities[section].members

        return members.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CastTeamListCollectionViewCell.className,
            for: indexPath
        ) as? CastTeamListCollectionViewCell else {
            fatalError("Failed to load cell!")
        }
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return UICollectionViewCell() }

        let entity = listEntities[indexPath.section].members[indexPath.row]
        cell.configure(with: entity)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return UICollectionReusableView() }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CastTeamListHeaderView.className, for: indexPath) as? CastTeamListHeaderView else { return UICollectionReusableView() }
            let headerTitle = listEntities[indexPath.section].name
            headerView.configure(with: headerTitle)
            return headerView
        case UICollectionView.elementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CastTeamListFooterView.className, for: indexPath) as? CastTeamListFooterView else { return UICollectionReusableView() }
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: CollectionViewDelegateFlowLayout

extension ConcertDetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 2 - 40
        let size = CGSize(width: width, height: 48)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 62)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: 1)
    }
}
