//
//  TicketListViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift
import RxRelay
import RxAppState

protocol TicketDetailViewControllerDelegate: AnyObject {
    func ticketDetailViewControllerDidCancelGift(_ viewController: TicketDetailViewController)
}

final class TicketListViewController: BooltiViewController {

    // MARK: Properties

    typealias TicketID = String
    typealias TicketName = String

    private let loginViewControllerFactory: () -> LoginViewController
    private let ticketDetailControllerFactory: (TicketID) -> TicketDetailViewController

    private enum Section {
        case concertList
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, TicketItemEntity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TicketItemEntity>

    private var datasource: DataSource?
    private static let ticketListFooterViewKind = "ticketListFooterViewKind"

    private let viewModel: TicketListViewModel
    private let disposeBag = DisposeBag()


    // MARK: UI Component

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .grey95
        collectionView.alwaysBounceVertical = false
        collectionView.register(
            TicketListCollectionViewCell.self,
            forCellWithReuseIdentifier: TicketListCollectionViewCell.className
        )
        collectionView.register(
            TicketListFooterView.self,
            forSupplementaryViewOfKind: TicketListViewController.ticketListFooterViewKind,
            withReuseIdentifier: TicketListFooterView.className
        )

        return collectionView
    }()

    private let loginEnterView: LoginEnterView = {
        let view = LoginEnterView()
        view.isHidden = true

        return view
    }()

    private let concertEnterView: ConcertEnterView = {
        let view = ConcertEnterView()
        view.isHidden = true

        return view
    }()

    // MARK: Init

    init(
        viewModel: TicketListViewModel,
        loginViewControllerFactory: @escaping () -> LoginViewController,
        ticketDetailViewControllerFactory: @escaping (TicketID) -> TicketDetailViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.ticketDetailControllerFactory = ticketDetailViewControllerFactory
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureLoadingIndicatorView()
        self.configureToastView(isButtonExisted: true)
        self.configureCollectionViewDatasource()
        self.bindUIComponents()
        self.bindViewModel()
    }

    // MARK: - Binding Methods

    private func bindUIComponents() {
        self.collectionView.rx
            .itemSelected
            .asDriver()
            .drive(with: self) { owner, indexPath in
                guard let ticketItem = owner.datasource?.itemIdentifier(for: indexPath) else { return }
                owner.viewModel.output.navigation.accept(.detail(reservationID: "\(ticketItem.reservationID)"))
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }

    private func bindInput() {
        self.rx.viewWillAppear
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.loginEnterView.isHidden = true
                owner.tabBarController?.tabBar.isHidden = false
            })
            .disposed(by: self.disposeBag)

        self.rx.viewDidAppear
            .asDriver(onErrorJustReturn: true)
            .drive(with: self, onNext: { owner, _ in
                owner.viewModel.input.viewDidAppearEvent.onNext(())
            })
            .disposed(by: self.disposeBag)

        self.loginEnterView.loginButton.rx.tap
            .asDriver()
            .drive(self.viewModel.input.didloginButtonTapEvent)
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {

        self.viewModel.output.isLoading
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(self.isLoading)
            .disposed(by: self.disposeBag)

        self.viewModel.output.isAccessTokenLoaded
            .skip(1)
            .asDriver(onErrorJustReturn: false)
            .drive(with: self, onNext: { owner, isLoaded in
                // AccessToken이 없으면 -> LoginEnterView를 띄우기!..
                if !isLoaded {
                    owner.loginEnterView.isHidden = false
                } else {
                    // AcessToken이 있으면 -> TableView를 띄어야한다고 VM에게 알리기
                    owner.viewModel.input.shouldLoadTableViewEvent.onNext(())
                }
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.isTicketsExist
            .subscribe(with: self) { owner, isTicketsExist in
                owner.concertEnterView.isHidden = isTicketsExist
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.sectionModels
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, ticketItems in
                owner.applySnapshot(ticketItems)
                owner.viewModel.input.ticketsCount.accept(ticketItems.count)
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.navigation
            .subscribe(with: self) { owner, ticketDestination in
                owner.handleNavigation(to: ticketDestination)
            }
            .disposed(by: self.disposeBag)
    }

    private func bind(_ footerView: UICollectionReusableView) {
        guard let footerView = footerView as? TicketListFooterView else { return }

        self.viewModel.output.ticketPage.subscribe { (currentTicketPage, ticketsCount) in
            footerView.isHidden = false
            footerView.pageIndicatorLabel.text = "\(currentTicketPage)/\(ticketsCount)"
        }
        .disposed(by: self.disposeBag)
    }

    // MARK: Methods

    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true

        self.view.addSubviews([
            self.collectionView,
            self.loginEnterView,
            self.concertEnterView
        ])

        self.collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.loginEnterView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.concertEnterView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _,_ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            item.contentInsets = NSDirectionalEdgeInsets(
                top: 20,
                leading: 6,
                bottom: 10,
                trailing: 6
            )

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.66))

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(35)
            )

            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: TicketListViewController.ticketListFooterViewKind,
                alignment: .bottom
            )
            footer.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0)

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [footer]
            section.orthogonalScrollingBehavior = .groupPagingCentered

            self.configureCollectionViewCarousel(of: section)

            return section
        }

        return layout
    }

    private func configureCollectionViewCarousel(of section: NSCollectionLayoutSection) {
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, offset, environment in

            let visibleCellItems = visibleItems.filter {
                $0.representedElementKind != TicketListViewController.ticketListFooterViewKind
            }

            let inset = (environment.container.contentSize.width)*0.05
            // 현재 Page 관련 정보!..
            let currentPage = Int(max(0, floor((offset.x + inset) / ((environment.container.contentSize.width)*0.88))))

            self?.viewModel.input.currentTicketPage.accept(currentPage+1)

            visibleCellItems.forEach { item in
                let intersectedRect = item.frame.intersection(
                    CGRect(x: offset.x, y: offset.y, width: environment.container.contentSize.width, height: item.frame.height)
                )
                let percentVisible = intersectedRect.width / item.frame.width
                let scale = 0.8 + (0.2 * percentVisible)
                item.transform = CGAffineTransform(scaleX: 1, y: scale)
            }
        }
    }

    private func configureCollectionViewDatasource() {
        self.datasource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TicketListCollectionViewCell.className,
                    for: indexPath
                ) as? TicketListCollectionViewCell else { return UICollectionViewCell() }
                cell.disposeBag = DisposeBag()
                cell.setData(with: item)

                return cell
            })

        self.datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TicketListFooterView.className,
                for: indexPath
            )

            self?.bind(supplementaryView)
            return supplementaryView
        }
    }

    private func applySnapshot(_ ticketItems: [TicketItemEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.concertList])
        snapshot.appendItems(ticketItems, toSection: .concertList)

        datasource?.apply(snapshot, animatingDifferences: false)
    }

    private func handleNavigation(to destination: TicketListViewDestination) {
        switch destination {
        case .login:
            let loginVC = loginViewControllerFactory()
            loginVC.hidesBottomBarWhenPushed = true
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true)
        case .detail(reservationID: let id):
            let ticketDetailVC = ticketDetailControllerFactory(id)
            ticketDetailVC.delegate = self
            self.navigationController?.pushViewController(ticketDetailVC, animated: true)
        }
    }
}

extension TicketListViewController: TicketDetailViewControllerDelegate {
    func ticketDetailViewControllerDidCancelGift(_ viewController: TicketDetailViewController) {
        self.showToast(message: "받은 선물을 취소했어요")
    }
}
