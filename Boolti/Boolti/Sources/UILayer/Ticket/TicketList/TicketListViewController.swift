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

final class TicketListViewController: BooltiViewController {

    typealias TicketID = (String)

    private let loginViewControllerFactory: () -> LoginViewController
    private let ticketDetailControllerFactory: (TicketID) -> TicketDetailViewController
    private let qrExpandViewControllerFactory: (UIImage) -> QRExpandViewController

    private enum Section {
        case concertList
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, TicketItemEntity>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TicketItemEntity>

    private var datasource: DataSource?
    private static let ticketListFooterViewKind = "ticketListFooterViewKind"

    private let viewModel: TicketListViewModel
    private let disposeBag = DisposeBag()

    private let currentTicketPage = BehaviorRelay<Int>(value: 1)
    private let ticketPageCount = PublishRelay<Int>()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .grey95
        collectionView.alwaysBounceVertical = false
        collectionView.register(
            TicketListCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: TicketListCollectionViewCell.self)
        )
        collectionView.register(
            TicketListFooterView.self,
            forSupplementaryViewOfKind: TicketListViewController.ticketListFooterViewKind,
            withReuseIdentifier: String(describing: TicketListFooterView.self)
        )

        return collectionView
    }()

    private let loginEnterView: LoginEnterView = {
        let view = LoginEnterView()
        view.backgroundColor = .grey95
        view.isHidden = true

        return view
    }()

    private let concertEnterView: ConcertEnterView = {
        let view = ConcertEnterView()
        view.backgroundColor = .black100
        view.isHidden = true

        return view
    }()

    init(
        viewModel: TicketListViewModel,
        loginViewControllerFactory: @escaping () -> LoginViewController,
        qrExpandViewControllerFactory: @escaping (UIImage) -> QRExpandViewController,
        ticketDetailViewControllerFactory: @escaping (TicketID) -> TicketDetailViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        self.ticketDetailControllerFactory = ticketDetailViewControllerFactory
        self.qrExpandViewControllerFactory = qrExpandViewControllerFactory
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureLoadingIndicatorView()
        self.configureCollectionViewDatasource()
        self.bindUIComponenets()
        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loginEnterView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
    }

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
                top: 40,
                leading: 6,
                bottom: 5,
                trailing: 6
            )

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.68))

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

            self?.currentTicketPage.accept(currentPage+1)

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

    private func bindUIComponenets() {
        self.collectionView.rx
            .itemSelected
            .asDriver()
            .drive(with: self) { owner, indexPath in
                guard let ticketItem = owner.datasource?.itemIdentifier(for: indexPath) else { return }
                owner.viewModel.output.navigation.accept(.detail(ticketID: "\(ticketItem.ticketID)"))
            }
            .disposed(by: self.disposeBag)
    }

    private func bindViewModel() {
        self.bindInput()
        self.bindOutput()
    }

    private func bindInput() {
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
                if !isTicketsExist {
                    owner.concertEnterView.isHidden = false
                }
            }
            .disposed(by: self.disposeBag)

        self.viewModel.output.sectionModels
            .asDriver(onErrorJustReturn: [])
            .drive(with: self, onNext: { owner, ticketItems in
                owner.applySnapshot(ticketItems)
                owner.ticketPageCount.accept(ticketItems.count)
            })
            .disposed(by: self.disposeBag)

        self.viewModel.output.navigation
            .subscribe(with: self) { owner, ticketDestination in
                let viewController = owner.createViewController(ticketDestination)

                if let viewController = viewController as? LoginViewController {
                    viewController.hidesBottomBarWhenPushed = true
                    viewController.modalPresentationStyle = .fullScreen
                    owner.present(viewController, animated: true)
                } else {
                    owner.navigationController?.pushViewController(viewController, animated: true)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func configureCollectionViewDatasource() {
        self.datasource = UICollectionViewDiffableDataSource(
            collectionView: self.collectionView,
            cellProvider: { [weak self ] collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TicketListCollectionViewCell.self), for: indexPath) as? TicketListCollectionViewCell else { return UICollectionViewCell() }
                cell.setData(with: item)
                guard item.ticketStatus == .notUsed else { return UICollectionViewCell() }
                self?.bindQRCodeExpandView(cell)

            return cell
        })

        self.datasource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: TicketListFooterView.self), for: indexPath)

            self?.bind(supplementaryView)
            return supplementaryView
        }
    }

    private func bindQRCodeExpandView(_ cell: TicketListCollectionViewCell) {
        let qrCodeImageView = cell.ticketInformationView.qrCodeImageView

        qrCodeImageView.rx.tapGesture()
            .when(.recognized)
            .asDriver(onErrorDriveWith: .never())
            .drive(with: self) { owner, _ in
                guard let QRCodeImage = qrCodeImageView.image else { return }
                let viewController = owner.qrExpandViewControllerFactory(QRCodeImage)
                viewController.modalPresentationStyle = .overFullScreen
                owner.present(viewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }

    private func bind(_ footerView: UICollectionReusableView) {
        guard let footerView = footerView as? TicketListFooterView else { return }
        footerView.isHidden = true
        Observable.combineLatest(self.currentTicketPage, self.ticketPageCount)
            .subscribe { (currentPage, pagesCount) in
                footerView.isHidden = false
                footerView.pageIndicatorLabel.text = "\(currentPage)/\(pagesCount)"
            }
            .disposed(by: self.disposeBag)
    }

    private func applySnapshot(_ ticketItems: [TicketItemEntity]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.concertList])
        snapshot.appendItems(ticketItems, toSection: .concertList)

        datasource?.apply(snapshot, animatingDifferences: false)
    }

    private func createViewController(_ next: TicketListViewDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        case .detail(ticketID: let id):
            return ticketDetailControllerFactory(id)
        }
    }
}
