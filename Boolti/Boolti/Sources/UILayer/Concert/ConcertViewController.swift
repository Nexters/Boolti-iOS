//
//  ConcertViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 1/20/24.
//

import UIKit
import RxSwift

class ConcertViewController: UIViewController {
    
    private let disposeBag = DisposeBag()

    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .yellow

        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        self.nextButton.rx.tap
            .bind(with: self, onNext: { owner, _ in
                owner.showBottomSheet()
            })
            .disposed(by: self.disposeBag)
    }

    func showBottomSheet() {
        
        // TODO: 나중에 ticket view에서 팩토리로 변경 필요 (이건 확인용!)
        let bottomSheetViewController = UINavigationController(rootViewController: SelectTicketViewController(viewModel: SelectTicketViewModel()))
        present(bottomSheetViewController, animated: true, completion: nil)
    }
}
