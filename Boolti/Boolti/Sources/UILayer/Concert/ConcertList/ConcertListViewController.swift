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
    
    typealias ConcertId = Int
    
    private let viewModel: ConcertListViewModel
    private let disposeBag = DisposeBag()
    private let concertDetailViewControllerFactory: (ConcertId) -> ConcertDetailViewController
    private let ticketReservationsViewControllerFactory: () -> TicketReservationsViewController
    
    // MARK: UI Component
    
    private let mainCollectionView: UICollectionView = {
        let layout = ConcertCollectionViewFlowLayout(stickyIndexPath: IndexPath(item: 0, section: 2))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = .init(top: 20, left: 20, bottom: 20, right: 20)
        collectionView.backgroundColor = .grey95
        return collectionView
    }()

    // MARK: Init
    
    init(
        viewModel: ConcertListViewModel,
        concertDetailViewControllerFactory: @escaping (ConcertId) -> ConcertDetailViewController,
        ticketReservationsViewControllerFactory: @escaping () -> TicketReservationsViewController
    ) {
        self.viewModel = viewModel
        self.concertDetailViewControllerFactory = concertDetailViewControllerFactory
        self.ticketReservationsViewControllerFactory = ticketReservationsViewControllerFactory
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
        
        self.bindOutputs()
        self.configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        self.viewModel.confirmCheckingTickets()
        self.viewModel.fetchConcertList(concertName: nil)
    }
}

// MARK: - Methods

extension ConcertListViewController {
    
    private func bindOutputs() {
        self.viewModel.output.checkingTicketCount
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, concerts in
                owner.mainCollectionView.reloadSections([0, 1], animationStyle: .automatic)
            }
            .disposed(by: self.disposeBag)
        
        self.viewModel.output.concerts
            .skip(1)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, concerts in
                owner.mainCollectionView.reloadSections([3], animationStyle: .automatic)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        
        self.mainCollectionView.register(CheckingTicketCollectionViewCell.self, forCellWithReuseIdentifier: CheckingTicketCollectionViewCell.className)
        self.mainCollectionView.register(ConcertListMainTitleCollectionViewCell.self, forCellWithReuseIdentifier: ConcertListMainTitleCollectionViewCell.className)
        self.mainCollectionView.register(SearchBarCollectionViewCell.self, forCellWithReuseIdentifier: SearchBarCollectionViewCell.className)
        self.mainCollectionView.register(ConcertCollectionViewCell.self, forCellWithReuseIdentifier: ConcertCollectionViewCell.className)
    }
}

// MARK: - UICollectionViewDelegate

extension ConcertListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let viewController = ticketReservationsViewControllerFactory()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else if indexPath.section == 3 {
            let viewController = concertDetailViewControllerFactory(self.viewModel.output.concerts.value[indexPath.row].id)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource

extension ConcertListViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.viewModel.output.checkingTicketCount.value
        case 3:
            return viewModel.output.concerts.value.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckingTicketCollectionViewCell.className, for: indexPath) as? CheckingTicketCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConcertListMainTitleCollectionViewCell.className, for: indexPath) as? ConcertListMainTitleCollectionViewCell else { return UICollectionViewCell() }
            cell.setTitle()
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchBarCollectionViewCell.className, for: indexPath) as? SearchBarCollectionViewCell else { return UICollectionViewCell() }
            
            cell.didSearchTap()
                .emit(with: self) { owner, _ in
                    self.viewModel.fetchConcertList(concertName: cell.searchBarTextField.text)
                }
                .disposed(by: self.disposeBag)
            
            return cell
        default:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConcertCollectionViewCell.className, for: indexPath) as? ConcertCollectionViewCell else { return UICollectionViewCell() }
            cell.setData(concertEntity: self.viewModel.output.concerts.value[indexPath.item])
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ConcertListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 52)
        case 1:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 96)
        case 2:
            return CGSize(width: self.mainCollectionView.frame.width - 40, height: 80)
        default:
            return CGSize(width: (self.mainCollectionView.frame.width - 40) / 2 - 7.5, height: 313 * self.view.frame.height / 812)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 3:
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 3:
            return 15
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 3:
            return 20
        default:
            return 0
        }
    }
}

// MARK: - UI

extension ConcertListViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        
        self.view.addSubview(self.mainCollectionView)
    }
    
    private func configureConstraints() {
        self.mainCollectionView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
}
