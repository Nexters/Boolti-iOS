//
//  MyPageViewController.swift
//  Boolti
//
//  Created by Miro on 1/20/24.
//

import UIKit

import UIKit
import RxSwift

final class MyPageViewController: UIViewController {
    
    // MARK: Properties

    private let viewModel: MypageViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component

    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("QR Reader", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()
    
    // MARK: Init
    
    init(viewModel: MypageViewModel) {
        self.viewModel = viewModel
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
                
                // 화면 테스트용
                owner.navigationController?.pushViewController(QRReaderViewController(), animated: true)
            })
            .disposed(by: self.disposeBag)
    }

}
