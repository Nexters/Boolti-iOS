//
//  TicketViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit
import RxCocoa
import RxSwift
import RxAppState
import SnapKit

final class TicketViewController: BooltiViewController {

    private let loginViewControllerFactory: () -> LoginViewController

    private enum Section {
        case concertList
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, TicketItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TicketItem>

    private var datasource: DataSource?

    private let viewModel: TicketViewModel
    private let disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.createLayout())
        collectionView.backgroundColor = .black
        collectionView.register(
            UsableTicketTableViewCell.self,
            forCellWithReuseIdentifier: String(describing: UsableTicketTableViewCell.self)
        )

        return collectionView
    }()


    private let loginEnterView: LoginEnterView = {
        let view = LoginEnterView()
        // 색깔은 바꿔줄 예정!..
        view.backgroundColor = .black100
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
        viewModel: TicketViewModel,
        loginViewControllerFactory: @escaping () -> LoginViewController
    ) {
        self.viewModel = viewModel
        self.loginViewControllerFactory = loginViewControllerFactory
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        self.navigationController?.navigationBar.isHidden = true
        self.configureCollectionViewDatasource()
        self.configureUI()
        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.loginEnterView.isHidden = true
    }

    private func configureUI() {
        self.view.addSubviews([
            self.collectionView,
            self.loginEnterView,
            self.concertEnterView
        ])

        self.collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(30)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-70)
            make.horizontalEdges.equalTo(self.view.safeAreaLayoutGuide)
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
                top: 0,
                leading: 10,
                bottom: 10,
                trailing: 10
            )

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.6))

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)

            section.orthogonalScrollingBehavior = .groupPagingCentered
            self.setupCollectionViewCarousel(to: section)
            return section
        }

        return layout
    }

    private func setupCollectionViewCarousel(to section: NSCollectionLayoutSection) {
        section.visibleItemsInvalidationHandler = { visibleItems, offset, environment in

            // 현재 Page 관련 정보!..
            let currentPage = Int(max(0, round(offset.x / environment.container.contentSize.width)))
            print(currentPage)
            visibleItems.forEach { item in

                // 아이템과 스크롤된 화면 사이의 교차하는 영역을 계산
                let intersectedRect = item.frame.intersection(
                    CGRect(x: offset.x, y: offset.y, width: environment.container.contentSize.width, height: item.frame.height)
                )
                //  아이템이 화면에서 얼마나 보이는지를 나타내는 비율을 계산
                let percentVisible = intersectedRect.width / item.frame.width
                
                // 스케일 설정
                let scale = 0.8 + (0.1 * percentVisible)
                item.transform = CGAffineTransform(scaleX: 1, y: scale)
            }
        }
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

        self.concertEnterView.navigateToHomeButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.tabBarController?.selectedIndex = 0
            }
            .disposed(by: self.disposeBag)
    }

    private func bindOutput() {

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
            cellProvider: { collectionView, indexPath, item in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UsableTicketTableViewCell.self), for: indexPath) as? UsableTicketTableViewCell else { return UICollectionViewCell() }
                cell.setData(with: item)

            return cell
        })
    }

    private func applySnapshot(_ ticketItems: [TicketItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.concertList])
        snapshot.appendItems(ticketItems, toSection: .concertList)

        datasource?.apply(snapshot)
    }

    private func createViewController(_ next: TicketViewDestination) -> UIViewController {
        switch next {
        case .login: return loginViewControllerFactory()
        }
    }
}
