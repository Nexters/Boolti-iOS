//
//  PerformedConcertListViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 11/12/24.
//

import UIKit

import RxSwift
import RxCocoa

final class PerformedConcertListViewController: BooltiViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private var viewModel: PerformedConcertListViewModel
    
    private let concertDetailViewControllerFactory: (Int) -> ConcertDetailViewController
    
    // MARK: UI Components
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "출연한 공연"))
    
    private let concertCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.contentInset = .init(top: 20, left: 0, bottom: 20, right: 0)
        return collectionView
    }()
    
    // MARK: Initailizer
    
    init(viewModel: PerformedConcertListViewModel,
         concertDetailViewControllerFactory: @escaping (Int) -> ConcertDetailViewController) {
        self.viewModel = viewModel
        self.concertDetailViewControllerFactory = concertDetailViewControllerFactory

        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureCollectionView()
        self.bindUIComponents()
    }
    
}

// MARK: - Methods

extension PerformedConcertListViewController {
    
    private func bindUIComponents() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
        
        self.concertCollectionView.rx.itemSelected
            .map { $0.row }
            .subscribe(with: self) { owner, index in
                let concertId = owner.viewModel.concertList[index].id
                let concertDetailViewController = owner.concertDetailViewControllerFactory(concertId)
                owner.navigationController?.pushViewController(concertDetailViewController, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        self.concertCollectionView.delegate = self
        self.concertCollectionView.dataSource = self
        
        self.concertCollectionView.register(PerformedConcertCollectionViewCell.self, forCellWithReuseIdentifier: PerformedConcertCollectionViewCell.className)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PerformedConcertListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.concertList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PerformedConcertCollectionViewCell.className,
                                                            for: indexPath) as? PerformedConcertCollectionViewCell else { return UICollectionViewCell() }
        
        let concert = self.viewModel.concertList[indexPath.row]
        cell.setData(posterURL: concert.thumbnailPath,
                     title: concert.name,
                     datetime: concert.date.formatToDate())
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PerformedConcertListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.concertCollectionView.frame.width, height: 136)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

}


// MARK: - UI

extension PerformedConcertListViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
        self.view.addSubviews([self.navigationBar,
                               self.concertCollectionView])

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        self.concertCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
