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
    typealias UserCode = String

    private let viewModel: ConcertDetailViewModel
    private let disposeBag = DisposeBag()
    
    private let loginViewControllerFactory: () -> LoginViewController
    private let posterExpandViewControllerFactory: (Posters) -> PosterExpandViewController
    private let concertContentExpandViewControllerFactory: (Content) -> ConcertContentExpandViewController
    private let reportViewControllerFactory: () -> ReportViewController
    private let ticketSelectionViewControllerFactory: (ConcertId, TicketingType) -> TicketSelectionViewController
    private let contactViewControllerFactory: (ContactType, PhoneNumber) -> ContactViewController
    private let profileViewControllerFactory: (UserCode?) -> ProfileViewController

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
            self.segmentedControlContainerView,
            // TODO: - insert web view
            self.castTeamListCollectionView
        ])

        stackView.setCustomSpacing(20, after: self.concertPosterView)
        return stackView
    }()

    private lazy var castTeamListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
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
    private let remainingSalesTimeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .grey05
        label.font = .subhead1
        label.textColor = .grey90
        label.textAlignment = .center

        return label
    }()

    private let segmentedControlContainerView = SegmentedControlContainerView(items: ["공연 정보", "출연진"])

    private let emptyCastView = EmptyCastTeamListView()

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
    
    private let ticketingButton = BooltiButton(title: "-")

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
         contactViewControllerFactory: @escaping (ContactType, PhoneNumber) -> ContactViewController,
         profileViewControllerFactory: @escaping (UserCode?) -> ProfileViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.posterExpandViewControllerFactory = posterExpandViewControllerFactory
        self.concertContentExpandViewControllerFactory = concertContentExpandViewControllerFactory
        self.reportViewControllerFactory = reportViewControllerFactory
        self.ticketSelectionViewControllerFactory = ticketSelectionViewControllerFactory
        self.contactViewControllerFactory = contactViewControllerFactory
        self.profileViewControllerFactory = profileViewControllerFactory

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
        self.viewModel.fetchCastTeamList()
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

    private func configureRemainingSaleTimerBanner(salesEndTime: Date, ticketingStatus: ConcertTicketingState) {
        switch ticketingStatus {
        case .onSale(let isLastDate) where isLastDate:
            self.bindRemaingSaleTimerBanner(salesEndTime: salesEndTime)
        default:
            self.remainingSalesTimeLabel.isHidden = true
            self.updateConstraintsForNonBannerCase()
        }
    }

    private func bindOutputs() {
        self.viewModel.output.concertDetail
            .skip(1)
            .take(1)
            .bind(with: self) { owner, entity in
                guard let entity = entity else { return }
                owner.concertPosterView.setData(images: entity.posters, title: entity.name,
                                                date: entity.date, runningTime: entity.runningTime)
                owner.configureRemainingSaleTimerBanner(salesEndTime: entity.salesEndTime, ticketingStatus: entity.ticketingState)
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.buttonState
            .skip(1)
            .bind(with: self) { owner, state in
                owner.giftingButton.isHidden = !state.isEnabled

                owner.ticketingButton.isEnabled = state.isEnabled
                owner.ticketingButton.setTitleColor(state.titleColor, for: .normal)

                switch state {
                case .beforeSale(let startDate):
                    owner.bindBeforeSaleTimerButton(startDate: startDate)
                case .endConcert, .endSale:
                    owner.buttonStackView.isHidden = true
                    owner.buttonBackgroundView.isHidden = true
                default:
                    owner.ticketingButton.setTitle(state.title, for: .normal)
                }
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
                owner.configureEmptyCastTeamListView()
                owner.configureCollectionView()
            }
            .disposed(by: self.disposeBag)
    }


    private func bindUIComponents() {
        self.bindPosterView()
        self.bindNavigationBar()
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
                guard let concertDetail = owner.viewModel.output.concertDetail.value else { return }
                
                let viewController = ConcertShareViewController(concertData: concertDetail)
                self.present(viewController, animated: true)
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

    // TODO: Timer 설정하는 코드 중복되는 거 고도화하기
    private func bindRemaingSaleTimerBanner(salesEndTime: Date) {
        let calendar = Calendar.current

        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ -> String in
                let currentDate = Date()

                let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: salesEndTime)

                if let hour = components.hour, let minute = components.minute, let second = components.second {
                    return String(format: "🔥 판매 종료까지 %02d:%02d:%02d", hour, minute, second)
                } else {
                    return ""
                }
            }
            .take(until: Observable.just(()).delay(.seconds(Int(salesEndTime.timeIntervalSinceNow)), scheduler: MainScheduler.instance))
            .do(onCompleted: { [weak self] in
                self?.viewModel.fetchConcertDetail()
            })
            .bind(with: self, onNext: { owner, text in
                owner.remainingSalesTimeLabel.text = text
            })
            .disposed(by: self.disposeBag)
    }

    private func bindBeforeSaleTimerButton(startDate: Date) {
        let calendar = Calendar.current

        Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { _ -> String in
                let currentDate = Date()

                let components = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: startDate)

                if let hour = components.hour, let minute = components.minute, let second = components.second {
                    let day = components.day ?? 0
                    let adjustedDay = max(day, 0)
                    return String(format: "판매 시작까지 %d일 %02d:%02d:%02d", adjustedDay, hour, minute, second)
                } else {
                    return ""
                }
            }
            .take(until: Observable.just(()).delay(.seconds(Int(startDate.timeIntervalSinceNow)), scheduler: MainScheduler.instance))
            .do(onCompleted: { [weak self] in
                self?.viewModel.fetchConcertDetail()
            })
            .bind(with: self, onNext: { owner, text in
                owner.ticketingButton.setTitle(text, for: .normal)
            })
            .disposed(by: self.disposeBag)
    }

    private func configureCollectionView() {
        self.castTeamListCollectionView.reloadData()
        self.castTeamListCollectionView.layoutIfNeeded()
        self.updateCollectionViewHeight()
    }

    private func configureEmptyCastTeamListView() {
        self.stackView.addArrangedSubview(self.emptyCastView)
        self.emptyCastView.isHidden = true
    }
}

// MARK: - UI

extension ConcertDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar,
                               self.remainingSalesTimeLabel,
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

        self.remainingSalesTimeLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }

        self.dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.remainingSalesTimeLabel.snp.bottom)
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

    // 여기서 ScrollView height를 수정해준다.
    private func updateConstraintsForNonBannerCase() {
        self.remainingSalesTimeLabel.isHidden = true

        self.concertPosterView.updateHeight()

        self.scrollView.snp.remakeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            if buttonStackView.isHidden {
                make.bottom.equalToSuperview()
            } else {
                make.bottom.equalTo(self.ticketingButton.snp.top)
            }
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

        self.segmentedControlContainerView.segmentedControl.rx.selectedSegmentIndex
            .asDriver()
            .distinctUntilChanged()
            .drive(with: self, onNext: { owner, index in
                if index == 1 {
                    owner.configureCastView()
                } else {
                    owner.configureConcertDetailView()
                }
            })
            .disposed(by: self.disposeBag)
    }

    private func configureCastView() {
        // TODO: - web view isHidden true
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return }
        if listEntities.isEmpty {
            self.emptyCastView.isHidden = false
            self.castTeamListCollectionView.isHidden = true
        } else {
            self.castTeamListCollectionView.isHidden = false
            self.emptyCastView.isHidden = true
        }
    }

    private func configureConcertDetailView() {
        self.emptyCastView.isHidden = true
        self.castTeamListCollectionView.isHidden = true
        // TODO: - web view isHidden false
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

        if section == 0 {
            return CGSize(width: width, height: 58)
        } else {
            return CGSize(width: width, height: 46)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return UIEdgeInsets() }

        let isLastSection = section == listEntities.count - 1
        let hasMembers = !listEntities[section].members.isEmpty

        let bottomInset: CGFloat
        let topInset: CGFloat

        // 맴버가 있는 지 없는 지 판단하기!
        if isLastSection {
            if hasMembers {
                topInset = 24
                bottomInset = buttonStackView.isHidden == true ? 32 : 48
            } else {
                topInset = 0
                bottomInset = buttonStackView.isHidden == true ? 32 : 48
            }
        } else {
            if hasMembers {
                topInset = 24
                bottomInset = 24
            } else {
                topInset = 0
                bottomInset = 24
            }
        }

        return UIEdgeInsets(top: topInset, left: 20, bottom: bottomInset, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return CGSize.zero }
        let width = collectionView.frame.width

        if listEntities.count == 1 || section == listEntities.count - 1 {
            return CGSize.zero
        } else {
            return CGSize(width: width, height: 1)
        }
    }
}

// MARK: UICollectionViewDelegate

extension ConcertDetailViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let listEntities = self.viewModel.output.teamListEntities.value else { return }
        let user = listEntities[indexPath.section].members[indexPath.row]
        
        var viewController: ProfileViewController
        if user.code == UserDefaults.userCode {
            viewController = self.profileViewControllerFactory(nil)
        } else {
            viewController = self.profileViewControllerFactory(user.code)
        }
        self.navigationController?.pushViewController(viewController, animated: true)
    }

}
