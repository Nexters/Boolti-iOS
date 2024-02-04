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

    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
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
        
        self.view.backgroundColor = .grey95

        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        self.nextButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                let viewController = self.concertDetailViewControllerFactory()
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}
