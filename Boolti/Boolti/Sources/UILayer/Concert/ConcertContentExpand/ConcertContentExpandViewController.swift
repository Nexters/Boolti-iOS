//
//  ConcertContentExpandViewController.swift
//  Boolti
//
//  Created by Juhyeon Byun on 2/6/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ConcertContentExpandViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: ConcertContentExpandViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: UI Component
    
    private let navigationBar = BooltiNavigationBar(type: .concertContentExpand)
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .pretendardR(16)
        label.textColor = .grey30
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // MARK: Init
    
    init(viewModel: ConcertContentExpandViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.configureUI()
        self.configureConstraints()
        self.bindOutputs()
        self.bindNavigationBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension ConcertContentExpandViewController {
    
    private func bindOutputs() {
        self.viewModel.output.content
            .bind(with: self) { owner, content in
                owner.contentLabel.text = content
                owner.contentLabel.setLineSpacing(lineSpacing: 6)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func bindNavigationBar() {
        self.navigationBar.didBackButtonTap()
            .emit(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
}

// MARK: - UI

extension ConcertContentExpandViewController {
    
    private func configureUI() {
        self.view.addSubviews([self.navigationBar, self.contentLabel])
        
        self.view.backgroundColor = .grey95
    }
    
    private func configureConstraints() {
        self.navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.top.equalTo(self.navigationBar.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
