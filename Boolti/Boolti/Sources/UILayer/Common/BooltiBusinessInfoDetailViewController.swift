//
//  BooltiBusinessInfoDetailViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 3/13/24.
//

import UIKit

import RxSwift

final class BooltiBusinessInfoDetailViewController: UIViewController {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .backButtonWithTitle(title: "사업자 정보"))

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.configureConstraints()
        self.bindNavigationBar()
    }
}

// MARK: - Methods

extension BooltiBusinessInfoDetailViewController {
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension BooltiBusinessInfoDetailViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
}
