//
//  ConcertListViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit

import RxSwift

final class ConcertListViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: ConcertListViewModel
    private let disposeBag = DisposeBag()
    private let concertDetailViewControllerFactory: () -> ConcertDetailViewController
    
    // MARK: UI Component
    
    private let concertCollectionView: UICollectionView = {
        let layout = ConcertCollectionViewFlowLayout(stickyIndexPath: IndexPath(item: 1, section: 0))
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()



    // MARK: Init
    
    init(
        viewModel: ConcertListViewModel,
        concertDetailViewControllerFactory: @escaping () -> ConcertDetailViewController
    ) {
        self.viewModel = viewModel
        self.concertDetailViewControllerFactory = concertDetailViewControllerFactory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}

// MARK: - UI

extension ConcertListViewController {
    
    private func configureUI() {
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        
    }
}
