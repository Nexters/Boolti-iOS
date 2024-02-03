//
//  ConcertViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit
import RxSwift

final class ConcertViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: ConcertViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component

    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()
    
    let qrImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // MARK: Init
    
    init(viewModel: ConcertViewModel) {
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
        
        self.view.addSubview(qrImageView)
        
        self.qrImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.nextButton.snp.bottom).offset(50)
            make.width.height.equalTo(200)
        }
        
        self.nextButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showBottomSheet()
            })
            .disposed(by: self.disposeBag)
        
        // identifier에 서버가 준 고유값 넣기
        let qrImage = QRMaker().makeQR(identifier: "B8273H")
        self.qrImageView.image = qrImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
}

// MARK: - Methods

extension ConcertViewController {
    func showBottomSheet() {
        
        // TODO: 나중에 ticket view에서 팩토리로 변경 필요 (이건 확인용!)
        self.present(TicketSelectionDIContainer().createTicketSelectionViewController(), animated: true)
    }
}
